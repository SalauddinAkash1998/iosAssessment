//
//  ArticleCell.swift
//  DailyNews
//
//  Created by BJIT on 13/1/23.
//

import UIKit

class NewsArticleCell: UITableViewCell {

    @IBOutlet weak var newsArticlePhoto: UIImageView!
    @IBOutlet weak var newsArticleLabel: UILabel!
    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    var newsArticleToDisplay : NewsArticle?
    func articleDisplay(_ article : NewsArticle){
        
        newsArticlePhoto.image = nil
        newsArticlePhoto.alpha = 0
        newsArticleLabel.text = nil
        newsArticleLabel.alpha = 0
        authorName.text = nil
        authorName.alpha = 0
        dateLabel.text = nil
        dateLabel.alpha = 1
        
        newsArticleToDisplay = article
        newsArticleLabel.text = newsArticleToDisplay!.title
        var auth = newsArticleToDisplay?.author ?? "NewsBreak"
           
        
        authorName.text = auth
        dateLabel.text = newsArticleToDisplay!.publishedAt
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.newsArticleLabel.alpha = 1
            self.authorName.alpha = 1
        }, completion: nil)
        
     
        if let urlString = article.urlToImage{
            if let imgData = CacheFile.retrieveData(urlString){
                newsArticlePhoto.image = UIImage(data: imgData)
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                    self.newsArticlePhoto.alpha = 1
                }, completion: nil)

                return

            }
            let url = URL(string: urlString)

            guard url != nil else{
                print("Could not load URL image", UIImage(systemName: "trash") as Any)
                return
            }
            let session = URLSession.shared
            let dataTasks = session.dataTask(with: url!){ data, response, error in

                guard data != nil && error == nil else {
                    print("Error creating data task")
                    return
                }

                // Save the data into the cache
                CacheFile.saveData(urlString, data!)

                // Check if the url string that the data task downloaded, matches the article this cell is set to display RIGHT NOW
                if self.newsArticleToDisplay?.urlToImage == urlString {

                    // Display image in main thread
                    DispatchQueue.main.async {
                        
                        self.newsArticlePhoto.image = UIImage(data: data!)
                        

                        // Animate the label into view
                        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                            self.newsArticlePhoto.alpha = 1
                        }, completion: nil)

                    }

                }
            }

            // Start data task
            dataTasks.resume()
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

        
        
        
        
    
    
