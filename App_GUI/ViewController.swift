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

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //url for the github raw data
        let githubRaw = "https://raw.githubusercontent.com/Homebrew/homebrew-cask/master/Casks/"
//        var casks = [String]
        
        //read the file in the resources folder
        if let path = Bundle.main.path(forResource: "cask_names", ofType: "txt" , inDirectory: "Resources"){
            let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            let casks = text.components(separatedBy: .newlines)
            var count = 0
            for cask in casks{
                let url = githubRaw+cask
                Alamofire.request(url)
                    .responseString{ response in
                        switch(response.result) {
                        case .success(_):
                            if let data = response.result.value{
                                //separate the files
                                let com = data.components(separatedBy: .newlines)
                                var version = ""
                                var url = ""
                                for item in com {
                                    //split on space
                                    let line = item.trimmingCharacters(in: .whitespacesAndNewlines)
                                    let lineSep = line.components(separatedBy: .whitespaces)
                                    

                                    
                                    //get the version
                                    if(lineSep[0]=="version"){
                                        version = lineSep[1].replacingOccurrences(of: "'", with: "")
                                    }
                                    if(lineSep[0]=="url"){
                                        var url = ""
                                        for i in 1..<lineSep.count{
                                            url+=lineSep[i]
                                        }
                                        url = url.replacingOccurrences(of: "'", with: "")
                                        url = url.replacingOccurrences(of: "\"", with: "")
                                        print(url)
//                                        if(url.contains(".pkg")){
//                                            print(url)
//                                        }

//                                        if(url.contains("#{version}")){
//                                            url = url.replacingOccurrences(of: "#{version}", with: version)
//                                        }
                                        //perform the download
//                                        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//
//                                            let home = FileManager.default.homeDirectoryForCurrentUser
//                                            var downloadsFolder = home.appendingPathComponent("Downloads")
//                                            downloadsFolder.appendPathComponent("chrome.dmg")
//                                            return (downloadsFolder, [.removePreviousFile])
//                                        }
//                                        Alamofire.download(url, to: destination).downloadProgress { progress in
//                                            print("Progress: \(progress.fractionCompleted)")
//                                        }

                                    }
                                    
                                }
                            }
                        case .failure(_):
                            print("Error message:\(String(describing: response.result.error))")
                            break
                        }
                }
            }
        }else{
            print("File not found")
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

