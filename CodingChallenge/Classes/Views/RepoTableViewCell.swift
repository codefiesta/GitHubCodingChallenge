//
//  RepoTableViewCell.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/12/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import UIKit
import GitHub

class RepoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var descLabel: UILabel?
    @IBOutlet weak var languageLabel: UILabel?
    @IBOutlet weak var languageCodeView: UIView?
    @IBOutlet weak var starGazersLabel: UILabel?
    @IBOutlet weak var forksLabel: UILabel?

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let languageCodeView = languageCodeView else {
            return
        }
        languageCodeView.layer.cornerRadius = languageCodeView.frame.size.width / 2
    }
    
}
