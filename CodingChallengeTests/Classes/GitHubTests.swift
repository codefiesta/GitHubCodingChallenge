//
//  GitHubTests.swift
//  GitHubTests
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import XCTest
@testable import GitHub

class GitHubTests: XCTestCase {
    
    
    fileprivate let headerPattern = "@@ \\-([0-9]+),([0-9]+) \\+([0-9]+),([0-9]+) @@"
    fileprivate let deletionLinePattern = "\n(\\-.*?)"
    //fileprivate let additionLinePattern = "[^\n\r]*"
    //fileprivate let additionLinePattern = "[\n][\\+][^\n\r]*"
    //fileprivate let additionLinePattern = "[\\+]"
    fileprivate let additionLinePattern = "([^\n])([\\+])"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPatchRegex() {
        
        guard let patch = loadPatchFile("Patch0") else {
            XCTFail("Unable to load patch file")
            return
        }
        
        var scrubbed = replace(patch, headerPattern)
        XCTAssertFalse(scrubbed.contains("@@"), "🤔 The file still has headers!")
        print("😻 \(scrubbed)")
        scrubbed = replace(patch, additionLinePattern)
        print("🤢 \(scrubbed)")
        
    }
    
    func replace(_ text: String, _ pattern: String) -> String {
        var scrubbed = text
        do {
            
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: text.characters.count)
            scrubbed = regex.stringByReplacingMatches(in: text, options: .reportCompletion, range: range, withTemplate: "🐣")
        } catch {
            print("Error Matching: \(error)")
        }
        return scrubbed
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func loadPatchFile(_ name: String) -> String? {
        
        guard let url = Bundle(for: type(of: self)).url(forResource: name, withExtension: "txt") else {
            return nil
        }
        
        do {
            let string = try String(contentsOf: url)
            return string
        } catch {
            print("Error loading test patch file: \(error)")
        }
        return nil

    }
    
}
