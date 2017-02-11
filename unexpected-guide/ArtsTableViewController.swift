//
//  ArtsTableViewController.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 11..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import UIKit

class ArtsTableViewController: UITableViewController {
    // MARK: Properties
    
    let PageSize: Int = 20
    let searchController = UISearchController(searchResultsController: nil)
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var searchWord: String?
    var items = [MyItem]()
    var filtered = [MyItem]()
    var isDataLoading: Bool = false
    var isViewLoading = false;
    
    // MARK: Outlets
    @IBOutlet weak var MyFooterView: UIView! // to show loading indicator
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup data
        loadSegment(offset: 0, size: 20)
        filtered = items
        
        // Show indicatior
        isViewLoading = true;
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        // Setup the Search Controller
        searchController.searchBar.placeholder = "작품명 또는 작가명"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.text = searchWord
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.stopAnimating()
        isViewLoading = false;
        searchController.isActive = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        
        if(!isViewLoading) { // Show spin indicatior when isViewLoading is true
            if filtered.count != 0 || searchController.searchBar.text == ""  {
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
        if searchController.searchBar.text != "" {
            return filtered.count
        }
        else {
            return items.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        // custom row height
        return 105;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArtsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ArtsTableViewCell
        let item: MyItem
        if searchController.searchBar.text != "" {
            item = filtered[indexPath.row]
        }
        else {
            item = items[indexPath.row]
        }
        
        let imagename = getRandomNumberBetween(From: 1, To: 10).description + ".png"
        cell.artImage.image = UIImage(named: imagename)! as UIImage
        cell.artTitle.text = item.name as String
        cell.artDescription.text = item.detail as String
        
        return cell
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
        filtered.removeAll()
        for item in items {
            if(item.contains(item.name, substring: searchText) || item.contains(item.detail, substring: searchText)) {
                filtered.append(item)
            }
        }
        tableView.reloadData()
    }
    
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
     */
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
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        //performSegue(withIdentifier: "toPinterestVC", sender: tableView.cellForRow(at: indexPath))
        //performSegue(withIdentifier: "toDocentVC", sender: tableView.cellForRow(at: indexPath))
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
        if (segue.identifier == "toDocentVC") {
            let docentVC = segue.destination as! DocentTableViewController
            let selectedItem = sender as! ArtResultTableViewCell
            
            docentVC.selectedTitle = selectedItem.artTitle.text
            docentVC.selectedDescription = selectedItem.artDescription.text!
            docentVC.selectedImage = selectedItem.artImage.image
        }
 */
    }
    
    // MARK: Utility
    func getRandomNumberBetween (From: Int , To: Int) -> Int {
        return From + Int(arc4random_uniform(UInt32(To - From + 1)))
    }
}

extension ArtsTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension ArtsTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
