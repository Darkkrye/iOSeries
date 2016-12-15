//
//  InfoDetailsTableViewCell.swift
//  DetailsParallaxView
//
//  Created by Pierre on 26/03/2016.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit
import CoreData

protocol InfoDetailsTableViewCellDelegate {
    func setShowAsSeen()
    func setShowAsUnseen()
    
    func schedule()
    func unschedule()
    
    func wantsToWatch()
    func wantsToUnwatch()
}

class InfoDetailsTableViewCell: UITableViewCell {
    
    // MARK: - Private Constants
    
    
    // MARK: - Private Variables
    var delegate: InfoDetailsTableViewCellDelegate?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var rappelButton: UIButton!
    @IBOutlet weak var seenButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func seenButtonTapped(_ sender: Any) {
        if let button: UIButton = sender as? UIButton {
            if let d = self.delegate {
                if button.tag == 0 {
                    // print("J'ai vu")
                    d.setShowAsSeen()
                } else if button.tag == 1 {
                    // print("Pas vu")
                    d.setShowAsUnseen()
                }
            }
        }
    }
    
    @IBAction func rappelButtonTapped(_ sender: Any) {
        if let button: UIButton = sender as? UIButton {
            if let d = self.delegate {
                if button.tag == 0 {
                    // print("Ajouter rappel")
                    d.schedule()
                } else if button.tag == 1 {
                    // print("Supprimer rappel")
                    d.unschedule()
                } else if button.tag == 2 {
                    // print("Je veux voir !")
                    d.wantsToWatch()
                } else if button.tag == 3 {
                    // print("Je ne veux plus voir")
                    d.wantsToUnwatch()
                }
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
