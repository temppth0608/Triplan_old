//
//  Information.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 10..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class Information {
    var stampName : String
    var dateOfInformation : NSDate
    var category : String
    var locationTitle : String
    var budget : Int
    var memo : String
    var longitude : String
    var latitude : String
    
    init() {
        stampName = ""
        dateOfInformation = NSDate()
        category = ""
        locationTitle = ""
        budget = 0
        memo = ""
        longitude = ""
        latitude = ""
    }
    
    init(pStampName : String, pDateOfInformation : NSDate, pCategory : String, pLocationTitle : String, pBudget : Int, pMemo : String, pLongitude : String, pLatitude : String) {
        stampName = pStampName
        dateOfInformation = pDateOfInformation
        category = pCategory
        locationTitle = pLocationTitle
        budget = pBudget
        memo = pMemo
        longitude = pLongitude
        latitude = pLatitude
    }
}

