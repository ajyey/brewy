import Cocoa
import Alamofire
import SwiftyJSON
import Foundation
class ViewController: NSViewController {
    var apps:[String: App]=[:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var title:String=""
        let myGroup = DispatchGroup()
        createListOfApps(mydispatch: myGroup)
        myGroup.notify(queue: .main){
            title="Download Evernote"
            let myButton = NSButton(title: title, target: self, action: #selector(self.myButtonAction))
            self.view.addSubview(myButton)
//            for app in self.apps {
//                print(app.value.description)
//            }
            //sort apps by name
//            self.apps.sort(by: {$0.name < $1.name})
//            print(self.apps["google-chrome"]!.homepage)
//            let appArray = Array(self.apps.values).sorted(by: {$0.name < $1.name})
        }
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @objc func myButtonAction(sender: NSButton!) {
        sender.title="Downloading..."
        //resizes the button to fit new title/contents
        sender.sizeToFit()
        let url = self.apps["Evernote"]!.url
        print(url)
        //download evernote
        //gets the suggested download destination (filename)
        let destination = DownloadRequest.suggestedDownloadDestination(for: .downloadsDirectory)
        //TODO: this should be in its own thread so we dont lock up the gui while performing the download and installation
        Alamofire.download(url, to: destination)
            .downloadProgress {progress in
                print("Progress: \(Double(round(progress.fractionCompleted*1000)/1000))")
            }
            .response{
                response in
                //get the suggested file name chosen by alamofire
                print("Evernote downloaded..")
                print("Converting dmg..")
//                let destination = response.destinationURL!.absoluteString.split(separator: "/")
                let fullPath = response.destinationURL!.absoluteString
                let dmg = response.destinationURL!
                print(fullPath)
//                let fileName = destination[destination.count-1]
                //convert the dmg to cdr of the same name
                let fm = FileManager.default
                let downloadsUrl = try! fm.url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//                print(downloadsUrl+"Evernote.cdr")
                let cdrPath = downloadsUrl.appendingPathComponent("Evernote.cdr").absoluteString
                let removeCdr = downloadsUrl.appendingPathComponent("Evernote.cdr")
                //convert evernote to cdr so we can bypass the EULA
                let args = "convert \(fullPath) -format UDTO -ov -o \(cdrPath)"
                print(cdrPath)
                Util.runCommand(cmd: Constants.HDIUTIL, args: args.components(separatedBy: " "))
                //delete the dmg after converting it to cdr
                try! fm.removeItem(at: dmg)
                //mount the volume
                print("dmg converted.")
                let mountArgs = "attach -nobrowse /Users/AJ/Downloads/Evernote.cdr"
//                print(fullPath)
                let (error, _, status) = Util.runCommand(cmd: Constants.HDIUTIL, args: mountArgs.components(separatedBy: " "))
                if(status == 1){
                    print("An error occured")
                    print(error)
                }else if(status==0){
                    print("success")
                }
                //now move the application from the mounted volume into the applications folder
                //check if the file already exists
                if fm.fileExists(atPath: "/Applications/Evernote.app"){
                    try! fm.removeItem(atPath: "/Applications/Evernote.app")
                }
                try! fm.copyItem(atPath: "/Volumes/Evernote/Evernote.app", toPath: "/Applications/Evernote.app")
                //delete the cdr file
                print("Removing cdr")
                try! fm.removeItem(at:removeCdr)
                //now unmount the volume
                let unmount = "detach /Volumes/Evernote"
                var (e , _, s) = Util.runCommand(cmd: Constants.HDIUTIL, args: unmount.components(separatedBy: " "))
                if(s == 1){
                    print("An error occured")
                    print(e)
                }else if(s==0){
                    print("unmounted")
                }

                
        }
    }
    
    func installAppFromDMG(file:String) {
        //
    }
    
    func createListOfApps(mydispatch:DispatchGroup){
        //check if the cask list exists
        if let path = Bundle.main.path(forResource: "cask_names", ofType: "txt" , inDirectory: "Resources"){
            //get the contents of the file
            let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            //separate the casks by newlines
            let casks = text.components(separatedBy: .newlines)
                for cask in casks{
                    if(cask.isEmpty){
                        continue
                    }
                    mydispatch.enter()
                    let url = Constants.GITHUB_RAW_URL + cask
                    Alamofire.request(url).responseString{
                        response in
                        //gets the expected content length from the http header response. This will be useful when showing download progress for apps
                        //this currently converts bytes to megabytes by dividing by 1000000
                        let sizeOfContent = Double((response.response!.expectedContentLength as Int64)/1000000)
                        switch(response.result) {
                        case .success(_):
                            if let githubResponse = response.result.value {
                                let app:App = self.parseGithubRaw(using: githubResponse, for: cask)
                                self.apps[app.name.components(separatedBy: ".app")[0]] = app
                                mydispatch.leave()
                            }
                        case .failure(_):
                            mydispatch.leave()
                            print("Error message:\(String(describing: response.result.error))")
                            break
                        }
                    }
                }
        }else{
            print("File not found")
        }
    }
    func parseGithubRaw(using githubRaw:String, for cask:String) -> App {
        //TODO: Parse the github raw gile, create a new app object and return it to the main view controller to be added to the array of apps
//        print(githubRaw)
        let separatedByNewline = githubRaw.components(separatedBy: .newlines)
        var version:String = ""
        var url:String = ""
        var app:String = ""
        var homepage:String = ""
        //TODO: down the line, here is where we would handle apps with different versions and urls for different macos versions. For now, we will assume the user is running either High Sierra or Mojave
        for line in separatedByNewline {
            let currentLineTrimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            let split = currentLineTrimmed.components(separatedBy: .whitespaces)
//            print(currentLineTrimmed)
            switch split[0] {
            case "app":
//                print(split)
                app = currentLineTrimmed.components(separatedBy: "app ")[1]
                if app.contains("target: ") {
                    app = app.components(separatedBy: "target: ")[1]
                }
                app = Util.removeLeadingAndTrailingQuotationMarks(str: app)
//                print(app)
            case "version":
                version = currentLineTrimmed.components(separatedBy: "version ")[1]
                version = Util.removeLeadingAndTrailingQuotationMarks(str: version)
//                print(version)
            case "url":
                if(url != ""){
//                    print(cask)
                }
                url = currentLineTrimmed.components(separatedBy: "url ")[1]
                url = Util.removeLeadingAndTrailingQuotationMarks(str: url)
//                print(url)
                //TODO: create method to handle all replacing
                url = Util.replaceVersionsInURLs(url: url, version: version)
//                print(url)
                
            case "homepage":
                homepage = currentLineTrimmed.components(separatedBy: "homepage ")[1]
                homepage = Util.removeLeadingAndTrailingQuotationMarks(str: homepage)
                homepage = Util.replaceVersionsInURLs(url: homepage, version: version)
//                print(homepage)
            default:
                break
            }
        }
        return App(githubRaw: githubRaw, name: app, url: url, version: version, caskName: cask.replacingOccurrences(of: ".rb", with: ""), homepage: homepage)
    }
    
}
            
//            for cask in casks {
//                //empty line check
//                if(cask.isEmpty){
//                    continue
//                }
//                let url = githubRaw + cask
//                Alamofire.request(url).responseString{
//                    response in
//                    switch(response.result) {
//                    case .success(_):
//                        if let data = response.result.value {
//                            //separate the files
//                            self.apps.append(App(github_raw: data)!)
//                            print(self.apps.count)
//                            print(self.apps[0].github_raw)
////                            let com = data.components(separatedBy: .newlines)
////                            var version = ""
////                            var url = ""
////                            var app = ""
//                            for item in com {
//                                //split on space
//                                let line = item.trimmingCharacters(in: .whitespacesAndNewlines)
//                                let lineSep = line.components(separatedBy: .whitespaces)
//                                //get the app name
//                                if(lineSep[0]=="app"){
//                                    for i in 1..<lineSep.count{
//                                        app+=lineSep[i]
//                                    }
//                                    app = String(app.split(separator: ".")[0])
//                                    print(app)
//                                }
//                                //get the version
//                                if(lineSep[0]=="version"){
//                                    version = lineSep[1].replacingOccurrences(of: "'", with: "")
//                                }
//                                if(lineSep[0]=="url"){
//                                    var url = ""
//                                    for i in 1..<lineSep.count{
//                                        url+=lineSep[i]
//                                    }
//                                    url = url.replacingOccurrences(of: "'", with: "")
//                                    url = url.replacingOccurrences(of: "\"", with: "")
//
//                                    if(url.contains("#{version}")){
//                                        url = url.replacingOccurrences(of: "#{version}", with: version)
//                                    }
//                                    //perform the download
//                                    let destination = DownloadRequest.suggestedDownloadDestination(for: .downloadsDirectory)
//                                    Alamofire.download(url, to: destination)
//                                        .downloadProgress {progress in
//                                            print("Progress: \(Double(round(progress.fractionCompleted*1000)/1000))")
//                                        }
//                                        .response{
//                                            response in
//                                            //get the suggested file name chosen by alamofire
//                                            let destination = response.destinationURL!.absoluteString.split(separator: "/")
//                                            let fileName = destination[destination.count-1]
//                                            print(fileName)
//                                    }
//                                }
//                            }
//                        }
//                    case .failure(_):
//                        print("Error message:\(String(describing: response.result.error))")
//                        break
//                    }
//                }

