//
//  Extensions.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 28..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import UIKit
import Foundation

extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = textfieldColor.cgColor
        self.layer.masksToBounds = true
    }
}

class ImageAttachment: NSTextAttachment {
    var verticalOffset: CGFloat = 0.0
    
    // To vertically center the image, pass in the font descender as the vertical offset.
    // We cannot get this info from the text container since it is sometimes nil when `attachmentBoundsForTextContainer`
    // is called.
    
    convenience init(_ image: UIImage, verticalOffset: CGFloat = 0.0) {
        self.init()
        self.image = image
        self.verticalOffset = verticalOffset
    }
    
    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        let height = lineFrag.size.height
        var scale: CGFloat = 1.0;
        let imageSize = image!.size
        
        if (height < imageSize.height) {
            scale = height / imageSize.height
        }
        
        return CGRect(x: 0, y: verticalOffset, width: imageSize.width * scale, height: imageSize.height * scale)
    }
    
}
