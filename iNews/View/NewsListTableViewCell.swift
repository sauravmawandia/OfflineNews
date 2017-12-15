//
//  NewsListTableViewCell.swift
//  iNews
//
//  Created by Ashish Bansal on 12/11/17.
//  Copyright © 2017 iNews. All rights reserved.
//

import UIKit

class NewsListTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImage.contentMode = .scaleAspectFill
    }
}
