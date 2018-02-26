//
//  PhotoBookmark.swift
//  FlickrDemo
//
//  Created by Scott Carter on 2/26/18.
//  Copyright © 2018 Scott Carter. All rights reserved.
//

import Foundation

import RealmSwift


class PhotoBookmark: Object {
    
    
    // Use the dynamic keyword to force dynamic dispatch.  An explanation:
    // https://cocoacasts.com/what-does-the-dynamic-keyword-mean-in-swift-3/
    //
    @objc dynamic var photoUrl: String!
    
    @objc dynamic var photoTitle: String!
    
    @objc dynamic var photoDescription: String!
    
    
    enum BookmarkOrder: String {
        case PhotoTitle = "photoTitle"
    }
    
    // Public for Reference framework.
    override class func primaryKey() -> String? {
        return "photoUrl"
    }
    
    
    convenience init(photoUrl: String, photoTitle: String, photoDescription: String) {
        self.init()
        self.photoUrl = photoUrl
        self.photoTitle = photoTitle
        self.photoDescription = photoDescription
    }
    
    
}



