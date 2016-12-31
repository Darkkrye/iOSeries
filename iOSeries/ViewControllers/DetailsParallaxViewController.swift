//
//  DetailsParallaxViewController
//  DetailsParallaxView
//
//  Created by Pierre on 30/03/2016.
//  Copyright © 2016 Pierre. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import HSDatePickerViewController
import UserNotifications

class DetailsParallaxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, KMScrollingHeaderViewDelegate/*, ParallaxDetailsViewDelegate, UIPickerViewDelegate*/ {
    
    // MARK: - Private Constants
    let buttonBack = UIButton(type: .custom)
    let blackImageView = UIView()
    let newImageView = UIImageView()
    let firstAccordionCell = 5
    
    
    // MARK: - Private Variables
    var dragging = false
    var oldX: CGFloat = 0.0
    var oldY: CGFloat = 0.0
    
    var endX: CGFloat = 0.0
    var endY: CGFloat = 0.0
    
    var statusBarHidden = true
    var imageLocation = CGPoint(x: 0, y: 0)
    
    var id = 0
    var show: Show?
    
    var currentColor = UIColor.white
    
    var loadingView: UIView!
    
    var isAlreadyWatchedShow = false
    var isScheduled = false
    var wantsToWatchShow = false
    
    var cells = SwiftyAccordionCells()
    var previouslySelectedHeaderIndex: Int?
    var selectedHeaderIndex: Int?
    var selectedItemIndex: Int?
    
    var watchedEpisodes: [String] = [String]()
    
    // MARK: - IBOutlets
    @IBOutlet var scrollingHeaderView: KMScrollingHeaderView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navBarTitleLabel: UILabel!
    
    
    // MARK: - IBActions
    
    
    // MARK: - "Default" Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.watchedEpisodes = self.retrieveWatchedEpisodes()
        
        self.navBar.alpha = 0
        self.statusBarHidden = true
        self.navBar.backgroundColor = currentColor
        
