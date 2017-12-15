//
//  News.swift
//  iNews
//
//  Created by Ashish Bansal on 12/10/17.
//  Copyright © 2017 iNews. All rights reserved.
//

import Foundation
import ObjectMapper

struct NewsResult: ImmutableMappable {
    let news: [News]
    
    init(map: Map) throws {
        news = try map.value("news")
    }
    
    func mapping(map: Map) {
        news >>> map["news"]
    }
}

struct News: ImmutableMappable {
    let description: String
    let id: String
    let imageURL: String
    let publishedAt: String
    let title: String
    
    init(map: Map) throws {
        description = try map.value("description")
        id = try map.value("id")
        imageURL = try map.value("imageURL")
        publishedAt = try map.value("publishedAt")
        title = try map.value("title")
    }
    
    func mapping(map: Map) {
        description >>> map["description"]
        id >>>  map["id"]
        imageURL >>> map["imageURL"]
        publishedAt >>> map["publishedAt"]
        title >>> map["title"]
    }
}

struct NewsDetail: ImmutableMappable {
    
    let description: String
    let id: String
    let imageURL: String
    let publishedAt: String
    let title: String
    let text: String
    let author: String
    
    init(map: Map) throws {
        description = try map.value("description")
        id = try map.value("id")
        imageURL = try map.value("imageURL")
        publishedAt = try map.value("publishedAt")
        title = try map.value("title")
        text = try map.value("text")
        author = (try? map.value("author")) ?? ""
    }
    
    func mapping(map: Map) {
        description >>> map["description"]
        id >>>  map["id"]
        imageURL >>> map["imageURL"]
        publishedAt >>> map["publishedAt"]
        title >>> map["title"]
        text >>> map["text"]
        author >>> map["author"]
    }
}

