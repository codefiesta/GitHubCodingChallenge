//
//  PatchLabel.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/13/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import UIKit

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
        
        // Pushes the label up to the top when inside stackviews
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

