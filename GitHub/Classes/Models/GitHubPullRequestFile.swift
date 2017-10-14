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
    public var patch: String?

    // All of the path file lines
    public lazy var lines: [String] = {
        guard let patch = patch else {
            return []
        }
        return patch.components(separatedBy: "\n") // For some reason seeing empty lines on .newLines
    }()

    public lazy var length: Int = {
        return patch?.lengthOfBytes(using: .utf8) ?? 0
    }()

    // Build a tuple of headers
    public lazy var header: (fromFileStart: Int, fromLines: Int, toFileStart: Int, toLines: Int) = {
        
        guard !lines.isEmpty, let header = lines.first else {
            return (0,0,0,0)
        }
        
        let pattern = "@@ \\-([0-9]+),([0-9]+) \\+([0-9]+),([0-9]+) @@(.+)?"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matches = regex.matches(in: header, options: .reportCompletion, range: NSMakeRange(0, header.utf16.count))
            if !matches.isEmpty {
                
                var fromStart = 0
                var fromLines = 0
                var toStart = 0
                var toLines = 0
                for match in matches {
                    fromStart = Int(header.substring(with: match.range(at: 1))) ?? 0
                    fromLines = Int(header.substring(with: match.range(at: 2))) ?? 0
                    toStart = Int(header.substring(with: match.range(at: 3))) ?? 0
                    toLines = Int(header.substring(with: match.range(at: 4))) ?? 0
                }
                return (fromStart, fromLines, toStart, toLines)
            }
        } catch {
            print("Error: \(error)")
        }

        return (0,0,0,0)
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

extension String {
    
    func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
}

extension Int {
    
    init?(_ substring: Substring?) {
        guard let substring = substring else {
            self.init(0)
            return
        }
        let string = String(substring)
        self.init(string)
    }
}
