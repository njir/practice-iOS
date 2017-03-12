//
//  VoiceData.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 25..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import Foundation
import ObjectMapper

class VoiceData: Mappable {
    var voiceId: Int?
    var url: String?
    var artId: Int?
    var docentId: Int?
    var avgStarPoint: Float?
    var totLikeCount: Int?
    var description: String?
    var enableStatus: String?
    var updatedAt: String?
    var createdAt: String?
    var docent: Docent?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        voiceId <- map["voiceId"]
        url <- map["url"]
        artId <- map["artId"]
        docentId <- map["docentId"]
        avgStarPoint <- map["avgStarPoint"]
        totLikeCount <- map["totLikeCount"]
        description <- map["description"]
        enableStatus <- map["enableStatus"]
        updatedAt <- map["updatedAt"]
        createdAt <- map["createdAt"]
        docent <- map["docent"]
    }
}



