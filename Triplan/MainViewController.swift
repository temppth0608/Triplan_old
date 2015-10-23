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
        stamps = reverse(stamps)
        
        for index in 0 ..< stamps.count {
            stamps[index].infos = reverse(stamps[index].infos)
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
            cell.mainImageView.image = UIImage(named: "main_stamp_off.png")
            return cell
        }
    }
    
    // MARK: - IBAction function
    @IBAction func presentNavigation(sender: AnyObject?){
        
        performSegueWithIdentifier("presentNav", sender: self)
    }
    
    @IBAction func cancelToMainVC(segue : UIStoryboardSegue) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveStamp(segue : UIStoryboardSegue) {
        
        var addStampVC = segue.sourceViewController as! AddStampViewController
        
        stamps.append(addStampVC.stamp!)
        writePlistFile()
        self.navigationController?.popViewControllerAnimated(true)
        lastIndex++
        myCollectionView.reloadData()
    }
    
    //수정
    @IBAction func modifyFromModifyVC(segue : UIStoryboardSegue) {
        
        var modifyVC = segue.sourceViewController as! ModifyViewController
        
        var indexForUpdate = modifyVC.indexOfStamps
        stamps[indexForUpdate].title = modifyVC.titleTextField.text
        stamps[indexForUpdate].startDate = modifyVC.startDate
        stamps[indexForUpdate].endDate = modifyVC.endDate
        
        writePlistFile()
        myCollectionView.reloadData()
    }
    
    //삭제
    @IBAction func deleteFromModifyVC(segue : UIStoryboardSegue) {
        
        var modifyVC = segue.sourceViewController as! ModifyViewController
        
        var indexForDelete = modifyVC.indexOfStamps
        
        stamps.removeAtIndex(indexForDelete)
        lastIndex--
        
        var alertHelper = AlertHelper()
        alertHelper.triggerAlert(fromController: self, title: "알림", message: "삭제 완료!", closeText: "닫기")
        myCollectionView.reloadData()
        writePlistFile()
    }
    
    // MARK: - Navigation Control
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "presentNav" {
            let toViewController = segue.destinationViewController as! UIViewController
            self.modalPresentationStyle = UIModalPresentationStyle.Custom
            toViewController.transitioningDelegate = self.transitionOperator
        } else if segue.identifier == "selectStamp" {
            let tabVC = segue.destinationViewController as! TabViewController
            let cell = sender as! UICollectionViewCell
            let indexPath = self.myCollectionView?.indexPathForCell(cell)!
            
            tabVC.selectedStamp = self.stamps[indexPath!.row]
            tabVC.allStamps = self.stamps
            tabVC.indexOfStamps = indexPath!.row
            
            for index in 0 ..< stamps[indexPath!.row].infos.count {
                var tmpInfos = stamps[indexPath!.row].infos[index]
                println("info정보 \(index) 번째")
                println(tmpInfos.stampName)
                println(tmpInfos.category)
                println(tmpInfos.locationTitle)
                println(tmpInfos.dateOfInformation)
                println(tmpInfos.budget)
                println(tmpInfos.altitude)
                println(tmpInfos.latitude)
                println("")
            }
        }
    }
    
    // MARK: - Plist File Control
    //StampList.plist read
    func readPlistFile1() {
        
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var path = paths.stringByAppendingPathComponent("StampList.plist")

        var stampArr : NSArray!
        stampArr = NSArray(contentsOfFile: path)
        
        if stampArr == nil {
            println("stampArr is nil")
        } else {
            for index in 0 ..< stampArr.count {
                var stampDic = stampArr[index] as! NSDictionary
                var tmpStamp = Stamp(title: stampDic["Title"] as! String,
                    startDate: stampDic["StartDate"] as! NSDate,
                    endDate: stampDic["EndDate"] as! NSDate)
                self.stamps.append(tmpStamp)
            }
        }
    }
    
    //InformationList.plist read
    func readPlistFile2() {
        
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var path = paths.stringByAppendingPathComponent("InformationList.plist")
        
        var infoArr : NSArray!
        infoArr = NSArray(contentsOfFile: path)
        
        if infoArr == nil {
            println("infoArr is nill")
        } else {
            for index in 0 ..< infoArr.count {
                var infoDic = infoArr[index] as! NSDictionary
                var tmpInfo = Information(
                    pStampName: infoDic["StampName"] as! String,
                    pDateOfInformation: infoDic["DateOfInformation"] as! NSDate,
                    pCategory: infoDic["Category"] as! String,
                    pLocationTitle: infoDic["LocationTitle"] as! String,
                    pBudget: infoDic["Budget"] as! Int,
                    pMemo: infoDic["Memo"] as! String,
                    pAltitude: infoDic["Altitude"] as! String,
                    pLatitude: infoDic["Latitude"] as! String
                )
                
                for index in 0 ..< stamps.count {
                    var tmpStamp = stamps[index]
                    if stamps[index].title == tmpInfo.stampName {
                        stamps[index].infos.append(tmpInfo)
                    }
                }
            }
        }
    }

    //StampList.plist Write
    func writePlistFile() {
        
        var stampArr = NSMutableArray()
        
        for index in 0 ..< stamps.count {
            var item : Stamp = stamps[index]
            
            var title : String = item.title
            var startDate : NSDate = item.startDate
            var endDate : NSDate = item.endDate
            
            var dic : NSDictionary = [
                "Title" : title,
                "StartDate" : startDate,
                "EndDate" : endDate,
            ]
            
            stampArr.insertObject(dic, atIndex: 0)
            
            var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]as! String
            var path = paths.stringByAppendingPathComponent("StampList.plist")
            var fileManager = NSFileManager.defaultManager()
            if (!(fileManager.fileExistsAtPath(path)))
            {
                var bundle : NSString = NSBundle.mainBundle().pathForResource("StampList", ofType: "plist")!
                fileManager.copyItemAtPath(bundle as String, toPath: path, error:nil)
            }
            
            stampArr.writeToFile(path, atomically: true)
        }
    }
}

class AlertHelper {
    //Alert function
    func triggerAlert(fromController controller : UIViewController,title : String, message : String, closeText : String) {
        
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertViewController.addAction(UIAlertAction(title: closeText, style: UIAlertActionStyle.Cancel, handler: nil))
        controller.presentViewController(alertViewController, animated: true, completion: nil)
    }
}
