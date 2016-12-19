//
//  ViewController.swift
//  iOSeries
//
//  Created by Pierre on 07/12/2016.
//  Copyright © 2016 Pierre Boudon. All rights reserved.
//

import UIKit
import ColorMatchTabs
import SearchTextField
import Alamofire
import SwiftyJSON

class ViewController: ColorMatchTabsViewController {
    
    var currentColor = UIColor.white
    
    let bounds = UIScreen.main.bounds
    let searchviewDefaultHeight: CGFloat = 75
    
    var searchView = UIView()
    var searchBackgroundView = UIView()
    var autocompleteView = UIView()
    var searchTextField = SearchTextField()
    
    var results = [SearchTextFieldItem]()
    var resultsInfo = [String: String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.titleLabel.text = "iOSeries"
        self.changeNavBarItemsColor(index: 0)
        
        self.dataSource = self
        self.reloadData()
        
        self.createSearchView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            self.searchView.frame.origin.y = 0
            self.searchBackgroundView.frame.origin.y = 0
            self.autocompleteView.frame.origin.y = self.searchviewDefaultHeight / 2
            
            self.searchTextField.becomeFirstResponder()
        }, completion: nil)
    }
    
}

extension ViewController: ColorMatchTabsViewControllerDataSource {
    
    func numberOfItems(inController controller: ColorMatchTabsViewController) -> Int {
        return TabItemsProvider.items.count
    }
    
    func tabsViewController(_ controller: ColorMatchTabsViewController, viewControllerAt index: Int) -> UIViewController {
        return TabItemsProvider.viewControllers[index]
    }
    
    func tabsViewController(_ controller: ColorMatchTabsViewController, titleAt index: Int) -> String {
        return TabItemsProvider.items[index].title
    }
    
    func tabsViewController(_ controller: ColorMatchTabsViewController, iconAt index: Int) -> UIImage {
        return TabItemsProvider.items[index].normalImage
    }
    
    func tabsViewController(_ controller: ColorMatchTabsViewController, hightlightedIconAt index: Int) -> UIImage {
        return TabItemsProvider.items[index].highlightedImage
    }
    
    func tabsViewController(_ controller: ColorMatchTabsViewController, tintColorAt index: Int) -> UIColor {
        return TabItemsProvider.items[index].tintColor
    }
}

extension ViewController {
}

extension ViewController {
    override func scrollMenu(_ scrollMenu: ScrollMenu, didSelectedItemAt index: Int) {
        self.changeNavBarItemsColor(index: index)
        
        super.scrollMenu(scrollMenu, didSelectedItemAt: index)
    }
}

extension ViewController {
    func changeNavBarItemsColor(index: Int) {
        if let rightItems = self.navigationItem.rightBarButtonItems {
            for item in rightItems {
                item.tintColor = TabItemsProvider.items[index].tintColor
            }
        }
        
        if let leftItems = self.navigationItem.leftBarButtonItems {
            for item in leftItems {
                item.tintColor = TabItemsProvider.items[index].tintColor
            }
        }
        
        self.currentColor = TabItemsProvider.items[index].tintColor
        self.searchView.backgroundColor = self.currentColor
    }
    
