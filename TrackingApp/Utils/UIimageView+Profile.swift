//
//  UIimageView+Profile.swift
//  TrackingApp
//
//  Created by Tardes on 8/6/26.
//

import UIKit

extension UIImageView {
    func setProfileStyle() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.systemBlue.cgColor
    }
}
