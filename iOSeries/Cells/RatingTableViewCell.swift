//
//  RatingTableViewCell.swift
//  DetailsParallaxView
//
//  Created by Pierre on 27/03/2016.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit
import Cosmos

class RatingTableViewCell: UITableViewCell {
    
    // MARK: - Private Constants
    
    
    // MARK: - Private Variables
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var ratingCosmosView: CosmosView!
    
    
    // MARK: - IBActions
    
    
    // MARK: - "Default" Methods
    
    
    // MARK: - Delegates
    
    
    // MARK: - Personnal Delegates
    
    
    // MARK: - Personnal Methods
    internal static func ratingCell() -> RatingTableViewCell {
        let nibs = Bundle.main.loadNibNamed("RatingTableViewCell", owner: self, options: nil)
        let cell: RatingTableViewCell = nibs![0] as! RatingTableViewCell
        cell.selectionStyle = .none
        
        return cell
    }
}
