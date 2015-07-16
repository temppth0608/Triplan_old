//
//  TabViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 5. 10..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController , UITabBarControllerDelegate{

    @IBOutlet weak var myTabBar: UITabBar!
    //선택된 stamp객체 생성
    var selectedStamp = Stamp();
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.delegate = self
        //navigation tint color
        myTabBar.tintColor = UIColor(red: 90/255.0, green: 199/255.0, blue: 211/255.0, alpha: 1)
        
        //3개의 각각의 VC를 배열로써 지정
        let travelVC = self.viewControllers![0] as! TravelViewController
        let statisticsVC = self.viewControllers![1] as! StatisticsViewController
        let modifyVC = self.viewControllers![2] as! ModifyViewController
        
        //선택된 stamp객체를 각각의 VC의 stamp변수에 저장
        travelVC.stamp = self.selectedStamp
        statisticsVC.stamp = self.selectedStamp
        modifyVC.stamp = self.selectedStamp
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
