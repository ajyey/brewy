//
//  ViewController.swift
//  App_GUI
//
//  Created by AJ Leonard on 1/21/19.
//  Copyright © 2019 AJ Leonard. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON
import PromiseKit

class ViewController: NSViewController {
    var apps:[String: App]=[:]
    let githubRaw = "https://raw.githubusercontent.com/Homebrew/homebrew-cask/master/Casks/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var title:String=""
        let myGroup = DispatchGroup()
        createListOfApps(mydispatch: myGroup)
        myGroup.notify(queue: .main){
            title="Click Me!"
            let myButton = NSButton(title: title, target: self, action: #selector(self.myButtonAction))
            self.view.addSubview(myButton)
            //sort apps by name 
//            self.apps.sort(by: {$0.name < $1.name})
//            print(self.apps["google-chrome"]!.homepage)
            let appArray = Array(self.apps.values).sorted(by: {$0.name < $1.name})
        }
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @objc func myButtonAction(sender: NSButton!) {
        sender.title="You clicked me!"
        //resizes the button to fit new title/contents
        sender.sizeToFit()
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
                    let url = githubRaw + cask
                    Alamofire.request(url).responseString{
                        response in
                        //gets the expected content length from the http header response. This will be useful when showing download progress for apps
                        //this currently converts bytes to megabytes by dividing by 1000000
                        let sizeOfContent = Float(response.response!.expectedContentLength as Int64)/1000000
//                        print(sizeOfContent)
                        switch(response.result) {
                        case .success(_):
                            if let data = response.result.value {
                                let appObj:App = self.parseGithubRaw(githubRaw: data, cask: cask)
                                self.apps[appObj.caskName] = appObj
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
    func parseGithubRaw(githubRaw:String, cask:String) -> App {
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

