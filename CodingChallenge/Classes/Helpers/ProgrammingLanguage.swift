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
            return UIColor.cyan
        case .python:
            return UIColor.blue
        case .shell:
            return UIColor.brown
        case .swift:
            return UIColor.orange
        }
    }
}
