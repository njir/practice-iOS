//
//  ThumbImageData.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 14..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import Foundation
import ObjectMapper

class ThumbImage: Mappable {
    var imageId: Int!
    var url: String!
    var updatedAt: String!
    var createdAt: String!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        imageId <- map["imageId"]
        url <- map["url"]
        updatedAt <- map["updatedAt"]
        createdAt <- map["createdAt"]
    }
}
