//
//  PatchLabel.swift
//  PatchLabel
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import UIKit

// Attributes the lines of a Patch file
// Inspired from ActiveLabel cocoapod: https://github.com/optonaut/ActiveLabel.swift
open class PatchLabel: UILabel {
    
    fileprivate let firstLinePattern = "^(.+)\n"
    fileprivate let deletionLinePattern = "\n(\\-\\s.*)"
    fileprivate let additionLinePattern = "\n(\\+\\s.*)"

    override open var text: String? {
        didSet {
            attribute()
        }
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    fileprivate func attribute() {
        
        guard let text = text else {
            return
        }
        
        if attributedText == nil {
            let attributedString = NSMutableAttributedString(string: text)
            attributedText = attributedString
        }
        
        attributeFirstLine()
        attributeAdditionLines()
        attributeDeletionLines()
    }
    
    fileprivate func attributeFirstLine() {
        
        guard let attributedString = attributedText as? NSMutableAttributedString else {
            return
        }
        
        let matches = match(firstLinePattern)
        for match in matches {
            let range = match.range(at: 1)
            attributedString.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor.blue.withAlphaComponent(0.05), range: range)
        }
    }

    fileprivate func attributeAdditionLines() {
        guard let attributedString = attributedText as? NSMutableAttributedString else {
            return
        }
        
        let matches = match(additionLinePattern)
        for match in matches {
            let range = match.range(at: 1)
            attributedString.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor.green.withAlphaComponent(0.05), range: range)
        }
    }

    fileprivate func attributeDeletionLines() {
        guard let attributedString = attributedText as? NSMutableAttributedString else {
            return
        }
        
        let matches = match(deletionLinePattern)
        for match in matches {
            let range = match.range(at: 1)
            attributedString.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor.red.withAlphaComponent(0.05), range: range)
        }
    }
    
    // Finds the regex matches
    fileprivate func match(_ regex: String) -> [NSTextCheckingResult] {
        
        guard let text = text else {
            return []
        }

        do {
            let regex = try NSRegularExpression(pattern: regex, options: .caseInsensitive)
            let matches = regex.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.utf16.count))
            return matches
        } catch {
            print("Error Matching: \(error)")
        }
        return []
    }
}