    func createSearchView() {
        // Create background view
        self.searchBackgroundView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.searchBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.searchBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.searchBackgroundTap)))
        
        
        // Create Searchview
        self.searchView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.searchviewDefaultHeight)
        self.searchView.backgroundColor = self.currentColor
        
        
        // Create view for autocomplete
        self.autocompleteView.frame = CGRect(x: 10, y: self.searchviewDefaultHeight / 2, width: self.bounds.width - 20, height: 425)
        
        
        // Create Textfield
        self.searchTextField.frame = CGRect(x: 0, y: 0, width: self.autocompleteView.frame.width, height: 20)
        self.searchTextField.backgroundColor = UIColor.white
        self.searchTextField.placeholder = "Tappez le nom de votre série"
        self.searchTextField.layer.cornerRadius = 10
        self.searchTextField.bounds.origin.y += 10
        self.searchTextField.returnKeyType = .go
        
        self.configureCustomSearchTextField()
        
        
        // Add to subview
        self.autocompleteView.addSubview(self.searchTextField)
        
        
        // Set hidden
        self.searchBackgroundView.frame.origin.y = -self.bounds.height
        self.searchView.frame.origin.y = -self.searchviewDefaultHeight
        self.autocompleteView.frame.origin.y = -self.autocompleteView.frame.height
        
        UIApplication.shared.keyWindow?.addSubview(self.searchBackgroundView)
        UIApplication.shared.keyWindow?.addSubview(self.searchView)
        UIApplication.shared.keyWindow?.addSubview(self.autocompleteView)
    }
    
    fileprivate func configureCustomSearchTextField() {
        // Set theme - Default: light
        self.searchTextField.theme = SearchTextFieldTheme.lightTheme()
        
        // Modify current theme properties
        self.searchTextField.theme.font = UIFont.systemFont(ofSize: 12)
        self.searchTextField.theme.bgColor = UIColor.white
        self.searchTextField.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        self.searchTextField.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        self.searchTextField.theme.cellHeight = 50
        self.searchTextField.delegate = self
        
        // Max number of results - Default: No limit
        self.searchTextField.maxNumberOfResults = 5
        
        // Max results list height - Default: No limit
        self.searchTextField.maxResultsListHeight = 200
        
        // Customize highlight attributes - Default: Bold
        self.searchTextField.highlightAttributes = [NSBackgroundColorAttributeName: UIColor.yellow, NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12)]
        
        // Handle item selection - Default: title set to the text field
        self.searchTextField.itemSelectionHandler = {item in
            self.searchTextField.text = item.title
        }
        
        // Update data source when the user stops typing
        self.searchTextField.userStoppedTypingHandler = {
            if let criteria = self.searchTextField.text {
                if criteria.characters.count > 3 && self.results.count < 1 {
                    
                    // Show loading indicator
                    self.searchTextField.showLoadingIndicator()
                    
                    self.filterAcronymInBackground(criteria) { results in
                        // Set new items to filter
                        self.searchTextField.filterItems(results)
                        
                        // Stop loading indicator
                        self.searchTextField.stopLoadingIndicator()
                    }
                }
            }
        }
    }
    
    fileprivate func filterAcronymInBackground(_ criteria: String, callback: @escaping ((_ results: [SearchTextFieldItem]) -> Void)) {
        
        Alamofire.request("\(URLProvider.searchURL)\(criteria)", headers: APIInfoProvider.headers).responseJSON { response in
            if response.response?.statusCode == 200 {
                let json = JSON(response.result.value!)
                
                for show in json["shows"] {
                    
                    let image: UIImage
                    
                    if let url = URL(string: show.1["images"]["poster"].stringValue), let data = NSData(contentsOf: url) {
                        image = UIImage(data: data as Data)!
                    } else {
                        image = UIImage(named: "sttwhite")!
                    }
                    
                    self.results.append(SearchTextFieldItem(title: show.1["title"].stringValue, subtitle: "Date de création : \(show.1["creation"])", image: image))
                    self.resultsInfo["\(show.1["title"])"] = "\(show.1["id"])"
                }
                
                DispatchQueue.main.async {
                    callback(self.results)
                }
            }
        }
    }
    
    func searchBackgroundTap() {
        if (self.searchTextField.text?.characters.count)! < 1 {
            self.searchTextField.resignFirstResponder()
            UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
                self.searchView.frame.origin.y = -self.searchviewDefaultHeight
                self.searchBackgroundView.frame.origin.y = -self.bounds.height
                self.autocompleteView.frame.origin.y = -self.autocompleteView.frame.height
            }, completion: nil)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) && (textField.text?.characters.count)! < 4 {
            self.results = []
            self.resultsInfo = [String: String]()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            if text.characters.count > 0 {
                if let id = self.resultsInfo["\(text)"] {
                    let vc = DetailsParallaxViewController(nibName: "DetailsParallaxViewController", bundle: Bundle.main)
                    vc.id = Int(id)!
                    vc.currentColor = self.currentColor
                    
                    // Hide SearchView
                    self.searchTextField.resignFirstResponder()
                    self.searchTextField.text = ""
                    UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
                        self.searchView.frame.origin.y = -self.searchviewDefaultHeight
                        self.searchBackgroundView.frame.origin.y = -self.bounds.height
                        self.autocompleteView.frame.origin.y = -self.autocompleteView.frame.height
                    }, completion: nil)
                    
                    // Present new view
                    self.present(vc, animated: true, completion: nil)
                    
                    return true
                }
            } else {
                self.searchBackgroundTap()
                return true
            }
        }
        
        return false
    }
}
