//
//  SampleSwipeableCard.swift
//  Swipeable-View-Stack
//
//  Created by Phill Farrugia on 10/21/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit
import CoreMotion

class SampleSwipeableCard: SwipeableCardViewCard {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet private weak var imageBackgroundColorView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var backgroundContainerView: UIView!

    /// Core Motion Manager
    private let motionManager = CMMotionManager()

    /// Shadow View
    private weak var shadowView: UIView?

    /// Inner Margin
    private static let kInnerMargin: CGFloat = 20.0
    
    let yelpRepo = YelpRepo.shared

    var viewModel: SampleSwipeableCellViewModel? {
        didSet {
            configure(forViewModel: viewModel)
        }
    }

    private func configure(forViewModel viewModel: SampleSwipeableCellViewModel?) {
        if let viewModel = viewModel {
            self.nameLabel.text = viewModel.name
            self.ratingLabel.text = viewModel.rating
            self.ratingImage.image = YelpDisplays.getRatingImage((viewModel.rating as! NSString).doubleValue)
            
            self.imageView.image = viewModel.image
            self.imageView.contentMode = .scaleAspectFill
            backgroundContainerView.layer.cornerRadius = 14.0
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        configureShadow()
    }

    // MARK: - Shadow

    private func configureShadow() {
        // Shadow View
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: SampleSwipeableCard.kInnerMargin,
                                              y: SampleSwipeableCard.kInnerMargin,
                                              width: bounds.width - (2 * SampleSwipeableCard.kInnerMargin),
                                              height: bounds.height - (2 * SampleSwipeableCard.kInnerMargin)))
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView
        self.applyShadow(width: CGFloat(0.0), height: CGFloat(0.0))
    }

    private func applyShadow(width: CGFloat, height: CGFloat) {
        if let shadowView = shadowView {
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 14.0)
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowRadius = 8.0
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: width, height: height)
            shadowView.layer.shadowOpacity = 0.15
            shadowView.layer.shadowPath = shadowPath.cgPath
        }
    }

}
