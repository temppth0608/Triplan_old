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
    var startDate : String!
    var endDate : String!
    var infos : [Information]?
    
    init() {
        title = ""
        startDate = ""
        endDate = ""
    }
    
    init(title : String, startDate : String, endDate : String) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }
}


