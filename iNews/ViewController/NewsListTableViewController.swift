//
//  NewsListTableViewController.swift
//  iNews
//
//  Created by Ashish Bansal on 12/11/17.
//  Copyright © 2017 iNews. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import FlowingMenu

import AWSAuthCore
import AWSAuthUI
import AWSAuthCore
import AWSCore

class NewsListTableViewController: UITableViewController {
    
    private var newsList: [NewsDetailMO] = []
    private var logoutButton: UIBarButtonItem!
    private var searchButton: UIBarButtonItem!
    
    let refresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        tableView.addSubview(refresh)
        refresh.addTarget(self, action: #selector(forceReload), for: .valueChanged)
        logoutButton = UIBarButtonItem.init(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logoutButtonTapped(sender:)))
        navigationItem.rightBarButtonItem = logoutButton
        
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped(sender:)))
        navigationItem.leftBarButtonItem = searchButton
        
        reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData) , name: NSNotification.Name(rawValue: "NewDataAvailable"), object: nil)
        
    }
    
    @objc func forceReload() {
        reloadData(forceFetch: true)
    }
    
    @objc func reloadData(forceFetch: Bool = false)  {
        DataManager.sharedInstance.newsList(forceFetch: forceFetch) { [weak self] (result) in
            SVProgressHUD.dismiss()
            if self?.refresh.isRefreshing ?? false { self?.refresh.endRefreshing() }
            switch result {
            case .success(let newsResult):
                self?.newsList = newsResult
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func searchButtonTapped(sender: Any) {
        let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchTableViewController") as! SearchTableViewController
        let navController = UINavigationController.init(rootViewController: searchVC)
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @objc func logoutButtonTapped(sender: Any) {
        let alert = UIAlertController(title: "Logout?", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            LoginManager.sharedInstance.logout(completion: { (success) in
                if success {
                    AWSAuthUIViewController
                        .presentViewController(with: self.navigationController!,
                                               configuration: nil,
                                               completionHandler: { [weak self] (provider: AWSSignInProvider, error: Error?) in
                                                if error != nil {
                                                    print("Error occurred: \(String(describing: error))")
                                                } else {
                                                    print("Signed In...")
                                                    self?.reloadData()
                                                }
                        })
                } else {
                    SVProgressHUD.showError(withStatus: "Logout failed at this time.")
                }
            })
        }
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsListCell", for: indexPath) as! NewsListTableViewCell
        let news = newsList[indexPath.row]
        cell.newsLabel.text = news.title
        cell.timeLabel.text = news.publishedAt
        cell.newsImage.sd_setImage(with: URL(string: news.imageURL!), placeholderImage: UIImage.init(named: "placeholder"))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = newsList[indexPath.row]
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        detailVC.news = news
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
