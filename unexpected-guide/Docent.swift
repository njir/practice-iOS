//
//  Docent.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 25..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import Foundation
import ObjectMapper

class Docent: Mappable {
    var voiceId: Int?
    var name: String?
    var imageId: Int?
    var updatedAt: String?
    var createdAt: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        voiceId <- map["voiceId"]
        name <- map["name"]
        imageId <- map["imageId"]
        updatedAt <- map["updatedAt"]
        createdAt <- map["createdAt"]
    }
}