        self.loadingView = UIView()
        self.loadingView.frame = UIScreen.main.bounds
        self.loadingView.backgroundColor = self.currentColor
        
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.center = self.loadingView.center
        activity.isHidden = false
        activity.startAnimating()
        self.loadingView.insertSubview(activity, aboveSubview: self.loadingView)
        
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: self.view.frame.width, height: 20))
        label.textAlignment = .center
        label.center = self.loadingView.center
        label.frame.origin.y -= 50
        label.text = "Chargement de la série"
        label.textColor = UIColor.white
        self.loadingView.insertSubview(label, aboveSubview: self.loadingView)
        
        self.view.addSubview(self.loadingView)
        
        // Added first serie from API call
        Alamofire.request("\(URLProvider.getEpisodesURL)\(self.id)", headers: APIInfoProvider.headers).responseJSON { response in
            if response.response?.statusCode == 200 {
                
                // Create episodes
                let json = JSON(response.result.value!)
                
                var episodes = [Episode]()
                
                for episode in json["episodes"] {
                    let ep = Episode(id: episode.1["id"].intValue, title: episode.1["title"].stringValue, season: episode.1["season"].intValue, episode: episode.1["episode"].intValue, code: episode.1["code"].stringValue, description: episode.1["description"].stringValue, date: episode.1["date"].stringValue, rating: Double(episode.1["note"]["mean"].stringValue)!)
                    episodes.append(ep)
                }
                
                Alamofire.request("\(URLProvider.getShowURL)\(self.id)", headers: APIInfoProvider.headers).responseJSON { response in
                    if response.response?.statusCode == 200 {
                        let json: JSON = JSON(response.result.value!)
                        
                        // Create seasons
                        let seasonNumber = Int(json["show"]["seasons"].stringValue)!
                        var seasons = [Season]()
                        for i in 1...seasonNumber {
                            seasons.append(Season(number: i))
                        }
                        
                        for episode in episodes {
                            let s = seasons[episode.episode_season-1]
                            s.episodes.append(episode)
                        }
                        
                        let show = Show(id: json["show"]["id"].intValue, title: json["show"]["title"].stringValue, desc: json["show"]["description"].stringValue, seasonNumber: seasonNumber, episodeNumber: Int(json["show"]["episodes"].stringValue)!, genders: [String](), creationYear: json["show"]["creation"].stringValue, network: json["show"]["network"].stringValue, status: json["show"]["status"].stringValue, note: json["show"]["notes"]["mean"].doubleValue, noters: json["show"]["notes"]["total"].intValue, imageShow: json["show"]["images"]["show"].stringValue, imageBanner: json["show"]["images"]["banner"].stringValue, imagePoster: json["show"]["images"]["poster"].stringValue, url: json["show"]["resource_url"].stringValue, seasons: seasons)
                        
                        show.show_alreadyWatched = self.isAlreadyWatchedShow
                        show.show_isScheduled = self.isScheduled
                        show.show_wantsToWatch = self.wantsToWatchShow
                        
                        for gender in json["show"]["genres"] {
                            show.show_genders.append(gender.1.stringValue)
                        }
                        
                        self.show = show
                        
                        DispatchQueue.main.async {
                            self.setupDetailsPageView()
                            self.setupNavbarButtons()
                            self.setupSeasonCells()
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    // MARK: - Delegates
    // MARK: Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 + self.cells.items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        if let show = self.show {
            switch indexPath.row {
            case 0:
                break
                
            case 1:
                var infoDetailsCell: InfoDetailsTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "InfoDetailsTableViewCell") as? InfoDetailsTableViewCell
                
                if infoDetailsCell == nil {
                    infoDetailsCell = InfoDetailsTableViewCell.infoDetails()
                }
                
                infoDetailsCell.authorImageView.image = self.show?.show_imagePoster
                infoDetailsCell.titleLabel.text = "\(show.show_title) - (\(show.show_creationYear)) - \(show.show_Status)"
                infoDetailsCell.authorLabel.text = "\(show.show_seasonNumber) Saisons - \(show.show_episodeNumber) Episodes"
                
                if show.show_alreadyWatched {
                    infoDetailsCell.seenButton.setTitle("Pas vu !", for: .normal)
                    infoDetailsCell.seenButton.tag = 1
                    
                    // UI
                    infoDetailsCell.rappelButton.layer.borderColor = self.currentColor.cgColor
                    infoDetailsCell.rappelButton.backgroundColor = self.currentColor
                    infoDetailsCell.rappelButton.setTitleColor(UIColor.white, for: .normal)
                    infoDetailsCell.rappelButton.tag = 0
                    infoDetailsCell.rappelButton.isHidden = false
                    
                    infoDetailsCell.seenButton.layer.borderColor = self.currentColor.cgColor
                    infoDetailsCell.seenButton.setTitleColor(self.currentColor, for: .normal)
                    infoDetailsCell.seenButton.backgroundColor = UIColor.white
                    
                    if show.show_isScheduled {
                        infoDetailsCell.rappelButton.setTitle("Supprimer rappel", for: .normal)
                        infoDetailsCell.rappelButton.tag = 1
                    } else {
                        infoDetailsCell.rappelButton.setTitle("Ajouter rappel", for: .normal)
                        infoDetailsCell.rappelButton.tag = 0
                    }
                    
                } else {
                    infoDetailsCell.seenButton.setTitle("J'ai vu !", for: .normal)
                    infoDetailsCell.seenButton.tag = 0
                    
                    // UI
                    infoDetailsCell.seenButton.layer.borderColor = self.currentColor.cgColor
                    infoDetailsCell.seenButton.backgroundColor = self.currentColor
                    infoDetailsCell.seenButton.setTitleColor(UIColor.white, for: .normal)
                    
                    infoDetailsCell.rappelButton.backgroundColor = UIColor.white
                    infoDetailsCell.rappelButton.setTitleColor(self.currentColor, for: .normal)
                    infoDetailsCell.rappelButton.layer.borderColor = self.currentColor.cgColor
                    
                    if show.show_wantsToWatch {
                        infoDetailsCell.rappelButton.setTitle("Je ne veux plus voir", for: .normal)
                        infoDetailsCell.rappelButton.tag = 3
                    } else {
                        infoDetailsCell.rappelButton.setTitle("Je veux voir", for: .normal)
                        infoDetailsCell.rappelButton.tag = 2
                    }
                }
                
                infoDetailsCell.titleLabel.textColor = self.currentColor
                
                infoDetailsCell.delegate = self
                
                cell = infoDetailsCell
                
                break
                
            case 2:
                var descriptionView: DescriptionTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell") as? DescriptionTableViewCell
                
                if descriptionView == nil {
                    descriptionView = DescriptionTableViewCell.descriptionCell()
                }
                
                descriptionView.descriptionLabel.text = show.show_description
                
                
                cell = descriptionView
                
                break
                
            case 3:
                var descriptionCell: DescriptionTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell") as? DescriptionTableViewCell
                
                if descriptionCell == nil {
                    descriptionCell = DescriptionTableViewCell.descriptionCell()
                }
                
                var text = ""
                for i in 0..<show.show_genders.count {
                    text += "● \(show.show_genders[i])"
                    
                    if i != show.show_genders.count - 1 {
                        text += "\r\n"
                    }
                }
                descriptionCell.descriptionLabel.text = text
                
                cell = descriptionCell
                
                break
                
            case 4:
                var ratingCell: RatingTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell") as? RatingTableViewCell
                
                if ratingCell == nil {
                    ratingCell = RatingTableViewCell.ratingCell()
                }
                
                ratingCell.votesLabel.text = "\(show.show_noters)"
                ratingCell.ratingCosmosView.rating = show.show_note
                
                cell = ratingCell
                
                break
                
            default:
                let item = self.cells.items[indexPath.row - self.firstAccordionCell]
                let value = item.value
                cell.textLabel?.text = value
                
                if item as? SwiftyAccordionCells.HeaderItem != nil {
                    cell.backgroundColor = self.currentColor
                    cell.accessoryType = .disclosureIndicator
                }
                
                if self.isWatchedEpisode(episodeName: value) {
                    cell.accessoryType = .checkmark
                }
                
                break
            }
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0.0
        
        switch indexPath.row {
        case 0:
            height = 0
            break
            
        case 1:
            height = 104
            break
            
        case 2:
            height = 300
            break
            
        case 3:
            height = 125
            break
            
        case 4:
            height = 65
            break
            
        default:
            let item = self.cells.items[indexPath.row - self.firstAccordionCell]
            
            if item is SwiftyAccordionCells.HeaderItem {
                height = 50
            } else if item.isHidden {
                height = 0
            } else {
                height = 44
            }
            break
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.scrollingHeaderView.tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.row {
        case 0, 1, 2, 3, 4:
            break
            
        default:
            let item = self.cells.items[indexPath.row - self.firstAccordionCell]
            
            if item is SwiftyAccordionCells.HeaderItem {
                if self.selectedHeaderIndex == nil {
                    self.selectedHeaderIndex = indexPath.row
                } else {
                    self.previouslySelectedHeaderIndex = self.selectedHeaderIndex
                    self.selectedHeaderIndex = indexPath.row
                }
                
                if let pSHI = self.previouslySelectedHeaderIndex {
                    self.cells.collapse(pSHI)
                }
                
                if self.previouslySelectedHeaderIndex != self.selectedHeaderIndex {
                    self.cells.expand(self.selectedHeaderIndex!)
                } else {
                    self.selectedHeaderIndex = nil
                    self.previouslySelectedHeaderIndex = nil
                }
                
                self.scrollingHeaderView.tableView.beginUpdates()
                self.scrollingHeaderView.tableView.endUpdates()
                // self.scrollingHeaderView.tableView.reloadData()
                
                self.navBar.alpha = 1
                self.statusBarHidden = false
            } else {
                let cell = tableView.cellForRow(at: indexPath)
                if self.isWatchedEpisode(episodeName: item.value) {
                    cell?.accessoryType = .none
                    self.removeFromWatchedEpisode(episodeName: item.value)
                } else {
                    cell?.accessoryType = .checkmark
                    self.watchedEpisodes.append(item.value)
                }
                
                self.saveWatchedEpisodes()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /*if let imageCell = self.scrollingHeaderView.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? ImageTableViewCell {
            imageCell.scrollViewDidScroll(scrollView)
        }*/
        
        if !isRowVisible() {
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                self.navBar.alpha = 1
                self.statusBarHidden = false
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                self.navBar.alpha = 0
                self.statusBarHidden = true
            }, completion: nil)
        }
        
        var fixedButtonFrame = self.buttonBack.frame
        fixedButtonFrame.origin.y = 31 + scrollView.contentOffset.y
        self.buttonBack.frame = fixedButtonFrame
    }
    
    
    // MARK: - Personnal Delegates
    // MARK: Delegates KMScrollingHeaderViewDelegate
    func detailsPage(_ scrollingHeaderView: KMScrollingHeaderView!, headerImageView imageView: UIImageView!) {
        DispatchQueue.main.async {
            imageView.image = self.show?.show_imageShow
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    // MARK: Delegates ParallaxDetailsViewProtocol
    
    // MARK: - Personnal Methods
    func setupDetailsPageView() {
        self.scrollingHeaderView.tableView.dataSource = self
        self.scrollingHeaderView.tableView.delegate = self
        self.scrollingHeaderView.delegate = self
        self.scrollingHeaderView.tableView.separatorColor = UIColor.clear
        self.scrollingHeaderView.headerImageViewContentMode = .top
        
        self.navBarTitleLabel.text = self.show?.show_title
        
        UIView.animate(withDuration: 1, animations: {() -> Void in
            self.loadingView.alpha = 0
        }, completion: { (boolean) -> Void in
            self.loadingView.removeFromSuperview()
        })
        
        self.scrollingHeaderView.reloadScrollingHeader()
    }
    
    func setupNavbarButtons() {
        let buttonBack = UIButton(type: .custom)
        
        buttonBack.frame = CGRect(x: 20, y: 31, width: 22, height: 22)
        buttonBack.setImage(UIImage(named: "multiply"), for: UIControlState.normal)
        buttonBack.addTarget(self, action: #selector(DetailsParallaxViewController.backButton), for: .touchUpInside)
        
        self.view.addSubview(buttonBack)
    }
    
    func setupSeasonCells() {
        
        var ss = self.show!.show_seasons
        ss.sort(by: { $0.season_number > $1.season_number })
        
        for season in ss {
            self.cells.append(SwiftyAccordionCells.HeaderItem(value: "Saison \(season.season_number) - \(season.episodes.count) episodes"))
            
            for episode in season.episodes {
                self.cells.append(SwiftyAccordionCells.Item(value: "\(episode.episode_code) - \(episode.episode_title)"))
            }
        }
        
        self.scrollingHeaderView.tableView.reloadData()
    }
    
    func isRowVisible() -> Bool {
        guard let indexes = self.scrollingHeaderView.tableView.indexPathsForVisibleRows else {
            return false
        }
        
        for index in indexes {
            if index.row == 0 {
                return true
            }
        }
        
        return false
    }
    
    func backButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveCurrentShowState() {
        if let context = DataManager.shared.objectContext {
            
            let fr: NSFetchRequest = CD_Show.fetchRequest()
            var alreadyExists = false
            
            if let show = self.show {
                
                if let rows = try? context.fetch(fr) {
                    for cShow in rows {
                        if show.show_id == Int(cShow.id) {
                            
                            alreadyExists = true
                            
                            if show.show_alreadyWatched || show.show_wantsToWatch {
                                // UPDATE
                                cShow.id = Int16(show.show_id)
                                cShow.title = show.show_title
                                cShow.seasonNumber = Int16(show.show_seasonNumber)
                                cShow.episodeNumber = Int16(show.show_episodeNumber)
                                cShow.creationYear = show.show_creationYear
                                cShow.note = show.show_note
                                cShow.imageBannerURL = show.show_imageBannerURL
                                cShow.alreadyWatched = show.show_alreadyWatched
                                cShow.isScheduled = show.show_isScheduled
                                cShow.scheduledDate = show.show_scheduledDate as NSDate?
                                cShow.wantsToWatch = show.show_wantsToWatch
                                
                                if show.show_isScheduled {
                                    self.scheduleShow()
                                } else {
                                    self.unscheduleShow()
                                }
                                
                            } else {
                                // DELETE
                                context.delete(cShow)
                                self.unscheduleShow()
                                self.removeAllWatchedEpisodes()
                            }
                            
                            break
                        }
                    }
                }
                
                if !alreadyExists {
                    // CREATE
                    if let s = NSEntityDescription.insertNewObject(forEntityName: "CD_Show", into: context) as? CD_Show {
                        s.id = Int16(show.show_id)
                        s.title = show.show_title
                        s.seasonNumber = Int16(show.show_seasonNumber)
                        s.episodeNumber = Int16(show.show_episodeNumber)
                        s.creationYear = show.show_creationYear
                        s.note = show.show_note
                        s.imageBannerURL = show.show_imageBannerURL
                        s.alreadyWatched = show.show_alreadyWatched
                        s.isScheduled = show.show_isScheduled
                        s.scheduledDate = show.show_scheduledDate as NSDate?
                        s.wantsToWatch = show.show_wantsToWatch
                    }
                }
            }
        
            try? context.save()
            NotificationCenter.default.post(name: Notification.Name("UpdateShows"), object: nil)
        }
    }
    
    func scheduleShow() {
        print("Schedule Show")
        if let selectedDate = self.show!.show_scheduledDate {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate?.scheduleNotification(at: selectedDate, showName: self.show!.show_title, imageURL: self.show!.show_imageShowURL)
        }
    }
    
    func unscheduleShow() {
        print("Unschedule Show")
        let identifiers = ["Scheduled \(self.show!.show_title)", "\(self.show!.show_title)"]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}

// Extension for InfoDetailstableViewCell Delegate
extension DetailsParallaxViewController: InfoDetailsTableViewCellDelegate {
    func setShowAsSeen() {
        print("J'ai vu")
        
        self.show!.show_alreadyWatched = true
        self.show!.show_wantsToWatch = false
        
        self.saveCurrentShowState()
        
        self.scrollingHeaderView.tableView.reloadData()
    }
    
    func setShowAsUnseen() {
        print("Pas vu")
        
        self.show!.show_alreadyWatched = false
        self.show!.show_isScheduled = false
        self.show!.show_wantsToWatch = false
        
        self.saveCurrentShowState()
        
        self.scrollingHeaderView.tableView.reloadData()
    }
    
    func schedule() {
        print("Schedule")
        
        let hsdpvc = HSDatePickerViewController()
        hsdpvc.mainColor = self.currentColor
        hsdpvc.confirmButtonTitle = "Programmer"
        hsdpvc.backButtonTitle = "Annuler"
        hsdpvc.delegate = self
        
        self.present(hsdpvc, animated: true, completion: nil)
    }
    
    func unschedule() {
        print("Unschedule")
        
        self.show!.show_isScheduled = false
        
        self.saveCurrentShowState()
        
        self.scrollingHeaderView.tableView.reloadData()
    }
    
    func wantsToWatch() {
        print("Je veux voir")
        
        self.show!.show_wantsToWatch = true
        self.show!.show_alreadyWatched = false
        self.show!.show_isScheduled = false
        
        self.saveCurrentShowState()
        
        self.scrollingHeaderView.tableView.reloadData()
    }
    
    func wantsToUnwatch() {
        print("Je ne veux plus voir")
        
        self.show!.show_wantsToWatch = false
        self.show!.show_alreadyWatched = false
        self.show!.show_isScheduled = false
        
        self.saveCurrentShowState()
        
        self.scrollingHeaderView.tableView.reloadData()
    }
}

extension DetailsParallaxViewController: HSDatePickerViewControllerDelegate {
    func hsDatePickerPickedDate(_ date: Date!) {
        
        self.show!.show_isScheduled = true
        self.show!.show_scheduledDate = date
        
        self.saveCurrentShowState()
        
        self.scrollingHeaderView.tableView.reloadData()
    }
}

// Extension for personal methods
extension DetailsParallaxViewController {
    func retrieveWatchedEpisodes() -> [String] {
        let ep = UserDefaults.standard.array(forKey: "\(self.id)")
        if let eps: [String] = ep as? [String] {
            return eps
        }
        
        return [String]()
    }
    
    func saveWatchedEpisodes() {
        let def = UserDefaults.standard
        def.set(self.watchedEpisodes, forKey: "\(self.id)")
        def.synchronize()
    }
    
    func isWatchedEpisode(episodeName: String) -> Bool {
        if self.watchedEpisodes.count > 0 {
            for ep in self.watchedEpisodes {
                if ep == episodeName {
                    return true
                }
            }
        }
        return false
    }
    
    func removeFromWatchedEpisode(episodeName: String) {
        for i in 0...self.watchedEpisodes.count {
            if self.watchedEpisodes[i] == episodeName {
                self.watchedEpisodes.remove(at: i)
                break
            }
        }
    }
    
    func removeAllWatchedEpisodes() {
        let def = UserDefaults.standard
        def.removeObject(forKey: "\(self.id)")
        def.synchronize()
    }
}
