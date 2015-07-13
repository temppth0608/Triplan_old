//
//  TravelViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 5..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class TravelViewController: UIViewController , CLWeeklyCalendarViewDelegate{
    
    @IBOutlet weak var myNavItem: UINavigationItem!
    @IBOutlet weak var myNavBar: UINavigationBar!
    var stamp : Stamp!
    var calendarView : CLWeeklyCalendarView!

    override func viewDidLoad() {
        super.viewDidLoad()

        myNavBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        myNavBar.shadowImage = UIImage()
        myNavItem.title = stamp.title

        if !(calendarView != nil) {
            calendarView = CLWeeklyCalendarView(frame: CGRect(x: 0, y: 64.0, width: self.view.bounds.width, height: 150.0))
            calendarView.delegate = self
        }
        
        self.view.addSubview(self.calendarView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func CLCalendarBehaviorAttributes() -> [NSObject : AnyObject]! {
        return [CLCalendarWeekStartDay : 1]
    }
    
    func dailyCalendarViewDidSelect(date: NSDate!) {
        
    }
    
    
}
