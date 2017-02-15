//
//  ArtistData.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 14..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import Foundation
import ObjectMapper

class Artist: Mappable {
    var artistId: Int!
    var imageId: Int!
    var countryId: String!
    var koreanName: String!
    var englishName: String!
    var birthday: String!
    var deathday: String!
    var updatedAt: String!
    var createdAt: String!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        artistId <- map["artistId"]
        imageId <- map["imageId"]
        countryId <- map["countryId"]
        koreanName <- map["koreanName"]
        englishName <- map["englishName"]
        birthday <- map["birthday"]
        deathday <- map["deathday"]
        updatedAt <- map["updatedAt"]
        createdAt <- map["createdAt"]
    }
}
