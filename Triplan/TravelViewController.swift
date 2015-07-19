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
    //CLWeeklyCalendarView생성 (라이브러리 클래스)
    var calendarView : CLWeeklyCalendarView!
    //날짜에 맞는 info들만을 보여줄 Information배열 객체 생성
    var displayInfos : [Information] = []
    //weekly calendar에서 선택된 날짜를 담는 변수
    var selectedDate : NSDate!
    //stamp 배열의 마지막 인덱스를 저장
    var lastIndex : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        myNavBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        myNavBar.shadowImage = UIImage()
        myNavItem.title = stamp.title
        //테이블뷰의 스크롤을 (위로, 아래로 흐르는것) 제어
        myTableView.bounces = false
        
        // calendarView객체 인스턴스
        if !(calendarView != nil) {
            calendarView = CLWeeklyCalendarView(frame: CGRect(x: 0, y: 64.0, width: self.view.bounds.width, height: 80.0))
        }
        calendarView.delegate = self
        
        myTableView.delegate = self
        myTableView.dataSource = self
        stamp.infos = [Information(pStampName: "test",
                                   pDateOfInformation: NSDate(),
                                   pCategory: "test",
                                   pLocationTitle: "test",
                                   pBudget: 1111,
                                   pMemo: "test") ,
                        Information(pStampName: "test2",
                                    pDateOfInformation: NSDate(),
                                    pCategory: "test2",
                                    pLocationTitle: "test2",
                                    pBudget: 2222,
                                    pMemo: "test2"),
                        Information(pStampName: "test3",
                                    pDateOfInformation: NSDate(),
                                    pCategory: "test3",
                                    pLocationTitle: "test3",
                                    pBudget: 3,
                                    pMemo: "test3")]
        
        lastIndex = stamp.infos.endIndex
        
        // calendarView를 컨트를러에 추가
        self.view.addSubview(self.calendarView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - CLCalendar Delegate
    // 1주의 시작 요일 을 저장(1 - MON, 7- SUN)
    func CLCalendarBehaviorAttributes() -> [NSObject : AnyObject]! {
        return [CLCalendarWeekStartDay : 1]
    }
    
    //각각의 요일이 눌렷을때 이벤트
    func dailyCalendarViewDidSelect(date: NSDate!) {
        selectedDate = date
        
        displayInfos = []
        
        let formatter : NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var stringFromSelectedDate = formatter.stringFromDate(selectedDate)
        
        for index in 0 ..< stamp.infos.count {
            var stringFromInfoDate = formatter.stringFromDate(stamp.infos[index].dateOfInformation)
            
            if stringFromInfoDate == stringFromSelectedDate {
                displayInfos.append(stamp.infos[index])
                println(displayInfos[index].locationTitle)
            }
        }
        myTableView.reloadData()
    }
    
    // MARK: - TableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var items = stamp.infos.count
        if section == 0 {
            items++
        }
        return items
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.item == lastIndex{
            
            let cell = myTableView.dequeueReusableCellWithIdentifier("AddDetailCell", forIndexPath: indexPath) as! AddDetailTableViewCell
            cell.addImageView.image = UIImage(named: "plan_addplan.png")
            cell.addLabel.text = "추가"
            return cell
        } else {
            
            let cell = myTableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as! DetailTableViewCell

            cell.detailTitleLabel.text = "\(stamp.infos[indexPath.row].locationTitle)"
            cell.detailBudgetLabel.text = "\(stamp.infos[indexPath.row].budget) 원"
            cell.detailContentsLabel.text = "\(stamp.infos[indexPath.row].memo)"
                
            switch stamp.infos[indexPath.row].category {
            case "ect":
                cell.detailIconImageView.image = UIImage(named: "addpaln_ect.png")
            case "food":
                cell.detailIconImageView.image = UIImage(named: "addpaln_food.png")
            case "hotel":
                cell.detailIconImageView.image = UIImage(named: "addpaln_hotel.png")
            case "landmark":
                cell.detailIconImageView.image = UIImage(named: "addpaln_landmark.png")
            default:
                cell.detailIconImageView.image = UIImage(named: "addpaln_train.png")
            }
            return cell
        }
    }
    
    // MARK: - TableView Delegate
    //셀을 밀어 삭제하기
    func tableView(tableView: UITableView, commitEditingStyle editingStyle:UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch editingStyle {
        case .Delete:
            self.stamp.infos.removeAtIndex(indexPath.row)
            self.myTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            lastIndex = stamp.infos.count
            
        default:
            return
        }
    }
    
    // 인덱스 패스의 row에따라서 셀의 높이 지정(스토리 보드에서 안되는 버그 해결)
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == lastIndex {
            return 60.0
        } else {
            return 80.0
        }
    }
    
    // MARK: - Navigation Control
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SelectAddInfo" {
            let addInfomationVC = segue.destinationViewController as! AddInfomationViewController
            addInfomationVC.belongedStampName = stamp.title
        }
    }
    
    // MARK: - IBAction function
    @IBAction func cancelToTravelVC(segue : UIStoryboardSegue) {
        
    }
    
    @IBAction func saveInfomation(segue : UIStoryboardSegue) {
        
        let addInformationVC = segue.sourceViewController as! AddInfomationViewController
        stamp.infos.append(addInformationVC.info)
        lastIndex = stamp.infos.endIndex
        myTableView.reloadData()
    }
}
