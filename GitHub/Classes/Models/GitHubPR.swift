//
//  GitHubPR.swift
//  GitHub
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import Foundation

// Represents a PR
public struct GitHubPR: Codable {
    
    public var number: Int
    public var title: String
    public var state: String
    public var diffUrl: String
    
    enum CodingKeys: String, CodingKey {
        case number
        case title
        case state
        case diffUrl = "diff_url"
    }
}
