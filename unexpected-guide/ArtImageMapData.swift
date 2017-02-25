//
//  ArtImageMapData.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 14..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import Foundation
import ObjectMapper

class ArtImageMap: Mappable {
    var artImageMapId: Int?
    var artId: Int?
    var imageId: Int?
    var updatedAt: String?
    var createdAt: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        artImageMapId <- map["artImageMapId"]
        artId <- map["artId"]
        imageId <- map["imageId"]
        updatedAt <- map["updatedAt"]
        createdAt <- map["createdAt"]
    }
}
