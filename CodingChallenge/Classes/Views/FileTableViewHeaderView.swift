//
//  FileTableViewHeaderView.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/15/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import UIKit
import GitHub

class FileTableViewHeaderView: UITableViewHeaderFooterView {

    fileprivate let greenColor = UIColor(red: 54/255, green: 188/255, blue: 84/255, alpha: 1.0)
    var stackView: UIStackView!
    var titleLabel: UILabel!
    var additionsLabel: UILabel!
    var deletionsLabel: UILabel!
    var statsContainerStackView: UIStackView!
    var statsStackView: UIStackView!
    
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
        prepareStatsContainerStackView()
        prepareStatsStackView()
        prepareDeletionsLabel()
        prepareAdditionsLabel()
    }
    
    fileprivate func prepareStackView() {
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        addSubview(stackView)
        stackView.edges(4, 30, 4, 4)
    }

    fileprivate func prepareTitleLabel() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        stackView.addArrangedSubview(titleLabel)
    }
    
    fileprivate func prepareStatsContainerStackView() {
        statsContainerStackView = UIStackView()
        statsContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        statsContainerStackView.axis = .horizontal
        statsContainerStackView.distribution = .fill
        statsContainerStackView.spacing = 6
        statsContainerStackView.isLayoutMarginsRelativeArrangement = true
        stackView.addArrangedSubview(statsContainerStackView)
    }
    
    fileprivate func prepareStatsStackView() {
        statsStackView = UIStackView()
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = 4
        statsStackView.isLayoutMarginsRelativeArrangement = true
        
        for _ in 0...4 {
            let statBox = UIView()
            statBox.translatesAutoresizingMaskIntoConstraints = false
            statBox.backgroundColor = greenColor
            statBox.width(12)
            statsStackView.addArrangedSubview(statBox)
        }
        
        statsContainerStackView.addArrangedSubview(statsStackView)
    }

    fileprivate func prepareAdditionsLabel() {
        
        let label = UILabel()
        label.text = "Additions:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor.gray
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        statsContainerStackView.addArrangedSubview(label)

        additionsLabel = UILabel()
        additionsLabel.translatesAutoresizingMaskIntoConstraints = false
        additionsLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        additionsLabel.textColor = greenColor
        
        additionsLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        statsContainerStackView.addArrangedSubview(additionsLabel)
    }
    
    fileprivate func prepareDeletionsLabel() {
        
        let label = UILabel()
        label.text = "Deletions:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor.gray
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        statsContainerStackView.addArrangedSubview(label)

        deletionsLabel = UILabel()
        deletionsLabel.translatesAutoresizingMaskIntoConstraints = false
        deletionsLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        deletionsLabel.textColor = UIColor.red
        deletionsLabel.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        statsContainerStackView.addArrangedSubview(deletionsLabel)
    }

    func prepare(_ file: GitHubPullRequestFile) {
        titleLabel.text = "\(file.name)"
        additionsLabel.text = "\(file.additions)"
        additionsLabel.textColor = file.additions > 0 ? greenColor : .black
        deletionsLabel.text = "\(file.deletions)"
        deletionsLabel.textColor = file.deletions > 0 ? .red : .black
        
        
        // TODO: This can really be improved ...
        if file.additions > 0, file.deletions == 0 {
            for view in statsStackView.arrangedSubviews {
                view.backgroundColor = greenColor
            }
        } else if file.deletions > 0, file.additions == 0 {
            for view in statsStackView.arrangedSubviews {
                view.backgroundColor = .red
            }
        } else if file.deletions == file.additions {
            var colors: [UIColor] = [greenColor, greenColor, .red, .red, .lightGray]
            for (index, view) in statsStackView.arrangedSubviews.enumerated() {
                view.backgroundColor = colors[index]
            }
        } else {
            // Calculate the ratio
        }
    }

}
