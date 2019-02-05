//
//  Util.swift
//  App_GUI
//
//  Created by AJ Leonard on 2/4/19.
//  Copyright © 2019 AJ Leonard. All rights reserved.
//

import Foundation


/*
 TODO: Write a function that takes in a version string, takes in a string to replace the version into
 and then performs all of the logic for replacing the possible permutations of versions (version.major, etc)
 Add in logic as we keep adding apps
 */
class Util {
    static func replaceVersionsInURLs(url:String, version:String) -> String {
        var temp = url
        
        // #{version}
        if temp.contains(Constants.VERSION){
            temp = temp.replacingOccurrences(of: Constants.VERSION, with: version)
        }
        // #{version.major}
        if temp.contains(Constants.VERSION_MAJOR){
            let versionMajor = version.split(separator: ".")[0]
            temp = temp.replacingOccurrences(of: Constants.VERSION_MAJOR, with: versionMajor)
        }
        // #{version.minor}
        if temp.contains(Constants.VERSION_MINOR){
            let versionMinor = version.split(separator: ".")[1]
            temp = temp.replacingOccurrences(of: Constants.VERSION_MINOR, with: versionMinor)
        }
        // #{version.patch}
        if temp.contains(Constants.VERSION_PATCH){
            let versionPatch = version.split(separator: ".")[2]
            temp = temp.replacingOccurrences(of: Constants.VERSION_PATCH, with: versionPatch)
        }
        // #{version.before_comma}
        if temp.contains(Constants.VERSION_BEFORE_COMMA){
            let beforeComma = version.split(separator: ",")[0]
            temp = temp.replacingOccurrences(of: Constants.VERSION_BEFORE_COMMA, with: beforeComma)
        }
        // #{version.after_comma}
        if temp.contains(Constants.VERSION_AFTER_COMMA){
            let afterComma = version.split(separator: ",")[1]
            temp = temp.replacingOccurrences(of: Constants.VERSION_AFTER_COMMA, with: afterComma)
        }
        
        return temp
    }
    //  Removes leading and trailing quotation marks from all of the desired fields
    static func removeLeadingAndTrailingQuotationMarks(str:String)->String{
        var temp = str
        if(temp.prefix(1)=="'" || temp.prefix(1)=="\""){
            temp.remove(at: temp.startIndex)
        }
        if(temp.suffix(1)=="'" || temp.suffix(1)=="\""){
            temp.remove(at: temp.index(before: temp.endIndex))
        }
        return temp
    }
    
}
