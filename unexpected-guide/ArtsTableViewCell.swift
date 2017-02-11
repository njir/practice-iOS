//
//  ArtsTableViewCell.swift
//  unexpected-guide
//
//  Created by 진형탁 on 2017. 2. 11..
//  Copyright © 2017년 fail-nicely. All rights reserved.
//

import UIKit

class ArtsTableViewCell: UITableViewCell {
    @IBOutlet weak var artImage: UIImageView!
    @IBOutlet weak var artDescription: UILabel!
    @IBOutlet weak var artTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
