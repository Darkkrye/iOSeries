//
//  WatchedSeriesTableViewController.swift
//  iOSeries
//
//  Created by Pierre on 09/12/2016.
//  Copyright © 2016 Pierre Boudon. All rights reserved.
//

import UIKit

class WatchedSeriesTableViewController: UITableViewController {
    
    var currentColor = UIColor.iOSeriesBlueColor
    
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
        let show = Show(id: 2224, title: "Le Coeur A Ses Raisons", desc: "Le coeur a ses raisons est une palpitante parodie de feuilleton télévisé populaire contenant tous les clichés qui se rattachent au genre. On y propose un univers complètement éclaté ou sont poussés à l'extrême les intrigues amoureuses, les drames familiaux, les luttes de pouvoir, les trahisons, les complots, les histoires d'adultères et d'enfants illégitimes. Bref, là ou se joue le classique combat entre le bien et le mal.", seasonNumber: 3, episodeNumber: 39, genders: ["Comedy"], creationYear: "2005", network: "TVA", status: "Ended", note: 4.5114, noters: 88, imageShow: "http://www.betaseries.com/images/fonds/show/2224_1379364825.jpg", imageBanner: "http://www.betaseries.com/images/fonds/banner/2224_1362236212.jpg", imagePoster: "http://www.betaseries.com/images/fonds/poster/80741.jpg", url: "https://www.betaseries.com/serie/le-coeur-a-ses-raisons", seasons: [Season]())
        show.show_alreadyWatched = true
        
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
        cell.showNameLabel.text = "\(show.show_title) (\(show.show_creationYear))"
        cell.showInfoLabel.text = "\(show.show_seasonNumber) saisons - \(show.show_episodeNumber) episodes"
        cell.showNoteCosmosView.rating = show.show_note

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let show = self.shows[indexPath.row]
        let vc = DetailsParallaxViewController(nibName: "DetailsParallaxViewController", bundle: Bundle.main)
        vc.id = show.show_id
        vc.currentColor = self.currentColor
        vc.isAlreadyWatchedShow = true
        
        self.present(vc, animated: true, completion: nil)
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
