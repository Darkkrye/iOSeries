//
//  ToWatchSeriesTableViewController.swift
//  iOSeries
//
//  Created by Inas on 01/01/2017.
//  Copyright © 2016 Inas Ait Mansour. All rights reserved.
//
import UIKit
import CoreData

class ToWatchSeriesTableViewController: UITableViewController {
    
    var currentColor = UIColor.iOSeriesGreenColor
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(ToWatchSeriesTableViewController.updateShows), name: Notification.Name("UpdateShows"), object: nil)
        
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
        cell.showInfoLabel.text = "\(show.show_seasonNumber) saisons - \(show.show_episodeNumber) episodes"
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
        vc.wantsToWatchShow = show.show_wantsToWatch
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func updateShows() {
        // Remove current Shows
        self.shows.removeAll()
        
        // Retrieve Shows
        let fr: NSFetchRequest = CD_Show.fetchRequest()
        // fr.predicate = NSPredicate(format: "wantsToWatch==%@", "true")
        if let context = DataManager.shared.objectContext {
            if let rows = try? context.fetch(fr) {
                for s in rows {
                    if s.wantsToWatch {
                        self.shows.append(Show(id: Int(s.id), title: s.title!, seasonNumber: Int(s.seasonNumber), episodeNumber: Int(s.episodeNumber), creationYear: s.creationYear!, note: s.note, imageBanner: s.imageBannerURL!, alreadyWatched: s.alreadyWatched, isScheduled: s.isScheduled, scheduledDate: s.scheduledDate as? Date, wantsToWatch: s.wantsToWatch))
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }
}
