//
//  FileCell.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import UIKit
import GitHub

class FileCell: UITableViewCell {
    
    var splitView: UIStackView!
    var leftView: UIStackView!
    var rightView: UIStackView!

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
    
    func prepare(_ file: GitHubPullRequestFile) {
        prepareLine(file.patch, stackView: leftView)
        prepareLine(file.patch, stackView: rightView)
    }
}

extension FileCell {
    
    fileprivate func prepareLine(_ line: String?, stackView: UIStackView) {

        let label = UILabel()
        label.numberOfLines = 0
        label.text = line
        label.font = UIFont.systemFont(ofSize: 8)
        
        stackView.addArrangedSubview(label)
    }
}

