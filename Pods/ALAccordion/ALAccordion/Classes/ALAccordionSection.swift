//
//  ALAccordionSection.swift
//  ALAccordion
//
//  Created by Sam Williams on 13/04/2015.
//  Copyright (c) 2015 Alliants Ltd. All rights reserved.
//
//  http://alliants.com
//

import UIKit

open class ALAccordionSection: NSObject
{
    // MARK: - Properties

    internal weak var accordion: ALAccordionController?
    {
        didSet
        {
            // Start off closed
            self.activateCloseConstraints()
        }
    }

    internal var sectionView = UIView()

    fileprivate let headerContainerView = UIView()
    fileprivate let bodyContainerView = UIView()

    fileprivate (set) open var viewController: UIViewController!

    internal var openConstraint: NSLayoutConstraint!
    internal var closeConstraint: NSLayoutConstraint!

    fileprivate (set) internal var open = false

    internal init(viewController: UIViewController)
    {
        super.init()

        assert(viewController is ALAccordionSectionDelegate, "View Controller \(viewController) must conform to the protocol ALAccordionSectionDelegate")

        self.viewController = viewController

        self.sectionView.clipsToBounds = true

        self.setupHeaderView((viewController as! ALAccordionSectionDelegate).headerView)
        self.setupBodyView(viewController.view)

        self.layoutViews()
    }

    // MARK: - Layout Methods

    fileprivate func layoutViews()
    {
        // Layout the header and body views

        self.sectionView.addSubview(self.headerContainerView)
        self.sectionView.addSubview(self.bodyContainerView)

        self.headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.bodyContainerView.translatesAutoresizingMaskIntoConstraints = false

        // Header should hug tightly - body loosly
        self.headerContainerView.setContentHuggingPriority(1000, for: .vertical)
        self.headerContainerView.setContentCompressionResistancePriority(1000, for: .vertical)

        self.bodyContainerView.setContentHuggingPriority(250, for: .vertical)
        self.bodyContainerView.setContentCompressionResistancePriority(250, for: .vertical)

        self.headerContainerView.clipsToBounds = true
        self.bodyContainerView.clipsToBounds = true

        // Constraints
        let views = ["header": self.headerContainerView, "body": self.bodyContainerView]

        let headerHorizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[header]|", options: [], metrics: nil, views: views)
        let bodyHorizontal   = NSLayoutConstraint.constraints(withVisualFormat: "H:|[body]|", options: [], metrics: nil, views: views)

        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[header][body]", options: [], metrics: nil, views: views)

        self.sectionView.addConstraints(headerHorizontal + bodyHorizontal + vertical)

        // Create the constraint for opening / closing section
        self.openConstraint = NSLayoutConstraint(item: self.sectionView, attribute: .bottom, relatedBy: .equal, toItem: self.bodyContainerView, attribute: .bottom, multiplier: 1.0, constant: 0)
        self.closeConstraint = NSLayoutConstraint(item: self.headerContainerView, attribute: .bottom, relatedBy: .equal, toItem: self.sectionView, attribute: .bottom, multiplier: 1.0, constant: 0)
    }

    internal func setupHeaderView(_ header: UIView)
    {
        // Add the header view to the header container view
        self.headerContainerView.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false

        // Constraints
        let views = ["header": header]
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[header]|", options: [], metrics: nil, views: views)
        let vertical   = NSLayoutConstraint.constraints(withVisualFormat: "V:|[header]", options: [], metrics: nil, views: views)

        // Low priority bottom view that can break if needed
        let bottom = NSLayoutConstraint(item: self.headerContainerView, attribute: .bottom, relatedBy: .equal, toItem: header, attribute: .bottom, multiplier: 1.0, constant: 0)
        //bottom.priority = 250

        self.headerContainerView.addConstraints(horizontal + vertical)
        self.headerContainerView.addConstraint(bottom)
    }

    internal func setupBodyView(_ body: UIView)
    {
        // Add the footer view to the footer container view
        self.bodyContainerView.addSubview(body)
        body.translatesAutoresizingMaskIntoConstraints = false

        // Constraints
        let views = ["body": body]
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[body]|", options: [], metrics: nil, views: views)
        let vertical   = NSLayoutConstraint.constraints(withVisualFormat: "V:|[body]", options: [], metrics: nil, views: views)

        // Low priority bottom view that can break if the containing body view is a fixed height
        let bottom = NSLayoutConstraint(item: self.bodyContainerView, attribute: .bottom, relatedBy: .equal, toItem: body, attribute: .bottom, multiplier: 1.0, constant: 0)
        bottom.priority = 250

        self.bodyContainerView.addConstraints(horizontal + vertical)
        self.bodyContainerView.addConstraint(bottom)
    }


    // MARK: - Opening / closing the section

    internal func activateOpenConstraints()
    {
        // Swap open / close constraints
        self.sectionView.removeConstraint(self.closeConstraint)
        self.sectionView.addConstraint(self.openConstraint)

        // Mark as open
        self.open = true
    }

    internal func activateCloseConstraints()
    {
        // Swap open / close constraints
        self.sectionView.removeConstraint(self.openConstraint)
        self.sectionView.addConstraint(self.closeConstraint)

        // Mark as closed
        self.open = false
    }
}
