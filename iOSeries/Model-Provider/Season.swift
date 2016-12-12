//
//  Season.swift
//  iOSeries
//
//  Created by Pierre on 11/12/2016.
//  Copyright © 2016 Pierre Boudon. All rights reserved.
//

import Foundation

class Season {
    var season_number: Int
    var episodes = [Episode]()
    
    init(number: Int) {
        self.season_number = number
    }
}
