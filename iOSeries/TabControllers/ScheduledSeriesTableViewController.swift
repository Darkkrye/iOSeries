//
//  ScheduledSeriesTableViewController.swift
//  iOSeries
//
//  Created by Pierre on 12/12/2016.
//  Copyright © 2016 Pierre Boudon. All rights reserved.
//

import UIKit

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
        
        // Create fake serie
        let show = Show(id: 531, title: "Hero Corp", desc: "À la suite de la guerre qui fit rage dans les années 80, l'agence Hero Corp fut créée pour regrouper tous les super-héros et maintenir un climat de paix. Parmi eux, les retraités, les mis au rancart, les démissionnaires, les démasqués, les pas formés (en fait les héros hors norme) sont installés en Lozère pour mener une vie calme et paisible. Vingt ans de train-train volent en éclats quand The Lord réapparaît. Face au plus grand super-vilain de l'Histoire que tout le monde croyait mort, le village est démuni. Selon une vision de la Voix, John est la solution à ce danger que la maison-mère préfère garder sous silence. John arrive au village, mais il ignore tout de sa véritable identité et n'a aucune idée de ce qu'il va devoir accomplir pour sauver le monde.", seasonNumber: 4, episodeNumber: 85, genders: ["Comedy"], creationYear: "2008", network: "France 4", status: "Continuing", note: 4.3002, noters: 543, imageShow: "http://www.betaseries.com/images/fonds/show/531_1363708189.jpg", imageBanner: "http://www.betaseries.com/images/fonds/banner/531_1362334960.jpg", imagePoster: "http://www.betaseries.com/images/fonds/poster/83750.jpg", url: "https://www.betaseries.com/serie/herocorp", seasons: [Season]())
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
        cell.showInfoLabel.text = "Tous les Lundis à 19h00"
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
        vc.isScheduled = true
        
        self.present(vc, animated: true, completion: nil)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
