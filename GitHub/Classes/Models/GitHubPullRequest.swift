//
//  GitHubPullRequest.swift
//  GitHub
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import Foundation

// Represents a Pull Request
public struct GitHubPullRequest: Codable {
    
    public var number: Int
    public var title: String
    public var state: String
    public var url: String
    public var diffUrl: String
    
    public var filesUrl: String {
        get {
            return "\(url)/files"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case number
        case title
        case state
        case url
        case diffUrl = "diff_url"
    }
}
