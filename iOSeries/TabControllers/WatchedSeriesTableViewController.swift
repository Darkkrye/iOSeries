//
//  WatchedSeriesTableViewController.swift
//  iOSeries
//
//  Created by Pierre on 09/12/2016.
//  Copyright © 2016 Pierre Boudon. All rights reserved.
//

import UIKit

class WatchedSeriesTableViewController: UITableViewController {
    
    var shows = [Show]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.register(UINib(nibName: "DefaultTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DefaultCell")
        
        // Create fake serie
        let show = Show(id: 26, title: "Dexter", desc: "Brillant expert scientifique du service médico-légal de la police de Miami, Dexter Morgan est spécialisé dans l'analyse de prélèvements sanguins. Mais voilà, Dexter cache un terrible secret : il est également tueur en série. Un serial killer pas comme les autres, avec sa propre vision de la justice.", seasonNumber: "8", episodeNumber: "100", genders: ["Crime", "Drama", "Mystery", "Suspense", "Thriller"], creationYear: "2006", network: "Showtime", status: "Ended", note: 4.57215, noters: 4345, imageShow: "http://www.betaseries.com/images/fonds/show/26_1362244322.jpg", imageBanner: "http://www.betaseries.com/images/fonds/banner/26_1362236173.jpg", imagePoster: "http://www.betaseries.com/images/fonds/poster/79349.jpg", url: "https://www.betaseries.com/serie/dexter", seasons: [Season]())
        
        self.shows.append(show)
        self.tableView.reloadData()
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
        cell.showNameLabel.text = show.show_title
        cell.showInfoLabel.text = "(\(show.show_creationYear)) - \(show.show_seasonNumber) saisons)"
        cell.showNoteCosmosView.rating = show.show_note

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
