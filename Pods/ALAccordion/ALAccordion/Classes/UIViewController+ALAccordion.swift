//
//  UIViewController+ALAccordion.swift
//  ALAccordion
//
//  Created by Sam Williams on 15/04/2015.
//  Copyright (c) 2015 Alliants Ltd. All rights reserved.
//
//  http://alliants.com
//

import UIKit

public extension UIViewController
{
    // The nearest ancestor in the view controller hierarchy that is an accordion controller.
    public var accordionController: ALAccordionController?
    {
        var parent = self.parent

        while parent != nil
        {
            if let accordion = parent as? ALAccordionController
            {
                return accordion
            }

            parent = parent?.parent
        }

        return nil
    }
}
