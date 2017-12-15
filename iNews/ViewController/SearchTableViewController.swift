//
//  SearchTableViewController.swift
//  iNews
//
//  Created by Ashish Bansal on 12/14/17.
//  Copyright © 2017 iNews. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class SearchTableViewController: UITableViewController {
    
    var news: [News] = []
    
    private lazy var moc: NSManagedObjectContext = {
        let ret = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ret;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Search News"
        self.searchDisplayController?.searchBar.showsCancelButton = true
        self.searchDisplayController?.searchResultsTableView.delegate = nil
    }
    
    func searchNews(string: String) {
        SVProgressHUD.show()
        APIWrapper.sharedInstance.search(string: string) { (result) in
            switch result {
            case .failure:
                SVProgressHUD.showError(withStatus: "Failed. Please retry!")
            case .success(let newsList):
                SVProgressHUD.dismiss()
                self.news = newsList.news
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tableView == self.tableView else {
            tableView.register(NewsListTableViewCell.self, forCellReuseIdentifier: "dummy")
            return tableView.dequeueReusableCell(withIdentifier: "dummy", for: indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! NewsListTableViewCell
        let n = news[indexPath.row]
        cell.newsLabel.text = n.title
        cell.timeLabel.text = n.publishedAt
        cell.newsImage.sd_setImage(with: URL(string: n.imageURL), placeholderImage: UIImage.init(named: "placeholder"))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let n = news[indexPath.row]
        
        APIWrapper.sharedInstance.getNewsByID(newsID: n.id) { (result) in
            switch result {
            case .failure:
                SVProgressHUD.showError(withStatus: "Failed!")
            case .success(let news):
                DispatchQueue.main.async {
                    let newDetailMO = NSEntityDescription.insertNewObject(forEntityName: "NewsDetailMO", into: self.moc) as! NewsDetailMO
                    newDetailMO.author = news.author
                    newDetailMO.id = news.id
                    newDetailMO.imageURL = news.imageURL
                    newDetailMO.title = news.title
                    newDetailMO.publishedAt = news.publishedAt
                    newDetailMO.text = news.text
                    let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
                    detailVC.news = newDetailMO
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
        }
    }
}

extension SearchTableViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text != "" {
            searchDisplayController?.setActive(false, animated: true)
            searchNews(string: text)
        }
    }
}

