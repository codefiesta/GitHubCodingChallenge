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
    
    fileprivate static let firstLinePattern = "^(.+)\n"
    fileprivate static let deletionLinePattern = "\n(\\-.*)"
    fileprivate static let additionLinePattern = "\n(\\+.*)"

    fileprivate let attributions: [String: Any] = [
        firstLinePattern: UIColor.blue.withAlphaComponent(0.05),
        deletionLinePattern: UIColor.red.withAlphaComponent(0.05),
        additionLinePattern: UIColor.green.withAlphaComponent(0.05)
    ]

    // If set to true, will remove the addition lines, otherwise remove the deletion lines
    open var isDeleting: Bool = true
    
    override open var text: String? {
        didSet {
            //attribute()
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
        
    public func attribute() {
        
        guard let text = cleanText() else {
            return
        }
        
        if attributedText == nil {
            let attributedString = NSMutableAttributedString(string: text)
            attributedText = attributedString
        }

        guard let attributedString = attributedText as? NSMutableAttributedString else {
            return
        }
        
        for (regex, color) in attributions {
            let matches = match(regex)
            for match in matches {
                let range = match.range(at: 1)
                attributedString.addAttribute(NSAttributedStringKey.backgroundColor, value: color, range: range)
            }
        }
    
    }
    
    fileprivate func cleanText() -> String? {
        guard let txt = text else {
            return nil
        }
        
        var cleaned = txt
        let pattern = isDeleting ? PatchLabel.additionLinePattern : PatchLabel.deletionLinePattern
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
            let range = NSRange(location: 0, length: txt.utf16.count)
            cleaned = regex.stringByReplacingMatches(in: txt, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: range, withTemplate: "")
            text = cleaned
        } catch {
            print("Error Matching: \(error)")
        }

        
        return text
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

extension PatchLabel {
    
    override open func drawText(in rect: CGRect) {
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width,height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil).size
            super.drawText(in: CGRect(x:0,y: 0,width: self.frame.width, height:ceil(labelStringSize.height)))
        } else {
            super.drawText(in: rect)
        }
    }
}
