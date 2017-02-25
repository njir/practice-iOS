//
//  RequestManager.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 15..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class RequestManager {
    var searchResults = [ArtData]()
    var pageNumber = 1
    var pageString: String {
        if pageNumber == 1 {
            return ""
        } else {
            return "page=\(pageNumber)&"
        }
    }
    
    func searchArt(searchText: String) {
        let url: String = "http://localhost:3000/api/art?keyword=\(searchText)" // TODO: add pageNumber
        print(url)
        
        Alamofire.request(url).responseArray { (response: DataResponse<[ArtData]>) in
            let artDataArray = response.result.value
            if let artDataArray = artDataArray {
                self.searchResults += artDataArray
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchResultsUpdated"), object: nil)
            }
        }
    }
    
    func getNextPage(searchText: String) {
        pageNumber += 1
        searchArt(searchText: searchText)
    }
    
    func resetSearch() {
        searchResults.removeAll()
    }
}
