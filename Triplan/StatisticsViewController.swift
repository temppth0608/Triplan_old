//
//  StatisticsViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 6..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var trafficMoneyLabel: UILabel!
    @IBOutlet weak var foodMoneyLabel: UILabel!
    @IBOutlet weak var landscapeMoneyLabel: UILabel!
    @IBOutlet weak var hotelMoneyLabel: UILabel!
    @IBOutlet weak var etcMoneyLabel: UILabel!
    @IBOutlet weak var myNavBar: UINavigationBar!
    var stamp : Stamp!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myNavBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        myNavBar.shadowImage = UIImage()

        setBudget()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //각 Budget Label에 데이터 저장
    func setBudget() {
        
        var train = "train"
        var food = "food"
        var landmark = "landmark"
        var hotel = "hotel"
        var ect = "ect"
        
        totalMoneyLabel.text = "\(stamp.getTotalInfosBudget()) 원"
        trafficMoneyLabel.text = "\(stamp.getBudget(train)) 원"
        foodMoneyLabel.text = "\(stamp.getBudget(food)) 원"
        landscapeMoneyLabel.text = "\(stamp.getBudget(landmark)) 원"
        hotelMoneyLabel.text = "\(stamp.getBudget(hotel)) 원"
        etcMoneyLabel.text = "\(stamp.getBudget(ect)) 원"
    }
}
