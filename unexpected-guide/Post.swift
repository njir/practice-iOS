//
//  Post.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 18..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import UIKit

open class Post: NSObject {
    open var text: String?
    open var image: UIImage?

    func initWithDictionary(_ dictionary : Dictionary<String, String>) -> Post {
        self.text = dictionary["text"]
        if let _ = dictionary["imageName"] {
            let imageName : String = dictionary["imageName"]!
            self.image = UIImage(named: imageName)
        }
        return self
    }

    class func allPosts() -> Array<Post> {
        var posts : Array<Post> = []

        do {
            let filePath : String = Bundle.main.path(forResource: "Posts", ofType: "json")!
            let fileData : Data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: NSData.ReadingOptions.alwaysMapped)
            let jsonPosts : NSArray = try JSONSerialization.jsonObject(with: fileData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            for object in jsonPosts as! Array<NSDictionary> {
                let jsonDictionary : Dictionary<String, String> = object as! Dictionary<String, String>
                let post : Post = Post().initWithDictionary(jsonDictionary)
                posts.append(post)
            }
        } catch _ {
            print("Could not load post data")
            return posts
        }


        return posts
    }
}
