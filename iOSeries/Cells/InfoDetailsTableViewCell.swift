//
//  InfoDetailsTableViewCell.swift
//  DetailsParallaxView
//
//  Created by Pierre on 26/03/2016.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit

class InfoDetailsTableViewCell: UITableViewCell {
    
    // MARK: - Private Constants
    
    
    // MARK: - Private Variables
    // var delegate: ParallaxDetailsViewDelegate?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var rappelButton: UIButton!
    @IBOutlet weak var seenButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func seenButtonTapped(_ sender: Any) {
        if let button: UIButton = sender as? UIButton {
            if button.tag == 0 {
                print("J'ai vu")
            } else if button.tag == 1 {
                print("Pas vu")
            }
        }
    }
    
    @IBAction func rappelButtonTapped(_ sender: Any) {
        if let button: UIButton = sender as? UIButton {
            if button.tag == 0 {
                print("Ajouter rappel")
            } else if button.tag == 1 {
                print("Supprimer rappel")
            }
        }
    }
    
    
    // MARK: - "Default" Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.rappelButton.layer.borderWidth = 1.0
        self.rappelButton.layer.cornerRadius = 15.0
        
        self.seenButton.layer.cornerRadius = 15.0
        self.seenButton.layer.borderWidth = 1.0
    }
    
    
    // MARK: - Delegates
    
    
    // MARK: - Personnal Delegates
    
    
    // MARK: - Personnal Methods
    internal static func infoDetails() -> InfoDetailsTableViewCell {
        let nibs = Bundle.main.loadNibNamed("InfoDetailsTableViewCell", owner: self, options: nil)
        let cell: InfoDetailsTableViewCell = nibs![0] as! InfoDetailsTableViewCell
        cell.selectionStyle = .none
        
        return cell
    }
}
