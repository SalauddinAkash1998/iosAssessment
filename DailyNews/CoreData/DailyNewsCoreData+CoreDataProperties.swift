//
//  DailyNewsCoreData+CoreDataProperties.swift
//  
//
//  Created by BJIT on 18/1/23.
//
//

import Foundation
import CoreData


extension DailyNewsCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyNewsCoreData> {
        return NSFetchRequest<DailyNewsCoreData>(entityName: "DailyNewsCoreData")
    }

    @NSManaged public var author: String?
    @NSManaged public var bookmark: String?
    @NSManaged public var category: String?
    @NSManaged public var content: String?
    @NSManaged public var desc: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?

}
