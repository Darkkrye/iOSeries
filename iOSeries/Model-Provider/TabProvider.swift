//
//  TabProvider.swift
//  iOSeries
//
//  Created by Pierre on 09/12/2016.
//  Copyright © 2016 Pierre Boudon. All rights reserved.
//

import Foundation
import ColorMatchTabs

class TabItemsProvider {
    
    static let items = {
        return [
            TabItem(
                title: "Vues",
                tintColor: UIColor.iOSeriesBlueColor,
                normalImage: UIImage(named: "sttchecked")!,
                highlightedImage: UIImage(named: "sttwhitechecked")!
            ),
            TabItem(
                title: "A Voir",
                tintColor: UIColor.iOSeriesGreenColor,
                normalImage: UIImage(named: "stt")!,
                highlightedImage: UIImage(named: "sttwhite")!
            ),
            TabItem(
                title: "Programmées",
                tintColor: UIColor.iOSeriesYellowColor,
                normalImage: UIImage(named: "scheduled")!,
                highlightedImage: UIImage(named: "scheduledwhite")!
            )
        ]
    }()
    
    static let viewControllers: [UIViewController] = {
        return [WatchedSeriesTableViewController(), ToWatchSeriesTableViewController(), ScheduledSeriesTableViewController()]
    }()
    
}




struct TabItem {
    
    let title: String
    let tintColor: UIColor
    let normalImage: UIImage
    let highlightedImage: UIImage
}
