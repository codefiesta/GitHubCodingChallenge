//
//  Extensions.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import UIKit

extension UIView {

    // Pins a views edges to it's parent view via layout constraints
    func fitToParent() {
        
        guard let parent = superview else {
            return
        }
        
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: parent, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: parent, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        
    }
    
    // Centers a view to it's parent view via layout constraints
    func centerInParent() {
        guard let parent = superview else {
            return
        }
        
        NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: parent, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: parent, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
    }
}

extension Date {
    
    // Formats the date with the specified format
    func toString(withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self)
        return dateString
    }

    func toRelativeDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.current
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}

extension UIImageView {
    
    func image(fromUrl urlString: String?, _ completion: ((UIImage?, Error?) -> Void)? = nil) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 8.0)
        request.httpMethod = "GET"

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            guard error == nil else {
                completion?(nil, error)
                return
            }
            
            guard let data = data else {
                completion?(nil, error)
                return
            }

            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.image = image
                completion?(image, nil)
                return
            }
        })
        
        dataTask.resume()
    }
    
}
