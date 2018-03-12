//
//  extensions.swift
//  Swipeable-View-Stack
//
//  Created by Bonnie Nguyen on 3/3/18.
//  Copyright © 2018 Phill Farrugia. All rights reserved.
//

import Foundation
import UIKit

protocol Visuals {
    func roundCorners()
}

extension Visuals where Self: UIView {
    func roundCorners() -> Void {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}

extension UILabel: Visuals {}
extension UIButton: Visuals {}
extension UIImageView: Visuals {}
extension UIView: Visuals {}

