//
//  GitHubSearchResults.swift
//  GitHub
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import Foundation

public struct GitHubSearchResults: Codable {
    
    public var totalCount: Int
    public var users: [GitHubUser]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case users = "items"
    }
}
