//
//  UIImageViewExtension.swift
//  Events
//
//  Created by Darci Neto on 14/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func download(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit, defaultImage: String = "barrier") {
        let cache = NSCache<NSString, ImageCache>()
        if let imageFromCache = cache.object(forKey: url.absoluteString as NSString)  {
            setImage(imageFromCache.image, animationDuration: 0, contentMode: mode)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    self.setImage(UIImage(named:defaultImage))
                    return;
            }
            self.setImage(image, animationDuration: 0.5, contentMode: mode)
            let cacheImage = ImageCache()
            cacheImage.image = image
            cache.setObject(cacheImage, forKey: url.absoluteString as NSString)
        }.resume()
           
    }
    func download(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        download(from: url, contentMode: mode)
    }
    
    func setImage( _ image:UIImage?, animationDuration: TimeInterval = 0 , contentMode mode: UIView.ContentMode = .scaleAspectFit){
        DispatchQueue.main.async() {
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(animationDuration)
            
            let transition = CATransition()
            transition.type = CATransitionType.fade
            self.layer.add(transition, forKey: kCATransition)
            self.image = image
            self.contentMode = mode
            
            CATransaction.commit()
        }
    }
}
