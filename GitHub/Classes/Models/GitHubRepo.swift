//
//  GitHubRepo.swift
//  GitHub
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import Foundation

// Represents a Reop
public struct GitHubRepo: Codable {
    
    public var name: String
    public var description: String
    public var pullsUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case pullsUrl = "pulls_url"
    }
    
    // Use a custom decoder to cleanup the pulls url
    // This is done since we can't use the didSet {} observer since it won't fire inside an init() 😢
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        pullsUrl = try values.decode(String.self, forKey: .pullsUrl).replacingOccurrences(of: "{/number}", with: "")
    }
}

