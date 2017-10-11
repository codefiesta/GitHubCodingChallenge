//
//  GitHubUser.swift
//  GitHub
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import Foundation

// Represents a User or Organization
public struct GitHubUser: Codable {
    
    public var login: String
    public var avatarUrl: String
    public var reposUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case reposUrl = "repos_url"
    }
}
