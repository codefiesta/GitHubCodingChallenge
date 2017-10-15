//
//  FileTableViewHeaderView.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/15/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import UIKit

class FileTableViewHeaderView: UITableViewHeaderFooterView {
    
    var stackView: UIStackView!
    var titleLabel: UILabel!
    var descLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func prepare() {
        backgroundView?.backgroundColor = UIColor.groupTableViewBackground
        prepareStackView()
        prepareTitleLabel()
        prepareDescLabel()
    }
    
    fileprivate func prepareStackView() {
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        addSubview(stackView)
        stackView.edges(4, 30, 4, 4)
    }

    fileprivate func prepareTitleLabel() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        stackView.addArrangedSubview(titleLabel)
    }
    
    fileprivate func prepareDescLabel() {
        descLabel = UILabel()
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        stackView.addArrangedSubview(descLabel)
    }
}
