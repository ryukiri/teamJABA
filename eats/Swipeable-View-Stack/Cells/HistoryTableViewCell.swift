//
//  HistoryTableViewCell.swift
//  Swipeable-View-Stack
//
//  Created by Student User on 3/11/18.
//  Copyright © 2018 Phill Farrugia. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var historyImage: UIImageView!
    @IBOutlet weak var tintView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.historyImage.contentMode = .scaleAspectFill
        self.tintView.alpha = 0.3
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
