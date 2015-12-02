//
//  Stamp.swift
//  Triplan
//
//  Created by 박태현 on 2015. 5. 9..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class Stamp {
    var title : String
    var startDate : NSDate!
    var endDate : NSDate!
    var infos : [Information]
    var hasStamp : Bool = false
    var stampName : String
    
    init() {
        title = ""
        startDate = nil
        endDate = nil
        infos = []
        stampName = ""
    }
    
    init(title : String, startDate : NSDate, endDate : NSDate,hasStamp : Bool, stampName : String) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        infos = []
        self.hasStamp = hasStamp
        self.stampName = stampName
    }
    
    func setStampName(imageName : String) {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let now = NSDate()
        let stringFromNow = formatter.stringFromDate(now)
        let stringFromEndDate = formatter.stringFromDate(self.endDate)
        
        if stringFromNow.toDouble() >= stringFromEndDate.toDouble() {
            hasStamp = true
        } else {
            hasStamp = false
        }
        
        self.stampName = imageName
    }
    
    func chackHasStamp() {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let now = NSDate()
        let stringFromNow = formatter.stringFromDate(now)
        let stringFromEndDate = formatter.stringFromDate(self.endDate)
        
        if stringFromNow.toDouble() >= stringFromEndDate.toDouble() {
            hasStamp = true
        } else {
            hasStamp = false
        }
    }
    
    func getTotalInfosBudget() -> Int {
        
        var totalBudget : Int = 0
        
        for index in 0 ..< infos.count {
            totalBudget += infos[index].budget
        }
        
        return totalBudget
    }
    
    func getBudget(categoryName : String) -> Int {
        
        var retBudget : Int = 0
        
        for index in 0 ..< infos.count {
            if infos[index].category == categoryName {
                retBudget += infos[index].budget
            }
        }
        
        return retBudget
    }
}


