//
//  Util.swift
//  App_GUI
//
//  Created by AJ Leonard on 2/4/19.
//  Copyright © 2019 AJ Leonard. All rights reserved.
//

import Foundation

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
        // #{version.dots_to_hyphens}
        if temp.contains(Constants.VERSION_DOTS_TO_HYPHENS){
            let dotsToHyphens = version.replacingOccurrences(of: ".", with: "-")
            temp = temp.replacingOccurrences(of: Constants.VERSION_DOTS_TO_HYPHENS, with: dotsToHyphens)
        }
        // #{version.dots_to_underscores}
        if temp.contains(Constants.VERSION_DOTS_TO_UNDERSCORES){
            let dotsToUnderscores = version.replacingOccurrences(of: ".", with: "_")
            temp = temp.replacingOccurrences(of: Constants.VERSION_DOTS_TO_UNDERSCORES, with: dotsToUnderscores)
        }
        // #{version.major_minor}
        if temp.contains(Constants.VERSION_MAJOR_MINOR){
            let versionSplit = version.split(separator: ".")
            let majorMinor = versionSplit[0]+"."+versionSplit[1]
            temp = temp.replacingOccurrences(of: Constants.VERSION_MAJOR_MINOR, with: majorMinor)
        }
        // #{version.major_minor_patch}
        if temp.contains(Constants.VERSION_MAJOR_MINOR_PATCH){
            let versionSplit = version.split(separator: ".")
            let majorMinorPatch = versionSplit[0]+"."+versionSplit[1]+"."+versionSplit[2]
            temp = temp.replacingOccurrences(of: Constants.VERSION_MAJOR_MINOR_PATCH, with: majorMinorPatch)
        }
        // #{version.no_dots}
        if temp.contains(Constants.VERSION_NO_DOTS){
            let noDots = version.replacingOccurrences(of: ".", with: "")
            temp = temp.replacingOccurrences(of: Constants.VERSION_NO_DOTS, with: noDots)
        }
        // #{version.after_colon}
        if temp.contains(Constants.VERSION_AFTER_COLON){
            let afterColon = version.split(separator: ":")[1]
            temp = temp.replacingOccurrences(of: Constants.VERSION_AFTER_COLON, with: afterColon)
        }
        // #{version.after_comma_before_colon}
        if temp.contains(Constants.VERSION_AFTER_COMMA_BEFORE_COLON){
            let afterComma = version.split(separator: ",")[1]
            let beforeColon = afterComma.split(separator: ":")[0]
            temp = temp.replacingOccurrences(of: Constants.VERSION_AFTER_COMMA_BEFORE_COLON, with: beforeColon)
        }
        // #{macos_release}
        if temp.contains(Constants.MACOS_RELEASE){
            let osMajorVersion = String(ProcessInfo().operatingSystemVersion.majorVersion)
            let osMinorVersion = String(ProcessInfo().operatingSystemVersion.minorVersion)
            let macosRelease = osMajorVersion+osMinorVersion
            temp = temp.replacingOccurrences(of: Constants.MACOS_RELEASE, with: macosRelease)
        }
        // #{language}
        //TODO: This only handles english US for firefox right now. In the future, add support for multiple languages
        if temp.contains(Constants.LANGUAGE){
            temp = temp.replacingOccurrences(of: Constants.LANGUAGE, with: "en-US")
        }
//        print(temp)
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
    
    static func handleMultipleVersionsAndURLs(githubRaw:String) -> String {
        var gh = githubRaw
        
        
        return ""
    }
    
}
