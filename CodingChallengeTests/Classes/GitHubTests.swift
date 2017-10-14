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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPatchFileLines() {
        
        guard let patch = loadPatchFile("Patch0") else {
            XCTFail("Unable to load patch file")
            return
        }
        
        let lines = patch.components(separatedBy: .newlines)
        XCTAssertFalse(lines.isEmpty, "🤔 The file has no lines")
        print("🐝 \(lines.count)")
        print("🐸 \(patch)")
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
