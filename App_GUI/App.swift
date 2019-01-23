//
//  App.swift
//  App_GUI
//
//  Created by AJ Leonard on 1/22/19.
//  Copyright © 2019 AJ Leonard. All rights reserved.
//

import Foundation

class App {
    var githubRaw: String
    var name: String?
    var url: String?
    var version: String?
    var caskName:String?
    
    //MARK: Initialization
    init?(githubRaw:String){
        //test for github_raw empty
        if(githubRaw.isEmpty){
            return nil
        }
        self.githubRaw = githubRaw

    }
    
    func parseGithubRaw(){
        //parse github raw file and set this app's fields
        //Order for parsing
        /*
         1. Version
         2. URL
         3. App name
         4. Zap Trash for full uninstallation
         5. Cask name
         
         */
    }
}
