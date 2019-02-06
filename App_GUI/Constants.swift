//
//  Constants.swift
//  App_GUI
//
//  Created by AJ Leonard on 2/4/19.
//  Copyright © 2019 AJ Leonard. All rights reserved.
//

import Foundation

struct Constants {
    
    //version permutations
    static let VERSION = "#{version}"
    static let VERSION_MAJOR = "#{version.major}"
    static let VERSION_MINOR = "#{version.minor}"
    static let VERSION_PATCH = "#{version.patch}"
    static let VERSION_BEFORE_COMMA = "#{version.before_comma}"
    static let VERSION_AFTER_COMMA = "#{version.after_comma}"
    static let VERSION_DOTS_TO_HYPHENS = "#{version.dots_to_hyphens}"
    static let VERSION_DOTS_TO_UNDERSCORES = "#{version.dots_to_underscores}"
    static let VERSION_MAJOR_MINOR = "#{version.major_minor}"
    static let VERSION_MAJOR_MINOR_PATCH = "#{version.major_minor_patch}"
    static let VERSION_NO_DOTS = "#{version.no_dots}"
    static let VERSION_AFTER_COLON = "#{version.after_colon}"
    static let VERSION_AFTER_COMMA_BEFORE_COLON = "#{version.after_comma.before_colon}"
    static let MACOS_RELEASE = "#{macos_release}"
    static let LANGUAGE = "#{language}"
    
    static let HDIUTIL = "/usr/bin/hdiutil"
}
