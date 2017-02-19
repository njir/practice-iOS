//
//  PostCell.swift
//  StaggeredGridLayout
//
//  Created by 秋本大介 on 2016/06/08.
//  Copyright © 2016年 秋本大介. All rights reserved.
//

import UIKit
import AVFoundation

class PostCell: UICollectionViewCell {
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileViewHeightLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    var post : Post = Post()

    // MARK: - Accessor

    func setModel(_ post : Post) {
        self.imageView.image = post.image
        self.commentLabel.text = post.text
    }

    // MARK: - Public
    class func profileViewHeightWithImage(_ image : UIImage, cellWidth : CGFloat) -> CGFloat {
        let boundingRect : CGRect  =  CGRect(x: 0, y: 0, width: cellWidth, height: CGFloat.greatestFiniteMagnitude);
        let rect : CGRect = AVMakeRect(aspectRatio: image.size, insideRect: boundingRect);
        //image.size 통일해야함
        
        return rect.size.height;
    }

    class func bodyHeightWithText(_ text : String,  cellWidth : CGFloat) -> CGFloat {
        let padding : CGFloat = 4.0
        let width : CGFloat = (cellWidth - padding * 2)
        let font = UIFont.systemFont(ofSize: 8.5)
        let attributes = [NSFontAttributeName:font]
        let rect : CGRect = (text as NSString).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options : NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: attributes,
            context: nil)
        
        return padding + ceil(rect.size.height) + padding
    }
}
