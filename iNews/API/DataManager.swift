//
//  DataManager.swift
//  iNews
//
//  Created by Ashish Bansal on 12/13/17.
//  Copyright © 2017 iNews. All rights reserved.
//

import Foundation
import Result

class DataManager {
    
    private lazy var moc: NSManagedObjectContext = {
        let ret = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ret;
    }()
    
    static let sharedInstance = DataManager()
    
    func newsList(forceFetch: Bool = false, completion: @escaping (Result<[NewsDetailMO], APIError>) -> Void) {
        if !forceFetch, let cached = retreiveCached() {
            if cached.count < 1 {
                downloadAndSave(completion: completion)
            } else {
                completion(Result.success(cached))
            }
        } else {
            downloadAndSave(completion: completion)
        }
    }
    
    func downloadAndSave(completion: @escaping (Result<[NewsDetailMO], APIError>) -> Void) {
        retreiveNewsListFromAPI(completion: { (result) in
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(let newsList):
                if let previous = self.retreiveCached() {
                    previous.forEach { self.moc.delete($0) }
                }
                newsList.forEach({ (n) in
                    self.addNewsToDB(news: n)
                })
                if let cached = self.retreiveCached() {
                    completion(Result.success(cached))
                } else {
                    completion(Result.failure(APIError.apiError))
                }
            }
        })
    }
    
    private func addNewsToDB(news: NewsDetail) {
        let newDetailMO = NSEntityDescription.insertNewObject(forEntityName: "NewsDetailMO", into: moc) as! NewsDetailMO
        newDetailMO.author = news.author
        newDetailMO.id = news.id
        newDetailMO.imageURL = news.imageURL
        newDetailMO.title = news.title
        newDetailMO.publishedAt = news.publishedAt
        newDetailMO.text = news.text
        try! moc.save()
    }
    
    private func retreiveCached() -> [NewsDetailMO]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsDetailMO")
        do {
            let results = try moc.fetch(fetchRequest) as! [NewsDetailMO]
            return results
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func retreiveNewsListFromAPI(completion: @escaping (Result<[NewsDetail], APIError>) -> Void) {
        APIWrapper.sharedInstance.getNewsList(completion: { (result) in
            switch result {
            case .success(let newsResult):
                var retArr: [NewsDetail] = []
                let dispatchGroup = DispatchGroup()
                for n in newsResult.news {
                    dispatchGroup.enter()
                    self.retreiveDetailsForNews(id: n.id, completion: { (detailResult) in
                        switch detailResult {
                        case .failure:
                            break
                        case .success(let news):
                            retArr.append(news)
                        }
                        dispatchGroup.leave()
                    })
                }
                dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                    completion(Result.success(retArr))
                })
            case .failure(let error):
                completion(Result.failure(error))
            }
        })
    }
    
    private func retreiveDetailsForNews(id: String, completion: @escaping (Result<NewsDetail, APIError>) -> Void) {
        APIWrapper.sharedInstance.getNewsByID(newsID: id, completion: completion)
    }
}
