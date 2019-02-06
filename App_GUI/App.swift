//
//  App.swift
//  App_GUI
//
//  Created by AJ Leonard on 1/22/19.
//  Copyright © 2019 AJ Leonard. All rights reserved.
//

import Foundation

class App : CustomStringConvertible {
    var githubRaw: String
    var name: String
    var url: String
    var version: String
    var caskName:String
    var homepage:String
    
    public var description: String {
        return """
        Name: \(name),
        URL: \(url),
        Version: \(version),
        Cask: \(caskName),
        Homepage: \(homepage)\n
        """
    }
    
    //MARK: Initialization
    init(githubRaw:String, name:String, url:String, version:String, caskName:String, homepage:String){
        self.githubRaw = githubRaw
        self.name = name
        self.url = url
        self.version = version
        self.caskName = caskName
        self.homepage = homepage
    }
}
