//
//  Comic.swift
//  XKCD-Viewer
//
//  Created by Jon Friskics on 8/23/16.
//  Copyright © 2016 Code School. All rights reserved.
//

import Foundation

struct Comic {
    var num: Int
    var title: String
    var safe_title: String
    var alt: String
    var img: String

    var day: Int
    var month: Int
    var year: Int
    
    var link: NSURL

    var news: String
    var transcript: String
    
    init?(jsonData: [String:AnyObject]) {
        self.num = jsonData["num"] as! Int
        self.title = jsonData["title"] as! String
        self.safe_title = jsonData["safe_title"] as! String
        self.alt = jsonData["alt"] as! String
        self.img = jsonData["img"] as! String
        self.day = Int(jsonData["day"] as! String)!
        self.month = Int(jsonData["month"] as! String)!
        self.year = Int(jsonData["year"] as! String)!
        self.link = NSURL(string: "\(jsonData["link"])")!
        self.news = jsonData["news"] as! String
        self.transcript = jsonData["transcript"] as! String
    }
}
