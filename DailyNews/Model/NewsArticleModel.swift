//
//  NewsArticleModel.swift
//  DailyNews
//
//  Created by BJIT on 12/1/23.
//

import Foundation
var category1 = Category.category

protocol ArticleModelProtocol {
    func articlesRetrieved(_ articles: [NewsArticle])
}

class NewsArticleModel {
    
    var delegate: ArticleModelProtocol?
    
    func getArticles(catg: String) -> Void {
        
        let stringURL = "https://newsapi.org/v2/top-headlines?country=us&category=\(catg)&apiKey=e923cfa02e8949ac9341a172e7874d35"
        let stringURL1 = "https://newsapi.org/v2/top-headlines?country=us&apiKey=e923cfa02e8949ac9341a172e7874d35"
       
        // Create URL object
        let url =  URL(string: stringURL)
        
        // Check that URL was created
        guard url != nil else {
            print("Could not create URL")
            return
        }
        
        print("url:", url!)
        
        // Get the URL session
        let session = URLSession.shared
        
        // Create a data task
        let dataTask = session.dataTask(with: url!) { data, response, error in
            
            if error == nil && data != nil {
                
                // Parse the returned JSON into article instances
                
                let decoder = JSONDecoder()
                do {
                    let articleService = try decoder.decode(NewsArticleServices.self, from: data!)
                    debugPrint("decode")
                    if let articles = articleService.articles {
                        // Pass it back to the viewController in a main thread
                        dump(articles)
                        for x in articles{
                            
                            
                            CDManager.shared.addRecords(title: x.title,
                                                    
                                                        author: x.author ?? "",
                                                        url: x.url,
                                                        urlToImage: x.urlToImage ?? "",
                                                        publishedAt: x.publishedAt,
                                                        desc: x.description,
                                                        category: catg, content: x.content
                            )
                            
                        }
                        //                        print("fetched articles:", articles)
                        DispatchQueue.main.async {
                            //print(articles)
                            self.delegate?.articlesRetrieved(articles)
                        }
                    }
                    
                } catch {
                    print("Could not decode the json data")
                }
            }
            else {
                print("Error creating dataTask")
            }
        }.resume()
        
        // Start the data task
        //        dataTask
        print("last print")
    }
}
