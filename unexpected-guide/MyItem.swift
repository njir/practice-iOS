//
//  MyItem.swift
//  BeSoul
//
//  Created by 진형탁 on 2017. 1. 24..
//  Copyright © 2017년 FailNicely. All rights reserved.
//

import Foundation

class MyItem {
    let name:String!
    let detail: String!
    
    init(name: String, detail: String) {
        self.name = name
        self.detail = detail
    }
    
    func contains(_ text: String, substring: String,
                         ignoreCase: Bool = true,
                         ignoreDiacritic: Bool = true) -> Bool {
        
        var options = NSString.CompareOptions()
        
        if ignoreCase { _ = options.insert(NSString.CompareOptions.caseInsensitive) }
        if ignoreDiacritic { _ = options.insert(NSString.CompareOptions.diacriticInsensitive) }
        
        return text.range(of: substring, options: options) != nil
    }
}
