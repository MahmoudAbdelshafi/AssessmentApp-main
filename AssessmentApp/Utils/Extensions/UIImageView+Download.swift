//
//  UIImageView+Download.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 02/04/2023.
//

import UIKit
import Kingfisher

protocol ImageLoader {
    func loadWebImageWithUrl(imageUrl: String)
}

extension UIImageView: ImageLoader {
    func loadWebImageWithUrl(imageUrl: String) {
        self.startAnimating()
        self.kf.indicatorType = .activity
        let url = URL(string: imageUrl)
        self.kf.setImage(with: url,
                         options: [.transition(.fade(0.1))],
                         progressBlock: nil,
                         completionHandler: nil)
    }
}
