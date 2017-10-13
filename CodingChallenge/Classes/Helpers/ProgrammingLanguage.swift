//
//  ProgrammingLanguage.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/13/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import UIKit

enum ProgrammingLanguage: String {
    
    case c = "C"
    case cPlusPlus = "C++"
    case go = "Go"
    case java = "Java"
    case javaScript = "JavaScript"
    case objectiveC = "Objective-C"
    case python = "Python"
    case shell = "Shell"
    case swift = "Swift"

    // Color coding for the language
    var color: UIColor {
        switch self {
        case .c:
            return UIColor.black
        case .cPlusPlus:
            return UIColor.red
        case .go:
            return UIColor.green
        case .java:
            return UIColor.purple
        case .javaScript:
            return UIColor.yellow
        case .objectiveC:
            return UIColor(red: 44/255, green: 152/255, blue: 239/255, alpha: 1.0)
        case .python:
            return UIColor(red: 65/255, green: 84/255, blue: 178/255, alpha: 1.0)
        case .shell:
            return UIColor(red: 140/255, green: 192/255, blue: 82/255, alpha: 1.0)
        case .swift:
            return UIColor.orange
        }
    }
}
