//
//  Episode.swift
//  iOSeries
//
//  Created by Pierre on 11/12/2016.
//  Copyright © 2016 Pierre Boudon. All rights reserved.
//

import Foundation

class Episode {
    var episode_id: Int
    var episode_title: String
    var episode_season: Int
    var episode_episode: Int
    var episode_code: String
    var episode_description: String
    var episode_date: String
    var episode_rating: Double
    
    init(id: Int, title: String, season: Int, episode: Int, code: String, description: String, date: String, rating: Double) {
        self.episode_id = id
        self.episode_title = title
        self.episode_season = season
        self.episode_episode = episode
        self.episode_code = code
        self.episode_description = description
        self.episode_date = date
        self.episode_rating = rating
    }
}
