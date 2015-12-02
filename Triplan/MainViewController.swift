//
//  MainCollectionViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 5. 9..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myNavBar: UINavigationBar!
    
    var transitionOperator : TransitionOperator = TransitionOperator();
    
    // 스탬프 클래스 배열 생성
    var stamps : [Stamp] = []
    // 스탬프 클래스의 마지막 인덱스 저장 변수
    var lastIndex : Int = 0;
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        readPlistFile1()
        readPlistFile2()
        lastIndex = stamps.endIndex
        stamps = Array(stamps.reverse())
        
        for index in 0 ..< stamps.count {
            stamps[index].infos = Array(stamps[index].infos.reverse())
        }
        
        //네비게이션 바 경계선 지정
        myNavBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        myNavBar.shadowImage = UIImage()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Collection View Delete, DataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var items = stamps.count
        if section == 0 {
            items++
        }
        return items
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 && indexPath.item == lastIndex {
            
            let cell = myCollectionView.dequeueReusableCellWithReuseIdentifier("addCell", forIndexPath: indexPath) as! AddCell
            cell.addImageView.image = UIImage(named: "main_stamp_add.png")
            return cell
        } else {
            
            let cell = myCollectionView.dequeueReusableCellWithReuseIdentifier("mainCell", forIndexPath: indexPath)as! MainCell
            
            cell.titleLabel.text = "\(stamps[indexPath.row].title)"
            if stamps[indexPath.row].hasStamp == true && stamps[indexPath.row].stampName != "" {
                cell.mainImageView.image = UIImage(named: stamps[indexPath.row].stampName)
            }else {
                cell.mainImageView.image = UIImage(named: "stamp_default.png")
            }
            return cell
        }
    }
    
    // MARK: - IBAction function
    @IBAction func presentNavigation(sender: AnyObject?){
        
        performSegueWithIdentifier("presentNav", sender: self)
    }
    
    @IBAction func cancelToMainVC(segue : UIStoryboardSegue) {
        
        self.myCollectionView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelFromStatisticsVC(segue : UIStoryboardSegue) {
        
        let statisticsVC = segue.sourceViewController as! StatisticsViewController
        
        let tmpStamps = statisticsVC.stamps
        
        for index in 0 ..< stamps.count {
            self.stamps[index] = tmpStamps[index]
        }
        
        self.myCollectionView.reloadData()
    }
    
    @IBAction func saveStamp(segue : UIStoryboardSegue) {
        
        let addStampVC = segue.sourceViewController as! AddStampViewController
        
        stamps.append(addStampVC.stamp!)
        writePlistFile()
        self.navigationController?.popViewControllerAnimated(true)
        lastIndex++
        myCollectionView.reloadData()
    }
    
    //수정
    @IBAction func modifyFromModifyVC(segue : UIStoryboardSegue) {
        
        let modifyVC = segue.sourceViewController as! ModifyViewController
        
        let indexForModify = modifyVC.indexOfStamps
        stamps[indexForModify].title = modifyVC.titleTextField.text!
        stamps[indexForModify].startDate = modifyVC.startDate
        stamps[indexForModify].endDate = modifyVC.endDate
        
        writePlistFile()
        myCollectionView.reloadData()
    }
    
    //삭제
    @IBAction func deleteFromModifyVC(segue : UIStoryboardSegue) {
        
        let modifyVC = segue.sourceViewController as! ModifyViewController
        
        let indexForDelete = modifyVC.indexOfStamps
        
        stamps.removeAtIndex(indexForDelete)
        lastIndex--
        
        writePlistFile()
        myCollectionView.reloadData()
    }
    
    // MARK: - Navigation Control
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "presentNav" {
            let toViewController = segue.destinationViewController 
            self.modalPresentationStyle = UIModalPresentationStyle.Custom
            toViewController.transitioningDelegate = self.transitionOperator
        } else if segue.identifier == "selectStamp" {
            let tabVC = segue.destinationViewController as! TabViewController
            let cell = sender as! UICollectionViewCell
            let indexPath = self.myCollectionView?.indexPathForCell(cell)!
            
            tabVC.selectedStamp = self.stamps[indexPath!.row]
            tabVC.allStamps = self.stamps
            tabVC.indexOfStamps = indexPath!.row
        }
    }
    
    // MARK: - Plist File Control
    //StampList.plist read
    func readPlistFile1() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        let path = (paths as NSString).stringByAppendingPathComponent("StampList.plist")

        var stampArr : NSArray!
        stampArr = NSArray(contentsOfFile: path)
        
        if stampArr == nil {
        } else {
            for index in 0 ..< stampArr.count {
                let stampDic = stampArr[index] as! NSDictionary
                let tmpStamp = Stamp(title: stampDic["Title"] as! String,
                                    startDate: stampDic["StartDate"] as! NSDate,
                                    endDate: stampDic["EndDate"] as! NSDate,
                                    hasStamp : stampDic["HasStamp"] as! Bool,
                                    stampName : stampDic["StampName"] as! String)
                tmpStamp.chackHasStamp()
                self.stamps.append(tmpStamp)
            }
        }
    }
    
    //InformationList.plist read
    func readPlistFile2() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        let path = (paths as NSString).stringByAppendingPathComponent("InformationList.plist")
        print("path : \(path)")
        
        var infoArr : NSArray!
        infoArr = NSArray(contentsOfFile: path)
        
        if infoArr == nil {
        } else {
            for index in 0 ..< infoArr.count {
                let infoDic = infoArr[index] as! NSDictionary
                let tmpInfo = Information(
                    pStampName: infoDic["StampName"] as! String,
                    pDateOfInformation: infoDic["DateOfInformation"] as! NSDate,
                    pCategory: infoDic["Category"] as! String,
                    pLocationTitle: infoDic["LocationTitle"] as! String,
                    pBudget: infoDic["Budget"] as! Int,
                    pMemo: infoDic["Memo"] as! String,
                    pLongitude: infoDic["Longitude"] as! String,
                    pLatitude: infoDic["Latitude"] as! String
                )
                
                for index in 0 ..< stamps.count {
                    //var tmpStamp = stamps[index]
                    if stamps[index].title == tmpInfo.stampName {
                        stamps[index].infos.append(tmpInfo)
                    }
                }
            }
        }
    }

    //StampList.plist Write
    func writePlistFile() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = (paths as NSString).stringByAppendingPathComponent("StampList.plist")
        let fileManager = NSFileManager.defaultManager()
        
        if stamps.count == 0 {
            do {
                try fileManager.removeItemAtPath(path)
            } catch _ {
                
            }
        }
        let stampArr = NSMutableArray()
        
        for index in 0 ..< stamps.count {
            let item : Stamp = stamps[index]
            
            let title : String = item.title
            let startDate : NSDate = item.startDate
            let endDate : NSDate = item.endDate
            let hasStamp : Bool = item.hasStamp
            let stampName : String = item.stampName
            
            let dic : NSDictionary = [
                "Title" : title,
                "StartDate" : startDate,
                "EndDate" : endDate,
                "HasStamp" : hasStamp,
                "StampName" : stampName
            ]
            
            stampArr.insertObject(dic, atIndex: 0)
            
            if (!(fileManager.fileExistsAtPath(path)))
            {
                let bundle : NSString = NSBundle.mainBundle().pathForResource("StampList", ofType: "plist")!
                do {
                    try fileManager.copyItemAtPath(bundle as String, toPath: path)
                } catch _ {
                }
            }
            stampArr.writeToFile(path, atomically: true)
        }
    }
}

