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

class DetailsParallaxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, KMScrollingHeaderViewDelegate/*, ParallaxDetailsViewDelegate, UIPickerViewDelegate*/ {
    
    // MARK: - Private Constants
    let buttonBack = UIButton(type: .custom)
    let blackImageView = UIView()
    let newImageView = UIImageView()
    
    
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
    
    // MARK: - IBOutlets
    @IBOutlet var scrollingHeaderView: KMScrollingHeaderView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navBarTitleLabel: UILabel!
    
    
    // MARK: - IBActions
    
    
    // MARK: - "Default" Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBar.alpha = 0
        self.statusBarHidden = true
        self.navBar.backgroundColor = currentColor
        
        self.loadingView = UIView()
        self.loadingView.frame = self.view.frame
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
                        
                        for gender in json["show"]["genres"] {
                            show.show_genders.append(gender.1.stringValue)
                        }
                        
                        self.show = show
                        
                        DispatchQueue.main.async {
                            self.setupDetailsPageView()
                            self.setupNavbarButtons()
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
        return 8
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if let show = self.show {
            switch indexPath.row {
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
                    
                    // UI
                    infoDetailsCell.rappelButton.layer.borderColor = self.currentColor.cgColor
                    infoDetailsCell.rappelButton.backgroundColor = self.currentColor
                    infoDetailsCell.rappelButton.setTitleColor(UIColor.white, for: .normal)
                    
                    infoDetailsCell.seenButton.layer.borderColor = self.currentColor.cgColor
                    infoDetailsCell.seenButton.setTitleColor(self.currentColor, for: .normal)
                    infoDetailsCell.seenButton.backgroundColor = UIColor.white
                } else {
                    infoDetailsCell.seenButton.setTitle("J'ai vu !", for: .normal)
                    
                    // UI
                    infoDetailsCell.seenButton.layer.borderColor = self.currentColor.cgColor
                    infoDetailsCell.seenButton.backgroundColor = self.currentColor
                    infoDetailsCell.seenButton.setTitleColor(UIColor.white, for: .normal)
                    
                    infoDetailsCell.rappelButton.isHidden = true
                    
                }
                
                infoDetailsCell.titleLabel.textColor = self.currentColor
                
                // infoDetailsCell.delegate = self
                
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
                
            /*case 4:
                var conseilsCell: ConseilsTableViewCell! = tableView.dequeueReusableCellWithIdentifier("ConseilsTableViewCell") as? ConseilsTableViewCell
                
                if conseilsCell == nil {
                    conseilsCell = ConseilsTableViewCell.conseilsCell()
                }
                
                conseilsCell.conseilsLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dictum neque ante, sed euismod ipsum aliquam et. Proin erat nulla, auctor eget convallis scelerisque, pulvinar eu tellus. Vestibulum molestie in turpis vitae convallis. Nunc tincidunt sapien non elit luctus, "
                
                cell = conseilsCell
                
                break
                
            case 5:
                var ratingCell: RatingTableViewCell! = tableView.dequeueReusableCellWithIdentifier("RatingTableViewCell") as? RatingTableViewCell
                
                if ratingCell == nil {
                    ratingCell = RatingTableViewCell.ratingCell()
                }
                
                ratingCell.noteLabel.text = "4"
                ratingCell.countLabel.text = "125 votes"
                ratingCell.distanceLabel.text = "250 m"
                
                cell = ratingCell
                
                break
                
            case 6:
                var moreCell: MoreTableViewCell! = tableView.dequeueReusableCellWithIdentifier("MoreTableViewCell") as? MoreTableViewCell
                
                if moreCell == nil {
                    moreCell = MoreTableViewCell.moreCell()
                }
                
                moreCell.delegate = self
                cell = moreCell
                
                break
                
            case 7:
                var moreImagesCell: MoreImagesTableViewCell! = tableView.dequeueReusableCellWithIdentifier("MoreImagesTableViewCell") as? MoreImagesTableViewCell
                
                if moreImagesCell == nil {
                    moreImagesCell = MoreImagesTableViewCell.moreImagesCell()
                }
                
                moreImagesCell.images = self.images
                moreImagesCell.imagePager.reloadData()
                
                moreImagesCell.delegate = self
                
                cell = moreImagesCell
                
                break*/
                
            default:
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
            height = 200
            break
            
        case 3:
            height = 125
            break
            
        case 5:
            height = 60
            break
            
        case 6:
            height = 62
            break
            
        case 7:
            height = 250
            break
            
        default:
            height = 100
            break
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
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
    
    /*override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = event?.allTouches()?.first
        let touchLocation = touch?.locationInView(self.view)
        
        if CGRectContainsPoint(self.view.frame, touchLocation!) {
            self.dragging = true
            self.oldX = (touchLocation?.x)!
            self.oldY = (touchLocation?.y)!
        }
    }*/
    
    /*override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIView.animateWithDuration(0.25, delay: 0.0, options: ([.BeginFromCurrentState, .CurveEaseInOut]), animations: {() -> Void in
            self.blackImageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            }, completion: { _ in })
        
        let touch = event?.allTouches()?.first
        let touchLocation = touch?.locationInView(self.view)
        
        if dragging {
            let imageView = self.blackImageView.subviews.first as! UIImageView
            
            var frame = self.view.frame
            
            self.endX = self.view.frame.origin.x + (touchLocation?.x)! - oldX
            self.endY = self.view.frame.origin.y + (touchLocation?.y)! - oldY
            
            frame.origin.x = self.endX
            frame.origin.y = self.endY
            
            imageView.frame = frame
        }
    }*/
    
    /*override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.dragging = false
        
        let imageView = self.blackImageView.subviews.first as! UIImageView
        
        if imageView.center.x <= -75 || imageView.center.x >= 450 || imageView.center.y <= 150 || imageView.center.y >= 550 {
            self.blackImageView.subviews.first?.superview?.removeFromSuperview()
        } else {
            UIView.animateWithDuration(0.25, delay: 0.0, options: ([.BeginFromCurrentState, .CurveEaseInOut]), animations: {() -> Void in
                self.blackImageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                self.blackImageView.subviews.first?.frame = self.view.frame
                }, completion: { _ in })
        }
    }*/
    
    
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
}
