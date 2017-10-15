//
//  PatchView.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/13/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import UIKit
import CoreText

class PatchView: UIView {
    
    fileprivate let headerPattern = "^@@ \\-([0-9]+),([0-9]+) \\+([0-9]+),([0-9]+) @@"

    let decorators: [String: UIColor] = [
        "+": UIColor.green.withAlphaComponent(0.25),
        "-": UIColor.red.withAlphaComponent(0.25),
        "@@": UIColor(red: 44/255, green: 152/255, blue: 239/255, alpha: 0.25),
    ]
    
    var isAdditionPatch: Bool = false
    var additions: Int = 0
    var deletions: Int = 0

    var gutterWidth: CGFloat = 24
    var attributes: [NSAttributedStringKey: Any] = [:]
    var text: String? {
        didSet {
            prepareText()
        }
    }
    lazy var paragraphStyle: NSParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineSpacing = 7
        return style
    }()
    var lineNumber: Int = 0
    
    fileprivate var textView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func prepare() {
        backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .redraw
        
        attributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11),
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.foregroundColor: UIColor.darkGray
        ]

        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        textView.layoutManager.delegate = self

        addSubview(textView)
        textView.edges(0, gutterWidth, 10, 0)
    }
    
    
    fileprivate func prepareText() {
        guard let text = text, !text.isEmpty else {
            return
        }
        
        if deletions > 0, additions == 0 { // Nothing to remove
            textView.attributedText = NSMutableAttributedString(string: text, attributes: attributes)
            return
        }

        if additions > 0, deletions == 0 {  // Nothing to remove
            textView.attributedText = NSMutableAttributedString(string: text, attributes: attributes)
            return
        }

        // TODO: Use a regex to filter these lines 🤔
        var scrubbed = text
        let lines = text.components(separatedBy: .newlines).filter({ (line) -> Bool in
            let startChar = isAdditionPatch ? "-" : "+"
            return !line.starts(with: startChar)
        })
        scrubbed = lines.joined(separator: "\n")

        textView.attributedText = NSMutableAttributedString(string: scrubbed, attributes: attributes)
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else {
            super.draw(rect)
            return
        }
        UIGraphicsPushContext(context)

        let inset: CGFloat = 8 // Default TextView Inset
        let layoutManager = textView.layoutManager
        let textStorage = textView.textStorage

        let textRange = layoutManager.glyphRange(forBoundingRect: rect, in: textView.textContainer)
        let glyphsToShow = layoutManager.glyphRange(forCharacterRange: textRange, actualCharacterRange: nil)
        let gutterAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11)]

        var lineNo = 0
        
        layoutManager.enumerateLineFragments(forGlyphRange: glyphsToShow) { (rect, usedRect, textContainer, glyphRange, stop) in
            
            let characterRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
            
            let textString = NSString(string: textStorage.string)
            let paragraphRange = textString.paragraphRange(for: characterRange)

            if characterRange.location == paragraphRange.location { // We've hit a new paragraph
                
                let paragraph = textString.substring(with: paragraphRange)
                
                self.decorate(paragraph, paragraphRange)
                
                if !paragraph.starts(with: "@@") { // Don't add a line number to header lines
                    let gutterString = NSString(string: "\(lineNo)")
                    let point = CGPoint(x: 4, y: rect.origin.y + inset)
                    gutterString.draw(at: point, withAttributes: gutterAttributes)
                    lineNo += 1
                } else {
                    // Reset our starting line numbers by parsing the header
                    lineNo = self.parseHeader(paragraph)
                }
            }
        }
        textView.draw(rect)
        UIGraphicsPopContext()
    }

    // Decorates paragraphs based on the starting characters (@@, +, -)
    fileprivate func decorate(_ paragraph: String, _ range: NSRange) {
        
        for (key, value) in decorators {
            if paragraph.starts(with: key) {
                textView.textStorage.addAttribute(NSAttributedStringKey.backgroundColor, value: value, range: range)
            }
        }
    }

    // Parses a header paragraph and returns the starting line number to use
    fileprivate func parseHeader(_ paragraph: String) -> Int {
        do {
            let regex = try NSRegularExpression(pattern: headerPattern, options: .caseInsensitive)
            let matches = regex.matches(in: paragraph, options: .reportProgress, range: NSMakeRange(0, paragraph.characters.count))
            if !matches.isEmpty {
                
                let match = matches[0]
                let index = isAdditionPatch ? 3 : 1
                return Int(paragraph.substring(with: match.range(at: index))) ?? 0
            }
        } catch {
            print("Error: \(error)")
        }
        return 0
    }

}

extension PatchView: NSLayoutManagerDelegate {
    
}

