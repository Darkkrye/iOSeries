//
//  ScheduledSeriesTableViewController.swift
//  iOSeries
//
//  Created by Pierre on 12/12/2016.
//  Copyright © 2016 Pierre Boudon. All rights reserved.
//

import UIKit
import CoreData

class ScheduledSeriesTableViewController: UITableViewController {

    var currentColor = UIColor.iOSeriesYellowColor
    
    var shows = [Show]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.register(UINib(nibName: "DefaultTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DefaultCell")
        self.tableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(ScheduledSeriesTableViewController.updateShows), name: Notification.Name("UpdateShows"), object: nil)
        
        self.updateShows()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.shows.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! DefaultTableViewCell
        
        // Configure the cell...
        let show = self.shows[indexPath.row]
        
        cell.showImageView.image = show.show_imageBanner
        cell.showNameLabel.text = "\(show.show_title) (\(show.show_creationYear))"
        cell.showInfoLabel.text = "Tous les \(show.show_scheduledDate!.getDayName()) à \(show.show_scheduledDate!.getTimeDate())"
        cell.showNoteCosmosView.rating = show.show_note
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DefaultTableViewCell.height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let show = self.shows[indexPath.row]
        let vc = DetailsParallaxViewController(nibName: "DetailsParallaxViewController", bundle: Bundle.main)
        vc.id = show.show_id
        vc.currentColor = self.currentColor
        vc.isAlreadyWatchedShow = show.show_alreadyWatched
        vc.isScheduled = show.show_isScheduled
        
        self.present(vc, animated: true, completion: nil)
    }

    func updateShows() {
        // Remove current Shows
        self.shows.removeAll()
        
        // Retrieve Shows
        let fr: NSFetchRequest = CD_Show.fetchRequest()
        // fr.predicate = NSPredicate(format: "alreadyWatched==%@", "true")
        if let context = DataManager.shared.objectContext {
            if let rows = try? context.fetch(fr) {
                for s in rows {
                    if s.alreadyWatched && s.isScheduled {
                        self.shows.append(Show(id: Int(s.id), title: s.title!, seasonNumber: Int(s.seasonNumber), episodeNumber: Int(s.episodeNumber), creationYear: s.creationYear!, note: s.note, imageBanner: s.imageBannerURL!, alreadyWatched: s.alreadyWatched, isScheduled: s.isScheduled, scheduledDate: s.scheduledDate as? Date, wantsToWatch: s.wantsToWatch))
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }
}
