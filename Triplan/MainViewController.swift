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
    
    var stamps : [Stamp] = []
    var lastIndex : Int = 0;
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        readPlistFile()
        lastIndex = stamps.endIndex
        
        myNavBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        myNavBar.shadowImage = UIImage()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
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
    
    @IBAction func presentNavigation(sender: AnyObject?){
        
        performSegueWithIdentifier("presentNav", sender: self)
    }
    
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
        }
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
    
    func readPlistFile() {
        
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var path = paths.stringByAppendingPathComponent("StampList.plist")
        print(path)
        
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
