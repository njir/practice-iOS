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
    var artResults = [ArtData]()
    var voiceResults = [VoiceData]()
    var pageNumber = 1
    var pageString: String {
        if pageNumber == 1 {
            return "page=1"
        } else {
            return "page=\(pageNumber)"
        }
    }
    
    func searchArt(searchText: String) {
        let url: String = "http://api-dev.failnicely.com:3000/api/art?keyword=\(searchText)&" + pageString // TODO: add pageNumber
        print(url)
        
        Alamofire.request(url).responseArray { (response: DataResponse<[ArtData]>) in
            let artDataArray = response.result.value
            if let artDataArray = artDataArray {
                self.artResults += artDataArray
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "artResultsUpdated"), object: nil)
            }
        }
    }
    
    func getNextPage(searchText: String) {
        pageNumber += 1
        searchArt(searchText: searchText)
    }
    
    func resetSearch() {
        artResults.removeAll()
    }
    
    
    // Search Voie
    func searchVoice(artId: Int) {
        let url: String = "http://api-dev.failnicely.com:3000/api/voice/art/\(artId)?" + pageString // TODO: add pageNumber
        print("voice:", url)
        
        Alamofire.request(url).responseArray { (response: DataResponse<[VoiceData]>) in
            let voiceDataArray = response.result.value
            if let voiceDataArray = voiceDataArray {
                self.voiceResults += voiceDataArray
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "voiceResultsUpdated"), object: nil)
            }
        }
    }
}
