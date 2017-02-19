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
    
    
    let baseUrl: String = "http://localhost:3000/api/art?keyword="
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(ArtsTableViewController.updateSearchResults), name: NSNotification.Name(rawValue: "searchResultsUpdated"), object: nil)
        
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
        
        ImageLoader.sharedLoader.imageForUrl(urlString: item.ThumbImage.url, completionHandler:{(image: UIImage?, url: String) in
            cell.artImage.image = image
        })
        cell.artTitle.text = item.koreanName
        cell.artDescription.text = item.description
        
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
        //performSegue(withIdentifier: "toPinterestVC", sender: tableView.cellForRow(at: indexPath))
        performSegue(withIdentifier: "toDocentVC", sender: tableView.cellForRow(at: indexPath))
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
        if (segue.identifier == "toPinterestVC") {
            let detailVC = segue.destination as! PhotoStreamViewController
            let selectedItem = sender as! ArtResultTableViewCell
            
            detailVC.title = selectedItem.artTitle.text
            detailVC.selectedName = selectedItem.artDescription.text!
        }
        */
        if (segue.identifier == "toDocentVC") {
            let docentVC = segue.destination as! DocentCollectionViewController
            let selectedItem = sender as! ArtsTableViewCell
            
            docentVC.docentDescription = selectedItem.artDescription.text // test
        }
    }
    
     func setupSearchBar() {
         // Setup the Search Controller
        searchController.searchBar.placeholder = "작품명 또는 작가명 검색"
        searchController.searchBar.delegate = self
        searchController.searchBar.text = searchWord
        searchController.searchBar.autocapitalizationType = .none
       // searchController.searchBar.barTintColor = mainColor
        searchController.searchBar.tintColor = backgroundColor
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateSearchResults() {
        searchResults = requestManager.searchResults
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
}
