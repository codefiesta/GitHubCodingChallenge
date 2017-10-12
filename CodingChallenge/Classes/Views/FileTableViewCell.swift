//
//  FileTableViewCell.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import UIKit
import GitHub

class FileTableViewCell: UITableViewCell {
    
    var maxChanges: Int = 200 // The max number of changes allowed when rendering the diff
    var activityIndicatorView: UIActivityIndicatorView!
    var containerView: UIStackView! // The master vertical stackview
    var splitView: UIStackView! // The horizontal split stackview
    var leftView: UIStackView! // The deletions view
    var rightView: UIStackView! // The additions view
    var singleView: UIStackView! // Used when only additions or deletions have ocurred

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func prepare() {
        selectionStyle = .none
        prepareActivityIndicatorView()
        prepareContainerView()
        prepareSingleView()
        prepareLeftView()
        prepareRightView()
        prepareSplitView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        for view in leftView.arrangedSubviews {
            leftView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for view in rightView.arrangedSubviews {
            rightView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for view in singleView.arrangedSubviews {
            singleView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    fileprivate func prepareActivityIndicatorView() {
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        addSubview(activityIndicatorView)
    }
    
    fileprivate func prepareLeftView() {
        leftView = UIStackView()
        leftView.translatesAutoresizingMaskIntoConstraints = false
        leftView.axis = .vertical
        leftView.distribution = .fill
        leftView.isLayoutMarginsRelativeArrangement = true
    }
    
    fileprivate func prepareRightView() {
        rightView = UIStackView()
        rightView.translatesAutoresizingMaskIntoConstraints = false
        rightView.axis = .vertical
        rightView.distribution = .fill
        rightView.isLayoutMarginsRelativeArrangement = true
    }

    fileprivate func prepareSplitView() {
        splitView = UIStackView()
        splitView.translatesAutoresizingMaskIntoConstraints = false
        splitView.axis = .horizontal
        splitView.distribution = .fillEqually
        splitView.isLayoutMarginsRelativeArrangement = true
        containerView.addArrangedSubview(splitView)
        
        splitView.addArrangedSubview(leftView)
        splitView.addArrangedSubview(rightView)
    }

    fileprivate func prepareSingleView() {
        singleView = UIStackView()
        singleView.translatesAutoresizingMaskIntoConstraints = false
        singleView.axis = .vertical
        singleView.distribution = .fill
        singleView.isLayoutMarginsRelativeArrangement = true
        containerView.addArrangedSubview(singleView)
    }
    
    fileprivate func prepareContainerView() {
        containerView = UIStackView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.axis = .vertical
        containerView.distribution = .fill
        containerView.isLayoutMarginsRelativeArrangement = true
        addSubview(containerView)
        containerView.fitToParent()
    }

    
    func prepare(_ file: GitHubPullRequestFile) {
        
        var file = file
        let lines = file.lines
        guard lines.count < maxChanges else {
            prepareLine("Large diffs are not rendered by default", stackView: singleView)
            return
        }
        
        let header = file.header
        var leftLineNo = header.fromFileStart
        var rightLineNo = header.toFileStart
        for (index, line) in lines.enumerated() {
            
            if index == 0 {
                // Put the header into the single view (so it appears more like a header)
                prepareLine(line, stackView: singleView)
            } else {
                
                if file.deletions > 0, !line.starts(with: "+") {
                    let lineNo = leftLineNo
                    let stackView: UIStackView! = file.additions != 0 ? leftView : singleView
                    prepareLine(line, lineNo, stackView: stackView)
                    leftLineNo += 1
                }
                if file.additions > 0, !line.starts(with: "-") {
                    let lineNo = rightLineNo
                    let stackView: UIStackView! = file.deletions != 0 ? rightView: singleView
                    prepareLine(line, lineNo, stackView: stackView)
                    rightLineNo += 1
                }
            }
        }
        setNeedsDisplay()
    }
}

extension FileTableViewCell {
    
    fileprivate func prepareLine(_ line: String?, _ lineNo: Int? = nil, stackView: UIStackView?) {

        guard let line = line, let stackView = stackView else {
            return
        }
        
        let label = PatchLabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 8)
        label.text = line
        label.translatesAutoresizingMaskIntoConstraints = false
        
        var bgColor: UIColor = .white
        
        if line.starts(with: "@@ ") {
            bgColor = UIColor.blue
        }
        if line.starts(with: "+") {
            bgColor = UIColor.green
        }
        if line.starts(with: "-") {
            bgColor = UIColor.red
        }
        label.backgroundColor = bgColor.withAlphaComponent(0.2)

        if let lineNo = lineNo {
            
            // Build a stackview with a gutter line number
            let lineGutterStack = UIStackView()
            lineGutterStack.translatesAutoresizingMaskIntoConstraints = false
            lineGutterStack.axis = .horizontal
            lineGutterStack.distribution = .fill
            lineGutterStack.isLayoutMarginsRelativeArrangement = true
            
            let lineLabel = PatchLabel()
            lineLabel.text = "\(lineNo)"
            lineLabel.font = UIFont.systemFont(ofSize: 8)
            lineLabel.textColor = UIColor.gray
            lineLabel.backgroundColor = bgColor.withAlphaComponent(0.4)
            
            // Set the content compression and content hugging to 'squeeze' the gutter to the left
            lineLabel.setContentCompressionResistancePriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
            label.setContentCompressionResistancePriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
            lineLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
            label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
            
            lineGutterStack.addArrangedSubview(lineLabel)
            lineGutterStack.addArrangedSubview(label)
            
            stackView.addArrangedSubview(lineGutterStack)
            
        } else {
            stackView.addArrangedSubview(label)
        }
    }
}

class PatchLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func drawText(in rect: CGRect) {
        
        // Pushes the label up to the top
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width,height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil).size
            
            let r = CGRect(x:0, y: 0, width: self.frame.width, height:ceil(labelStringSize.height))
            
            super.drawText(in: r)
        } else {
            super.drawText(in: rect)
        }
    }

}

