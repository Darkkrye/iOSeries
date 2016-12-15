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
    var show_seasonNumber: Int
    var show_episodeNumber: Int
    var show_genders: [String]
    var show_creationYear: String
    var show_network: String
    var show_Status: String
    var show_note: Double
    var show_noters: Int
    var show_imageShow: UIImage
    var show_imageShowURL: String
    var show_imageBanner: UIImage
    var show_imageBannerURL: String
    var show_imagePoster: UIImage
    var show_imagePosterURL: String
    var show_url: String
    var show_seasons: [Season]
    
    var show_alreadyWatched: Bool
    var show_isScheduled: Bool
    var show_scheduledDate: Date?
    
    var show_wantsToWatch: Bool
    
    init(id: Int, title: String, seasonNumber: Int, episodeNumber: Int, creationYear: String, note: Double, imageBanner: String, alreadyWatched: Bool, isScheduled: Bool, scheduledDate: Date?, wantsToWatch: Bool) {
        self.show_id = id
        self.show_title = title
        self.show_seasonNumber = seasonNumber
        self.show_episodeNumber = episodeNumber
        self.show_creationYear = creationYear
        self.show_note = note
        self.show_imageBannerURL = imageBanner
        self.show_imageBanner = Show.hydrateImageFromString(url: imageBanner)
        self.show_alreadyWatched = alreadyWatched
        self.show_isScheduled = isScheduled
        self.show_scheduledDate = scheduledDate
        self.show_wantsToWatch = wantsToWatch
        
        self.show_description = ""
        self.show_genders = [String]()
        self.show_network = ""
        self.show_Status = ""
        self.show_noters = 0
        self.show_imageShow = UIImage()
        self.show_imageShowURL = ""
        self.show_imagePoster = UIImage()
        self.show_imagePosterURL = ""
        self.show_url = ""
        self.show_seasons = [Season]()
    }
    
    init(id: Int, title: String, desc: String, seasonNumber: Int, episodeNumber: Int, genders: [String], creationYear: String, network: String, status: String, note: Double, noters: Int, imageShow: String, imageBanner: String, imagePoster: String, url: String, seasons: [Season]) {
        
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
        self.show_imageShowURL = imageShow
        self.show_imageBanner = Show.hydrateImageFromString(url: imageBanner)
        self.show_imageBannerURL = imageBanner
        self.show_imagePoster = Show.hydrateImageFromString(url: imagePoster)
        self.show_imagePosterURL = imagePoster
        
        self.show_alreadyWatched = false
        self.show_isScheduled = false
        self.show_wantsToWatch = false
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
