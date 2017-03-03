//
//  ArtsTableViewController.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 11..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON

class ArtsTableViewController: UITableViewController {
    // MARK: Properties
    
    let PageSize: Int = 20
    let searchController = UISearchController(searchResultsController: nil)
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var searchWord: String?
    var isDataLoading: Bool = false
    var isViewLoading: Bool = true
    
    let requestManager = RequestManager()
    var searchResults = [ArtData]() {
        didSet {
            tableView.reloadData()
        }
    }
    var validatedText: String {
        return searchController.searchBar.text!.replacingOccurrences(of: " ", with: "").lowercased()
    }

    // MARK: Outlets
    @IBOutlet weak var MyFooterView: UIView! // to show loading indicator
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ArtsTableViewController.updateSearchResults), name: NSNotification.Name(rawValue: "artResultsUpdated"), object: nil)
        
        self.view.backgroundColor = backgroundColor
        
        // Get data with search word
        requestManager.searchArt(searchText: self.searchWord!)
        self.MyFooterView.isHidden = true
        
        // Show indicatior
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        // Setup searchController and searchBar
        setupSearchBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.stopAnimating()
        searchController.isActive = true;
        isViewLoading = false;
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Table View data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        
        if isViewLoading == false  { // Show spin indicatior when isViewLoading is true
            if searchResults.count != 0 || searchController.searchBar.text == ""  {
                tableView.separatorStyle = .singleLine
                numOfSections            = 1
                tableView.backgroundView = nil
            }
            else {
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = searchController.searchBar.text! + " 검색 결과가 없습니다.\n다른 키워드로 검색해주세요."
                noDataLabel.textColor     = UIColor.darkGray
                noDataLabel.textAlignment = .center
                noDataLabel.numberOfLines = -1; //to multi line
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
            }
        }
        
        return numOfSections
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = backgroundColor
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        // custom row height
        return 105;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArtsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ArtsTableViewCell
        let item: ArtData
        item = searchResults[indexPath.row]
        
        ImageLoader.sharedLoader.imageForUrl(urlString: (item.thumbImage?.url!)!, completionHandler:{(image: UIImage?, url: String) in
            cell.artImage.image = image
        })
        cell.artTitle.text = item.koreanName
        cell.artEnglishTitle.text = item.englishName
        cell.artist.text = item.artist?.koreanName
        cell.artistEnglish.text = item.artist?.englishName
        
        cell.artId = item.artId
        
       
        
        return cell
    }
    
    
    // ** To be deleted below code after adding page number
    /*
     override func scrollViewDidScroll(_ scrollView: UIScrollView) {
     let offset = scrollView.contentOffset.y
     print("offset ", offset)
     let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
     print("maxoffset ", maxOffset)
     if (maxOffset - offset) <= 100 {
     loadSegment(offset: items.count, size: PageSize-1)
     filterContentForSearchText(searchController.searchBar.text!)
     }
     }
    
    // MARK: Data Manager
    func loadSegment(offset:Int, size:Int) {
        if (!self.isDataLoading) {
            self.isDataLoading = true
            self.MyFooterView.isHidden = (offset==0) ? true : false
            
            let manager = DataManager()
            manager.requestData(offset: offset, size: size, listener: {(items: [MyItem])-> () in
                // Add Rows at indexpath
                for item in items {
                    //let row = self.items.count
                    //let indexPath = NSIndexPath(row: row, section: 0)
                    self.items.append(item)
                    //self.tableView?.insertRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
                }
                self.isDataLoading = false
                self.MyFooterView.isHidden = true
            })
        }
    }
     */
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "toVoiceCollectionVC", sender: tableView.cellForRow(at: indexPath))
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toVoiceCollectionVC") {
            let voiceCollectionVC = segue.destination as! PostViewController
            let selectedItem = sender as! ArtsTableViewCell
            
            voiceCollectionVC.artId = selectedItem.artId
            // to add image list to play view controller
            var filtered = searchResults.filter({$0.artId == selectedItem.artId})
            if let thumbImage = filtered[0].thumbImage {
                ImageLoader.sharedLoader.imageForUrl(urlString: (thumbImage.url!), completionHandler:{(image: UIImage?, url: String) in
                    voiceCollectionVC.imageList.append(image)
                })
            }
            if let images = filtered[0].images {
                for image in images {
                    ImageLoader.sharedLoader.imageForUrl(urlString: image.url!, completionHandler:{(image: UIImage?, url: String) in
                    voiceCollectionVC.imageList.append(image)
                    })
                }
            }
        }
    }
    
    func setupSearchBar() {
         // Setup the Search Controller
        searchController.searchBar.placeholder = "작품명 또는 작가명 검색"
        searchController.searchBar.delegate = self
        searchController.searchBar.text = searchWord
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.barTintColor = backgroundColor
        searchController.searchBar.tintColor = fontColor
        searchController.searchBar.backgroundColor = textfieldColor
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.layer.borderWidth = 1
        searchController.searchBar.layer.borderColor = backgroundColor.cgColor
        searchController.searchBar.layer.backgroundColor = textfieldColor.cgColor
        searchController.searchBar.layer.cornerRadius = 5.0
        searchController.searchBar.layer.borderWidth = 2.0
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField,
            let iconView = textField.leftView as? UIImageView {
            
            textField.font = UIFont(name: "Iropke Batang", size: 13)
            iconView.image = iconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            iconView.tintColor = fontColor
        }
        
        // set background color
        for view in searchController.searchBar.subviews {
            for subView in view.subviews {
                if subView.isKind(of: UITextField.self) {
                    subView.backgroundColor = textfieldColor
                }
            }
        }
        
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateSearchResults() {
        searchResults = requestManager.artResults
        isDataLoading = false
    }
}

extension ArtsTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestManager.resetSearch()
        updateSearchResults()
        requestManager.searchArt(searchText: validatedText)
    }
    
    // set UI
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.layer.borderColor = mainColor.cgColor
            textField.layer.borderWidth = 1.0
            textField.layer.cornerRadius = 5.0
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.layer.borderColor = textfieldColor.cgColor
            textField.layer.borderWidth = 1.0
        }
    }
}
