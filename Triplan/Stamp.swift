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
    
    init() {
        title = ""
        startDate = nil
        endDate = nil
        infos = []
    }
    
    init(title : String, startDate : NSDate, endDate : NSDate) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        infos = []
    }
}


