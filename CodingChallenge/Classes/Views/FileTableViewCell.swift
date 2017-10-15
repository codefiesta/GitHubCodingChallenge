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
    
    var maxChanges: Int = 300 // The max number of changes allowed when rendering the diff
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
        prepareVerticalStacks()
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
    
    fileprivate func prepareVerticalStacks() {
        containerView = UIStackView()
        leftView = UIStackView()
        rightView = UIStackView()
        singleView = UIStackView()
        [containerView, leftView, rightView, singleView].forEach { (stackView) in
            stackView?.translatesAutoresizingMaskIntoConstraints = false
            stackView?.axis = .vertical
            stackView?.distribution = .fill
            stackView?.isLayoutMarginsRelativeArrangement = true
            stackView?.isUserInteractionEnabled = false
        }
        contentView.addSubview(containerView)
        containerView.edges()
        containerView.addArrangedSubview(singleView)
    }
    
    fileprivate func prepareSplitView() {
        splitView = UIStackView()
        splitView.translatesAutoresizingMaskIntoConstraints = false
        splitView.axis = .horizontal
        splitView.distribution = .fillEqually
        splitView.isLayoutMarginsRelativeArrangement = true
        splitView.isUserInteractionEnabled = false
        containerView.addArrangedSubview(splitView)
        
        splitView.addArrangedSubview(leftView)
        splitView.addArrangedSubview(rightView)
    }

    func prepare(_ file: GitHubPullRequestFile) {
        
        if file.deletions > 0 {
            
            let patchView = PatchView()
            patchView.text = file.patch
            patchView.additions = file.additions
            patchView.deletions = file.deletions
            
            let stackView = file.additions > 0 ? leftView : singleView
            stackView?.addSubview(patchView)
            patchView.edges()
        }
        
        if file.additions > 0 {
            
            let patchView = PatchView()
            patchView.isAdditionPatch = true
            patchView.additions = file.additions
            patchView.deletions = file.deletions
            patchView.text = file.patch
            
            let stackView = file.deletions > 0 ? rightView: singleView

            stackView?.addSubview(patchView)
            patchView.edges()
        }
        
        setNeedsLayout()
        
        print("🤓 \(file.name) prepared")
    }
}
