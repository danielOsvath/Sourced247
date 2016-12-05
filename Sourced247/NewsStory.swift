//
//  NewsStory.swift
//  Sourced 247
//
//  Created by Daniel Osvath on 7/2/16.
//  Copyright © 2016 Daniel Osvath. All rights reserved.
//

import Foundation

class NewsStory: NSObject {
    var id: Int
    var date: Date
    var headline: String
    var subtitle: String
    var links: String
    var day: Int
    var clicks: Int
    
    init(id: Int, date: Date, headline: String, subtitle: String, links: String, day: Int, clicks: Int) {
        
        self.id = id
        self.date = date
        self.headline = headline
        self.subtitle = subtitle
        self.links = links
        self.day = day
        self.clicks = clicks
        
    }
    
    //
    //    override init() {
    //        self.id = 0
    //        self.date = Date()
    //        self.headline = "none"
    //        self.subtitle = "none"
    //        self.links = "none"
    //        self.day = 0
    //        self.clicks = 0
    //        
    //    }
    
    override var description: String{
        return "id: \(id), date: \(date), headline: \(headline), subtitle: \(subtitle), links: \(links), day: \(day), clicks: \(clicks)"
    }
}

