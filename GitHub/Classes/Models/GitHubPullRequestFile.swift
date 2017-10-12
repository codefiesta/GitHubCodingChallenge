//
//  GitHubPullRequestFile.swift
//  GitHub
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import Foundation

// Represents a Pull Request File
public struct GitHubPullRequestFile: Codable {
    
    public var name: String
    public var status: String
    public var additions: Int
    public var deletions: Int
    public var changes: Int
    public var contentsUrl: String
    public var patch: String
    
    public lazy var leftLines: [String] = {
        let lines = patch.components(separatedBy: .newlines).filter({ (line) -> Bool in
            return !line.starts(with: "+")
        })
        return lines
    }()

    public lazy var rightLines: [String] = {
        let lines = patch.components(separatedBy: .newlines).filter({ (line) -> Bool in
            return !line.starts(with: "-")
        })
        return lines
    }()

    enum CodingKeys: String, CodingKey {
        case name = "filename"
        case status
        case additions
        case deletions
        case changes
        case contentsUrl = "contents_url"
        case patch
    }
}
