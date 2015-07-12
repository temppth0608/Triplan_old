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
    var stamps : [Stamp] = [Stamp(title: "부산 여행", startDate: NSDate(), endDate:                                  NSDate()),
                            Stamp(title: "전주 여행", startDate: NSDate(), endDate: NSDate()),
                            Stamp(title: "인천 여행", startDate: NSDate(), endDate: NSDate())]
    var lastIndex : Int = 0;
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
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
        self.navigationController?.popViewControllerAnimated(true)
        lastIndex++
        myCollectionView.reloadData()
    }
}
