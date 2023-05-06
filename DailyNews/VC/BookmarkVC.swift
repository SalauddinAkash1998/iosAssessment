//
//  BookmarkVC.swift
//  DailyNews
//
//  Created by BJIT on 17/1/23.
//

import UIKit
import CoreData

class BookmarkVC: UIViewController {
    //var bookmarksArr = [BookMarkCD]()
    
    @IBOutlet weak var searchBar: UITextField!
    var model = NewsArticleModel()
    var articles = [NewsArticle]()
    var arArr = [BookMarkCD]()
    var search = " "
    var url = ""
    var category = "category=\(Category.category[0])"
    
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        //bookmarks = getAll
        tableView.delegate = self
        tableView.dataSource = self
        SearchBar.shared.createSearchBar(searchBar: searchBar)
        searchBar.addTarget(self, action: #selector(searchNewsAction), for: .editingChanged)
//        arArr = CDManager.shared.getAllRecordsBookMarked(category: "category=\(category)", search: search)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        arArr = CDManager.shared.getAllBookmarks()!
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the index path of the row the user clicked on
        let indexPath = tableView.indexPathForSelectedRow
        guard indexPath != nil else {
            return
        }
        
        let selectArticle1 = arArr[indexPath!.row]
        let extendedNewsVC1 = segue.destination as! ExtendedNewsVC
        if let url = selectArticle1.url {
            extendedNewsVC1.articleURL = url
        }
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        tableView.reloadData()
//    }
    
    func getAllItemsBySearch(search: String) -> [BookMarkCD]?  {
        do{
            let fetchRequest = NSFetchRequest<BookMarkCD>(entityName: "BookMarkCD")
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
        let textlabel = searchBar.text!
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
        
            
            articles.append(news)
        }
        tableView.reloadData()
            
        }
    func getAllBookmarks() -> [BookMarkCD]?  {
               let appDelegate = UIApplication.shared.delegate as? AppDelegate
               let BookmarkContext = appDelegate!.persistentContainer.viewContext
               do{
                   let fetchRequest = NSFetchRequest<BookMarkCD>(entityName: "BookMarkCD")
                   let bookmarkAll = try BookmarkContext.fetch(fetchRequest)
                   return bookmarkAll
               }catch{
                   print("cant fetch from core")
               }
               return nil
           }

        
    
}

extension BookmarkVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        performSegue(withIdentifier: "bmtoWebpage", sender: self)
        if let newsLink = arArr[indexPath.row].url {
            url = newsLink
        }
    }
    func removeBookmarkNews(index: IndexPath) {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                let BookmarkContext = appDelegate.persistentContainer.viewContext
                let Bookmarkentity = NSEntityDescription.entity(forEntityName: "Bookmarks", in : BookmarkContext)
                let objectToDelete = arArr[index.row]
                BookmarkContext.delete(objectToDelete)
                do {
                    try BookmarkContext.save()
                    self.arArr = getAllBookmarks()!
                    tableView.reloadData()
                } catch
                    let error as NSError {
                    print("Could not delete. \(error),\(error.userInfo)")
                }
               
            }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let action = UIContextualAction(style: .normal,
                                                    title: "delete") { [weak self] (action, view, completionHandler) in
                        self?.removeBookmarkNews(index: indexPath)
                                                        completionHandler(true)
                    }
                    action.backgroundColor = .systemRed
                    return UISwipeActionsConfiguration(actions: [action])
        }
    
}
    
extension BookmarkVC : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell") as! BookmarkCell
//        let articleToDisplay = arArr[indexPath.row]
        let image = arArr[indexPath.row].urlToImage
        if let image = image {
            cell.bookmarkImgView.sd_setImage(with: URL(string: image))
            print("SD Image: ", image)
        }
        else {
            cell.bookmarkImgView.image = UIImage(systemName: "trash")
        }
        cell.bookmarkLabel.text = arArr[indexPath.row].title
//        cell.authorLabel.text = articlesArray[indexPath.row].author
//        cell.dateLabel.text = articlesArray[indexPath.row].publishedAt
        return cell
    }
}
