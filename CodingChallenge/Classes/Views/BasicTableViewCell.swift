//
//  BasicCell.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/12/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import UIKit

class BasicTableViewCell: UITableViewCell {
    
    var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var primaryImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descLabel: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareActivityIndicatorView()
    }
    
    fileprivate func prepareActivityIndicatorView() {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        primaryImageView?.addSubview(activityIndicatorView)
        activityIndicatorView?.center()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        primaryImageView?.image = nil
    }
}
