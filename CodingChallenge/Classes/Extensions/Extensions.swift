//
//  Extensions.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import UIKit

extension UIView {

    // Centers a view to it's parent view via layout constraints
    func center() {
        guard let parent = superview else {
            return
        }
        
        NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: parent, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: parent, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
    }
    
    // Pins a views edges to it's parent view via layout constraints
    func edges(_ top: CGFloat = 0, _ left: CGFloat = 0, _ bottom: CGFloat = 0, _ right: CGFloat = 0) {
        guard let parent = superview else {
            return
        }
        
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1.0, constant: top).isActive = true
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1.0, constant: left).isActive = true
        NSLayoutConstraint(item: parent, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: bottom).isActive = true
        NSLayoutConstraint(item: parent, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: right).isActive = true
    }
}

extension String {
    
    func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
}

extension Int {
    
    init?(_ substring: Substring?) {
        guard let substring = substring else {
            self.init(0)
            return
        }
        let string = String(substring)
        self.init(string)
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

        let cacheKey = NSString(string: urlString)
        let cache = ImageCache.shared
        
        if let cached = cache.object(forKey: cacheKey) {
            DispatchQueue.main.async {
                print("🦊 Cache Hit")
                completion?(cached, nil)
            }
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

            guard let image = UIImage(data: data) else {
                completion?(nil, error)
                return
            }

            print("🐔 Caching")
            cache.setObject(image, forKey: cacheKey)

            DispatchQueue.main.async {

                self.image = image
                completion?(image, nil)
                return
            }
        })
        
        dataTask.resume()
    }
    
}

extension UIViewController {
    
    func prepareNavigationItems() {
        // Hides the back button text
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
    }
}

extension UISearchBar {
    
    func enableCancelKeyAccessory() {
        
        // Add the cancel toolbar
        let cancelToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        cancelToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleKeyboardDismiss))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        cancelToolbar.items = items
        cancelToolbar.sizeToFit()
        
        self.inputAccessoryView = cancelToolbar
    }
    
    @objc fileprivate func handleKeyboardDismiss() {
        self.resignFirstResponder()
    }
}

