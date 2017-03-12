//
//  ArtData.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 12..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import Foundation
import ObjectMapper

class ArtData: Mappable {
    var artId: Int?
    var artistId: Int?
    var thumbImageId: Int?
    var koreanName: String?
    var englishName: String?
    var description: String?
    var updatedAt: String?
    var createdAt: String?
    var artist: Artist?
    var thumbImage: ThumbImage?
    var images: [Image]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        artId <- map["artId"]
        artistId <- map["artistId"]
        thumbImageId <- map["thumbImageId"]
        koreanName <- map["koreanName"]
        englishName <- map["englishName"]
        description <- map["description"]
        updatedAt <- map["updatedAt"]
        createdAt <- map["createdAt"]
        artist <- map["artist"]
        thumbImage <- map["thumbImage"]
        images <- map["images"]
    }
}



