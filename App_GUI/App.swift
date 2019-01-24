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
    var name: String
    var url: String
    var version: String
    var caskName:String
    
    //MARK: Initialization
    init(githubRaw:String, name:String, url:String, version:String, caskName:String){
        self.githubRaw = githubRaw
        self.name = name
        self.url = url
        self.version = version
        self.caskName = caskName
    }
}
