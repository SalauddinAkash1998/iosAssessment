//
//  CDManager.swift
//  DailyNews
//
//  Created by BJIT on 16/1/23.
//

import Foundation
import UIKit
import CoreData

class CDManager{
    static let shared = CDManager()
    private init(){}
    var models = [DailyNewsCoreData]()
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllRecord(search: String, category: String) -> [DailyNewsCoreData]{
        var cdArr = [DailyNewsCoreData]()
        do{
        
                        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchReq = NSFetchRequest<DailyNewsCoreData>(entityName: "DailyNewsCoreData")
            let predicate = NSPredicate(format: "category == %@ title CONTAINS [c] %@", search, category)
            fetchReq.predicate = predicate
            cdArr = try context.fetch(fetchReq)
            print(cdArr)
        }
        catch{
            print(error.localizedDescription)
        }
        return cdArr
    }
    func addRecords(title : String?, author : String?, url : String?, urlToImage : String?, publishedAt : String?, desc : String?, category :String?, content : String?) {
        let items = DailyNewsCoreData(context: context)
        _ = [DailyNewsCoreData]()
        do {
            items.title = title
            items.author = author
            items.url = url
            items.publishedAt = publishedAt
            items.category = category
            items.bookmark = false
            items.urlToImage = urlToImage
            items.content = content
            
            try context.save()
            //            cdArr.append(items)
        }
        catch{
            print(error)
        }
        
    }
    func getAllItemsAllSection() -> [DailyNewsCoreData]  {
            do{
                let fetchRequest = NSFetchRequest<DailyNewsCoreData>(entityName: "DailyNewsCoreData")

                models = try context.fetch(fetchRequest)

            } catch{
                print(error)
            }
            return models
            
        }
    func updateRecords(index: Int, val: Bool, nArray: [DailyNewsCoreData], context: NSManagedObjectContext) -> [DailyNewsCoreData]{
        let items = nArray[index]
        items.bookmark = val
        
        do{
            try context.save()
        }
        catch{
            print(error)
        }
        return nArray
    }
    func getAllRecordsBookMarked(category: String, search: String) -> [BookMarkCD] {
        var articlesArray = [BookMarkCD]()
        do {

//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<BookMarkCD>(entityName: "BookMarkCD")
            let predicate = NSPredicate(format: "category == %@ && bookmark == 1 && title CONTAINS [c] %@", category, search)
            fetchRequest.predicate = predicate

            articlesArray = try context.fetch(fetchRequest)
            print(articlesArray)
        }
        catch {
            print(error.localizedDescription)
        }
        return articlesArray
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
    
    func addNewBookmark(bookmarkedItem : BookMarkCD){
        
        do{
            try context.save()

        }
        catch{
            print(error.localizedDescription)
        }
            
        
    }
    func getAllItems(category: String) -> [DailyNewsCoreData]  {
            do{
                let fetchRequest = NSFetchRequest<DailyNewsCoreData>(entityName: "DailyNewsCoreData")
                let predicate = NSPredicate(format: "category == %@", category)
                fetchRequest.predicate = predicate

                models = try context.fetch(fetchRequest)
               
             
         

            } catch{
                print(error)
            }
            return models
            
        }
}
