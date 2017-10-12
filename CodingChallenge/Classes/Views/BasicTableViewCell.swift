//
//  BasicCell.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/12/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import UIKit

class BasicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var primaryImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descLabel: UILabel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        primaryImageView?.image = nil
    }
}
