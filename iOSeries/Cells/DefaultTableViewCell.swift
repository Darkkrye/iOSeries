//
//  DefaultTableViewCell.swift
//  iOSeries
//
//  Created by Pierre on 11/12/2016.
//  Copyright © 2016 Pierre Boudon. All rights reserved.
//

import UIKit
import Cosmos

class DefaultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var showNameLabel: UILabel!
    @IBOutlet weak var showInfoLabel: UILabel!
    @IBOutlet weak var showNoteCosmosView: CosmosView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.showNameLabel.frame
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.showNameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showInfoLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showNoteCosmosView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
}
