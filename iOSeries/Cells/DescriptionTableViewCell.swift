//
//  DescriptionTableViewCell.swift
//  DetailsParallaxView
//
//  Created by Pierre on 27/03/2016.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    
    // MARK: - Private Constants
    
    
    // MARK: - Private Variables
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    // MARK: - IBActions
    
    
    // MARK: - "Default" Methods
    
    
    // MARK: - Delegates
    
    
    // MARK: - Personnal Delegates
    
    
    // MARK: - Personnal Methods
    internal static func descriptionCell() -> DescriptionTableViewCell {
        let nibs = Bundle.main.loadNibNamed("DescriptionTableViewCell", owner: self, options: nil)
        let cell: DescriptionTableViewCell = nibs![0] as! DescriptionTableViewCell
        cell.selectionStyle = .none
        
        return cell
    }
}
