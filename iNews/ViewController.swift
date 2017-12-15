//
//  ViewController.swift
//  iNews
//
//  Created by Ashish Bansal on 12/10/17.
//  Copyright © 2017 iNews. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSAuthCore
import AWSCore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        if !LoginManager.sharedInstance.isLoggedIn {
            AWSAuthUIViewController
                .presentViewController(with: self.navigationController!,
                                       configuration: nil,
                                       completionHandler: { [weak self] (provider: AWSSignInProvider, error: Error?) in
                                        if error != nil {
                                            print("Error occurred: \(String(describing: error))")
                                        } else {
                                            print("Signed In...")
                                            self?.presentNewsList()
                                        }
                })
        } else {
            presentNewsList()
        }
    }
    
    func presentNewsList() {
        let newsListVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsListTableViewController")
        self.navigationController?.setViewControllers([newsListVC], animated: true)
    }
}

