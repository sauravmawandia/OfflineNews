//
//  NewsDetailViewController.swift
//  iNews
//
//  Created by Ashish Bansal on 12/13/17.
//  Copyright © 2017 iNews. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    var news: NewsDetailMO!

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var newsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        coverImageView.sd_setImage(with: URL(string: news.imageURL!), placeholderImage: UIImage.init(named: "placeholder"))
        newsLabel.text = news.text
        headingLabel.text = news.title
        dateLabel.text = news.publishedAt
    }
}
