//
//  ImageCache.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/13/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import UIKit

class ImageCache: NSCache<NSString, UIImage> {
    
    static let shared: ImageCache = ImageCache()
    
    override private init() {
        super.init()
    }
    
}
