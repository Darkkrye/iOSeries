//
//  ALAccordionSectionDelegate.swift
//  ALAccordion
//
//  Created by Sam Williams on 16/04/2015.
//  Copyright (c) 2015 Alliants Ltd. All rights reserved.
//
//  http://alliants.com
//

import UIKit

@objc public protocol ALAccordionSectionDelegate: class
{
    var headerView: UIView { get }

    @objc optional func sectionWillOpen(animated: Bool)
    @objc optional func sectionWillClose(animated: Bool)

    @objc optional func sectionDidOpen()
    @objc optional func sectionDidClose()
}
