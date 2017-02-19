//
//  PostViewController.swift
//  StaggeredGridLayout
//
//  Created by 秋本大介 on 2016/06/08.
//  Copyright © 2016年 秋本大介. All rights reserved.
//

import UIKit

class PostViewController: UICollectionViewController, StaggeredGridLayoutDelegate {
    var test: String?
    var posts : Array<Post> = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(test ?? "not loaded")
        self.posts = Post.allPosts()
        
        self.collectionView!.contentInset = UIEdgeInsetsMake(12.0, 5.0, 5.0, 5.0)
        
        let layout : StaggeredGridLayout = self.collectionView!.collectionViewLayout as! StaggeredGridLayout;
        layout.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : PostCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath) as! PostCell
        cell.setModel(self.posts[indexPath.item])
        
        return cell
    }
    
    // MARK: - StaggeredGridLayoutDelegate
    
    func heightForProfileViewAtIndexPath(_ collectionView : UICollectionView,
                                   indexPath : IndexPath,
                                   width : CGFloat
        ) -> CGFloat {
        let post : Post = self.posts[indexPath.item]
        if let _ = post.image {
            return PostCell.profileViewHeightWithImage(post.image!, cellWidth: width)
        } else {
            return 0.0
        }
    }
    
    func heightForBodyAtIndexPath(_ collectionView : UICollectionView,
        indexPath : IndexPath,
        width : CGFloat
        ) -> CGFloat {
            return PostCell.bodyHeightWithText(self.posts[indexPath.item].text!, cellWidth:width)
    }
}

