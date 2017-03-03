//
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 18..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import UIKit
import AVFoundation

class PostCell: UICollectionViewCell {
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileViewHeightLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var heart: UILabel!
    
    var voiceUrl: String?
    
    func setModel(_ voice : VoiceData) {
        let docentId: Int = voice.docentId!
        let requestString = "https://avatars.githubusercontent.com/u/7614353?v=\(docentId)" // to be modifted with docent image
        ImageLoader.sharedLoader.imageForUrl(urlString: requestString, completionHandler:{(image: UIImage?, url: String) in
            self.imageView.image = image
            self.imageView.setRounded()
        })
        
        self.name.text = voice.docent?.name
        if let star = voice.avgStarPoint {
            // to attach star image to text
            let text = NSMutableAttributedString(string: "")
            let starText = NSMutableAttributedString(string: " \(star)")
            let image = UIImage(named: "heartBorderIcon")!
            let imageAttachment = ImageAttachment(image, verticalOffset: self.star.font.descender)
            text.append(NSAttributedString(attachment: imageAttachment))
            text.append(starText)
            self.star.attributedText = text
        }
        
        if let heart = voice.totLikeCount {
            // to attach heart image to text
            let text = NSMutableAttributedString(string: "")
            let heartText = NSMutableAttributedString(string: " \(heart)")
            let image = UIImage(named: "starBorderIcon")!
            let imageAttachment = ImageAttachment(image, verticalOffset: self.star.font.descender)
            text.append(NSAttributedString(attachment: imageAttachment))
            text.append(heartText)
            self.heart.attributedText = text
        }
        
        self.commentLabel.text = voice.description
        self.voiceUrl = voice.url
    }

    // MARK: - Public
    class func profileViewHeightWithImage(cellWidth : CGFloat) -> CGFloat {
        return 120
    }

    class func bodyHeightWithText(_ text : String,  cellWidth : CGFloat) -> CGFloat {
        let padding: CGFloat = 15.0
        let width: CGFloat = (cellWidth - padding * 2)
        let font = UIFont.systemFont(ofSize: 9)
        let attributes = [NSFontAttributeName:font]
        let rect: CGRect = (text as NSString).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options : NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: attributes,
            context: nil)
        
        return padding + ceil(rect.size.height) + padding
    }
}
