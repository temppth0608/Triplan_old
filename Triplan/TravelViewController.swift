//
//  TravelViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 5..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class TravelViewController: UIViewController , CLWeeklyCalendarViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myNavItem: UINavigationItem!
    @IBOutlet weak var myNavBar: UINavigationBar!
    @IBOutlet weak var myTableView: UITableView!
    
    var stamp : Stamp!
    var calendarView : CLWeeklyCalendarView!
    var infos : [Information] = []
    var datesWithInfos : [NSDate : Information] = Dictionary()
    var selectedDate : NSDate!
    var lastIndex : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        myNavBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        myNavBar.shadowImage = UIImage()
        myNavItem.title = stamp.title
        myTableView.bounces = false
        myTableView.estimatedRowHeight = 10.0
        
        infos = [Information(pCategory: "hotel",
                             pLocationTitle: "호텔",
                             pBudget: 100000,
                             pMemo: "Sample Memo"),
                Information(pCategory: "ect",
                            pLocationTitle: "박물관",
                            pBudget: 200000,
                            pMemo: "Sample MemoSample MemoSample MemoSample MemoSample MemoSample MemoSample Memo"),
                Information(pCategory: "food",
                            pLocationTitle: "맛집",
                            pBudget: 66000,
                            pMemo: "Sample MemoSample MemoSample MemoSample MemoSample MemoSample MemoSample Memo")]

        lastIndex = infos.endIndex
        if !(calendarView != nil) {
            calendarView = CLWeeklyCalendarView(frame: CGRect(x: 0, y: 64.0, width: self.view.bounds.width, height: 80.0))
            calendarView.delegate = self
        }
        selectedDate = calendarView.selectedDate
        self.view.addSubview(self.calendarView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - CLCalendar Delegate
    func CLCalendarBehaviorAttributes() -> [NSObject : AnyObject]! {
        return [CLCalendarWeekStartDay : 1]
    }
    
    func dailyCalendarViewDidSelect(date: NSDate!) {
        selectedDate = date
    }
    
    // MARK: - TableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var items = infos.count
        if section == 0 {
            items++
        }
        return items
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.item == lastIndex{
            
            let cell = myTableView.dequeueReusableCellWithIdentifier("AddDetailCell", forIndexPath: indexPath) as! AddDetailTableViewCell
            cell.addImageView.image = UIImage(named: "main_stamp_add.png")
            cell.addLabel.text = "추가"
            return cell
        } else {
            
            let cell = myTableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as! DetailTableViewCell
            cell.detailTitleLabel.text = "\(infos[indexPath.row].locationTitle)"
            cell.detailBudgetLabel.text = "\(infos[indexPath.row].budget) 원"
            cell.detailContentsLabel.text = "\(infos[indexPath.row].memo)"
            
            switch infos[indexPath.row].category {
            case "ect":
                cell.detailIconImageView.image = UIImage(named: "addpaln_ect.png")
            case "food":
                cell.detailIconImageView.image = UIImage(named: "addpaln_food.png")
            case "hotel":
                cell.detailIconImageView.image = UIImage(named: "addpaln_hotel.png")
            case "landmark":
                cell.detailIconImageView.image = UIImage(named: "addpaln_landmark.png")
            case "location":
                cell.detailIconImageView.image = UIImage(named: "addpaln_location.png")
            default:
                cell.detailIconImageView.image = UIImage(named: "addpaln_train.png")
            }
            
            return cell
        }
    }
    
    // MARK: - TableView Delegate
}
