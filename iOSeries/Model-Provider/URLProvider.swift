//
//  URLProvider.swift
//  iOSeries
//
//  Created by Pierre on 09/12/2016.
//  Copyright © 2016 Pierre Boudon. All rights reserved.
//

import Foundation

class URLProvider {
    
    static let searchURL = "http://api.betaseries.com/shows/search?title="
    static let getShowURL = "http://api.betaseries.com/shows/display?id="
    
}

class APIInfoProvider {
    static let headers = ["Content-Type": "application/json", "X-BetaSeries-Key": "dd1d35b7f6c0"]
}
