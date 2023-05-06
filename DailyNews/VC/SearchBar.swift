//
//  SearchBar.swift
//  DailyNews
//
//  Created by BJIT on 17/1/23.
//

import Foundation
import UIKit

class SearchBar {
    
    static let shared = SearchBar()
    
    private init () {}
    
    func createSearchBar(searchBar: UITextField) {
        let imageIcon = UIImageView()
        imageIcon.tintColor = .black
        let contentView = UIView()
        contentView.addSubview(imageIcon)
        searchBar.leftView = contentView
        searchBar.leftViewMode = .always
        searchBar.clearButtonMode = .whileEditing
    }
}


