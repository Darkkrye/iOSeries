//
//  Show.swift
//  iOSeries
//
//  Created by Pierre on 11/12/2016.
//  Copyright © 2016 Pierre Boudon. All rights reserved.
//

import Foundation
import UIKit

class Show {
    var show_id: Int
    var show_title: String
    var show_description: String
    var show_seasonNumber: String
    var show_episodeNumber: String
    var show_genders: [String]
    var show_creationYear: String
    var show_network: String
    var show_Status: String
    var show_note: Double
    var show_noters: Int
    var show_imageShow: UIImage
    var show_imageBanner: UIImage
    var show_imagePoster: UIImage
    var show_url: String
    var show_seasons: [Season]
    
    
    init(id: Int, title: String, desc: String, seasonNumber: String, episodeNumber: String, genders: [String], creationYear: String, network: String, status: String, note: Double, noters: Int, imageShow: String, imageBanner: String, imagePoster: String, url: String, seasons: [Season]) {
        
        self.show_id = id
        self.show_title = title
        self.show_description = desc
        self.show_seasonNumber = seasonNumber
        self.show_episodeNumber = episodeNumber
        self.show_genders = genders
        self.show_creationYear = creationYear
        self.show_network = network
        self.show_Status = Show.getFrenchStatus(status: status)
        self.show_note = note
        self.show_noters = noters
        self.show_url = url
        self.show_seasons = seasons
        
        self.show_imageShow = Show.hydrateImageFromString(url: imageShow)
        self.show_imageBanner = Show.hydrateImageFromString(url: imageBanner)
        self.show_imagePoster = Show.hydrateImageFromString(url: imagePoster)
    }
    
    private static func getFrenchStatus(status: String) -> String {
        switch status {
        case "Ended":
            return "Terminé"
            
        case "Continuing":
            return "En cours"
            
        case "Cancelled":
            return "Annulé"
            
        default:
            return "Inconnu"
        }
    }
    
    private static func hydrateImageFromString(url: String) -> UIImage {
        if let url = URL(string: url), let data = NSData(contentsOf: url) {
            return UIImage(data: data as Data)!
        } else {
            return UIImage(named: "sttwhite")!
        }
    }
}
