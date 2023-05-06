//
//  NewsArticle.swift
//  DailyNews
//
//  Created by BJIT on 12/1/23.
//

import Foundation

struct NewsArticle: Decodable {
    
    var author: String?
    var title: String?
    var url: String?
    var description: String?
    var publishedAt: String?
    var urlToImage: String?
    var content: String?
    //var bookmark: Bool
    var category: String?
    var desc: String?
    
    
}
