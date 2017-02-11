//
//  DataManager.swift
//  BeSoul
//
//  Created by 진형탁 on 2017. 1. 24..
//  Copyright © 2017년 FailNicely. All rights reserved.
//

import Foundation

class DataManager {
    func requestData(offset:Int, size:Int, listener:@escaping ([MyItem]) -> ()) {
        DispatchQueue.global(qos: .background).async {
            //Sleep the Process
            if offset != 0 {
                sleep(1)
            }
            
            //generate items
            var arr = [MyItem]()
            for i in offset...(offset + size) {
                let item = MyItem(name: "Item " + String(i),
                                  detail: self.generateRandomString(length: self.getRandomNumberBetween(From: 15, To: 40)))
                arr.append(item)
            }
            
            //call listener in main thread
            DispatchQueue.main.async {
                listener(arr)
            }
        }
    }
    
     // MARK: Utility
    func getRandomNumberBetween (From: Int , To: Int) -> Int {
        return From + Int(arc4random_uniform(UInt32(To - From + 1)))
    }
    
    func generateRandomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let len = UInt32(letters.length)
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
