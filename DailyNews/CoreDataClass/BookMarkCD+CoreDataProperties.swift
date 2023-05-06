//
//  BookMarkCD+CoreDataProperties.swift
//  DailyNews
//
//  Created by BJIT on 18/1/23.
//
//

import Foundation
import CoreData


extension BookMarkCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookMarkCD> {
        return NSFetchRequest<BookMarkCD>(entityName: "BookMarkCD")
    }

    @NSManaged public var author: String?
    @NSManaged public var bookmark: Bool
    @NSManaged public var category: String?
    @NSManaged public var content: String?
    @NSManaged public var desc: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?

}

extension BookMarkCD : Identifiable {

}
