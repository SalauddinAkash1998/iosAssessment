
//  ViewController.swift
//  DailyNews
//
//  Created by BJIT on 12/1/23.
//

import UIKit
import SDWebImage
import CoreData

class ViewController: UIViewController {
    
        //@IBOutlet weak var collectionLabel: UILabel!
    
    var result : NewsArticleServices?
    var numofRows: Int!
    var flag: Bool!
    var url = " "
    var search = ""
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var searchBar1: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var category = "category=\(Category.category[0])"
    var model = NewsArticleModel()
    var articles = [NewsArticle]()
    var arArr = [DailyNewsCoreData]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchBar.shared.createSearchBar(searchBar: searchBar1)
        // Set viewController as delegate and dataSource for tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Get articles from article model
        model.delegate = self
        //searchBar1.delegate = self
    
        //model.getArticles(catg: "general")
        let result = CDManager.shared.getAllItemsAllSection()
                if(result.count == 0){
                    for i in 0..<7 {
                        model.getArticles(catg: "\(Category.category[i])")


                    }
                }
               else{
                   arArr = result
                    tableView.reloadData()
                }
        searchBar1.addTarget(self, action: #selector(searchNewsAction), for: .editingChanged)
        tableView.refreshControl =  UIRefreshControl()
                tableView.refreshControl?.addTarget(self, action: #selector(pullToRefreshData), for: .valueChanged)
        //        model.getArticles(catg: "general")
    }
    @objc private func pullToRefreshData(){
        DispatchQueue.main.async { [self] in
                print("start refresh")
                //self.deleteAllArticle()
                self.getNewsArticles(for: category)
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
                
            }
        }
    func deleteAllArticle(){
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DailyNewsCoreData")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(batchDeleteRequest)
            } catch let error as NSError {
                print(error)
            }
        }
    

    
    func getAllItemsBySearch(search: String) -> [DailyNewsCoreData]?  {
        do{
            let fetchRequest = NSFetchRequest<DailyNewsCoreData>(entityName: "DailyNewsCoreData")
            let predicate = NSPredicate(format: "title CONTAINS [c] %@", search)
            fetchRequest.predicate = predicate
            
            let modelssss = try context.fetch(fetchRequest)
            return modelssss
        } catch{
            print(error)
        }
        return nil
    }
  
    @objc func searchNewsAction(){
        let textlabel = searchBar1.text!
        guard let results = getAllItemsBySearch(search: textlabel) else {
            return
        }
        articles.removeAll()
        for result in results {
            var news = NewsArticle()
            news.title = result.title
            news.urlToImage = result.urlToImage
            news.content = result.content
            news.url = result.url
            news.author = result.author
            news.description = result.description
            news.publishedAt = result.publishedAt
            //news.bookmark = result.bookmark
        
            
            articles.append(news)
        }
        tableView.reloadData()
            
        }
    
    func handleMarkAsFavourite(index: IndexPath){
        
        
        let selectedItemIndex = self.tableView.indexPathForSelectedRow
            print("selected Index: ",index.row)
            
            let article =  self.articles[index.row]
            
            let newBookmarked = BookMarkCD(context: context)
            
            newBookmarked.author = article.author
            newBookmarked.title = article.title
        //newBookmarked.bookmark = article.bookmark
            newBookmarked.category = article.category
            newBookmarked.content = article.content
            newBookmarked.desc = article.desc
            newBookmarked.publishedAt = article.publishedAt
            newBookmarked.url = article.url
            newBookmarked.urlToImage = article.urlToImage
            
            CDManager.shared.addNewBookmark(bookmarkedItem: newBookmarked)
            
            
            
            
        
    }
   
    func getNewsArticles(for category: String) -> Void {
        model.getArticles(catg: category)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the index path of the row the user clicked on
        let indexPath = tableView.indexPathForSelectedRow
        guard indexPath != nil else {
            return
        }
        
        let selectArticle = articles[indexPath!.row]
        let extendedNewsVC = segue.destination as! ExtendedNewsVC
        if let url = selectArticle.url {
            extendedNewsVC.articleURL = url
        }
    }
    
}

extension ViewController : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Category.category.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionView", for: indexPath) as! CollectionViewCell
        //collectionCell.category.text = "Category"
        collectionCell.categoryLabel.text = Category.category[indexPath.row]
        return collectionCell
        
    }
}
extension ViewController{
    
}
extension ViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell{
            category = cell.categoryLabel.text!
            cell.categoryLabel.textColor = UIColor.blue
            //cell.categoryView.backgroundColor = UIColor.green
            
        
            getNewsArticles(for: cell.categoryLabel.text!)
            print(indexPath)
            //model.getArticles(catg: Category.category[indexPath.row]) {_ in}
            if((Category.category[indexPath.row]) == "All"){
                arArr = CDManager.shared.getAllItemsAllSection()
                tableView.reloadData()
            }
            else{
                arArr = CDManager.shared.getAllItems(category: "\(Category.category[indexPath.row])")
//                category = "category=\(Category.category[indexPath.row])"
            }
//            cell.categoryView.backgroundColor = UIColor.white
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        cell?.categoryLabel.textColor = .black
    }
}
extension ViewController: ArticleModelProtocol {
    func articlesRetrieved(_ articles: [NewsArticle]) {
        self.articles = articles
        // Refresh table view to show new data
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate {
//    func allBookmarkNews(index : IndexPath){
//        guard let appDelegate = UIApplication.shared.delegate as?
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let action = UIContextualAction(style: .normal,
                                            title: "Bookmark") { [weak self] (action, view, completionHandler) in
                self?.handleMarkAsFavourite(index: indexPath)
                                                completionHandler(true)
            }
            action.backgroundColor = .systemMint
            return UISwipeActionsConfiguration(actions: [action])
        
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "toWebpage", sender: self)
    }
    
}

// MARK: - UITableView DataSource Methods
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(articles.count)
        return articles.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue a cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! NewsArticleCell

        // Get the article the table view is asking about
        let articleToDisplay = articles[indexPath.row]
        
        // Customize cell
        cell.articleDisplay(articleToDisplay)
        
        // Return the cell
        return cell
        
    }
    
}


