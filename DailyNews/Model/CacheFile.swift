//
//  CacheManager.swift
//  DailyNews
//
//  Created by BJIT on 13/1/23.
//

import Foundation

class CacheFile {
    
    static var imageStoredDict = [String : Data]()
    
    static func saveData(_ url: String, _ imageData: Data) {
        
        imageStoredDict[url] = imageData
        
    }
    
    static func retrieveData(_ url: String) -> Data? {
        
        // Returns image data or nil if that url does not exist in the dictionary
        return imageStoredDict[url]
        
    }
    
}

