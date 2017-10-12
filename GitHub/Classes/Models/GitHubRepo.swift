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
    public var description: String?
    public var language: String?
    public var starGazers: Int
    public var forks: Int
    public var watchers: Int
    public var pullsUrl: String
    public var updated: Date
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case language
        case starGazers = "stargazers_count"
        case forks = "forks_count"
        case watchers = "watchers_count"
        case pullsUrl = "pulls_url"
        case updated = "updated_at"
    }
    
    // Use a custom decoder to cleanup the pulls url
    // This is done since we can't use the didSet {} observer since it won't fire inside an init() 😢
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        starGazers = try values.decode(Int.self, forKey: .starGazers)
        forks = try values.decode(Int.self, forKey: .forks)
        watchers = try values.decode(Int.self, forKey: .watchers)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        pullsUrl = try values.decode(String.self, forKey: .pullsUrl).replacingOccurrences(of: "{/number}", with: "")
        updated = try values.decode(Date.self, forKey: .updated)
    }
}

