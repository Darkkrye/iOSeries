//
//  SearchSeriesViewController.swift
//  iOSeries
//
//  Created by Pierre on 09/12/2016.
//  Copyright © 2016 Pierre Boudon. All rights reserved.
//

import UIKit

class SearchSeriesViewController: UIViewController {

    var currentColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let color = self.currentColor {
            self.view.backgroundColor = color.withAlphaComponent(0.5)
        } else {
            self.view.backgroundColor = UIColor.white
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
