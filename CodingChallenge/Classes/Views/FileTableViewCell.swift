//
//  FileTableViewCell.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import UIKit
import GitHub
import PatchLabel

class FileTableViewCell: UITableViewCell {
    
    var maxChanges: Int = 500 // The max number of changes allowed when rendering the diff
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
        
        guard file.changes < maxChanges else {
            prepareLine("Large diffs are not rendered by default", stackView: singleView)
            return
        }
        
        let header = file.header
        var leftLineNo = header.fromFileStart
        var rightLineNo = header.toFileStart
        for (index, line) in file.lines.enumerated() {
            
            if index == 0 {
                // Put the header into the single view (so it appears more like a header)
                prepareLine(line, stackView: singleView)
            } else {
                
                if file.deletions > 0, !line.starts(with: "+") {
                    let stackView: UIStackView! = file.additions != 0 ? leftView : singleView
                    prepareLine(line, leftLineNo, stackView: stackView)
                    leftLineNo += 1

                }
                if file.additions > 0, !line.starts(with: "-") {
                    let stackView: UIStackView! = file.deletions != 0 ? rightView: singleView
                    prepareLine(line, rightLineNo, stackView: stackView)
                    rightLineNo += 1

                }
            }
        }
        
    }
}

extension FileTableViewCell {
    
    fileprivate func prepareLine(_ line: String?, _ lineNo: Int? = nil, stackView: UIStackView) {

        guard let line = line else {
            return
        }
        
        let label = PatchLabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 8)
        label.text = line
        
        var bgColor: UIColor = .white
        
        if line.starts(with: "@@ ") {
            bgColor = UIColor.blue.withAlphaComponent(0.05)
        }
        if line.starts(with: "+") {
            bgColor = UIColor.green.withAlphaComponent(0.2)
        }
        if line.starts(with: "-") {
            bgColor = UIColor.red.withAlphaComponent(0.2)
        }
        label.backgroundColor = bgColor

        if let lineNo = lineNo {
            
            // Build a stackview with a gutter line number
            let lineGutterStack = UIStackView()
            lineGutterStack.translatesAutoresizingMaskIntoConstraints = false
            lineGutterStack.axis = .horizontal
            lineGutterStack.distribution = .fill
            lineGutterStack.isLayoutMarginsRelativeArrangement = true
            
            // Use a button here instead of a label since a button allows us to align vertically
            let lineButton = UIButton(type: .custom)
            lineButton.setTitleColor(UIColor.gray, for: .normal)
            lineButton.setTitle("\(lineNo)", for: .normal)
            lineButton.titleLabel?.font = UIFont.systemFont(ofSize: 8)
            lineButton.titleLabel?.numberOfLines = 1
            lineButton.contentVerticalAlignment = .top
            lineButton.contentHorizontalAlignment = .left
            lineButton.isEnabled = false
            lineButton.titleLabel?.textColor = UIColor.gray
            lineButton.titleLabel?.text = "\(lineNo)"
            lineButton.backgroundColor = bgColor
            
            // Set the content compression and content hugging to 'squeeze' the gutter to the left
            lineButton.setContentCompressionResistancePriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
            label.setContentCompressionResistancePriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
            lineButton.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
            label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
            
            lineGutterStack.addArrangedSubview(lineButton)
            lineGutterStack.addArrangedSubview(label)
            
            stackView.addArrangedSubview(lineGutterStack)
            
        } else {
            stackView.addArrangedSubview(label)
        }
    }
}

