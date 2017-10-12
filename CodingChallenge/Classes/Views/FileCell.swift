//
//  FileCell.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import UIKit
import GitHub
import PatchLabel

class FileCell: UITableViewCell {
    
    var maxChanges: Int = 500 // The max number of changes allowed when rendering the diff
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
        prepareLeftView()
        prepareRightView()
        prepareSplitView()
        prepareSingleView()
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
        addSubview(splitView)
        splitView.fitToParent()
        
        splitView.addArrangedSubview(leftView)
        splitView.addArrangedSubview(rightView)
    }

    fileprivate func prepareSingleView() {
        singleView = UIStackView()
        singleView.translatesAutoresizingMaskIntoConstraints = false
        singleView.axis = .vertical
        singleView.distribution = .fillEqually
        singleView.isLayoutMarginsRelativeArrangement = true
        addSubview(singleView)
        singleView.fitToParent()
    }

    
    func prepare(_ file: GitHubPullRequestFile) {
        
        guard file.changes < maxChanges else {
            preparePatch("Large diffs are not rendered by default", stackView: leftView)
            return
        }
        if file.deletions > 0 {
            let stackView: UIStackView! = file.additions != 0 ? leftView : singleView
            preparePatch(file.patch, stackView: stackView)
        }
        if file.additions > 0 {
            let stackView: UIStackView! = file.deletions != 0 ? rightView: singleView
            preparePatch(file.patch, stackView: stackView)
        }
    }
}

extension FileCell {
    
    fileprivate func preparePatch(_ patch: String?, stackView: UIStackView) {

        guard let patch = patch else {
            return
        }
        
        let label = PatchLabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 8)
        label.text = patch

        stackView.addArrangedSubview(label)
    }
}

