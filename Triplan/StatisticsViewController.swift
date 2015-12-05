//
//  StatisticsViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 6..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController , GMSMapViewDelegate, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var trafficMoneyLabel: UILabel!
    @IBOutlet weak var foodMoneyLabel: UILabel!
    @IBOutlet weak var landscapeMoneyLabel: UILabel!
    @IBOutlet weak var hotelMoneyLabel: UILabel!
    @IBOutlet weak var etcMoneyLabel: UILabel!
    @IBOutlet weak var myNavBar: UINavigationBar!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var stamps : [Stamp]!
    var stamp : Stamp!
    let locationManager = CLLocationManager()
    let dataProvider = GoogleDataProvider()
    var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var cStampImages : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myNavBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        myNavBar.shadowImage = UIImage()

        mapView.delegate = self
        if stamp.infos.count == 0 {
            coordinate.latitude = -33.868
            coordinate.longitude = 151.2086
        } else {
            if stamp.infos[0].latitude == "" && stamp.infos[0].longitude == "" {
                coordinate.latitude = -33.868
                coordinate.longitude = 151.2086
            }else {
                coordinate.latitude = (stamp.infos[0].latitude).toDouble()!
                coordinate.longitude = (stamp.infos[0].longitude).toDouble()!
            }
            setMapView()
        }
        setBudget()
        setCStampImages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: UICollectionView Datasource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cStampImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCellWithReuseIdentifier("CStampCell", forIndexPath: indexPath) as! CStampCollectionViewCell
        
        cell.cStampImage.image = self.cStampImages[indexPath.item]
        
        return cell
    }
    
    //MARK: UICollectionView Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let clickedImageIndex = indexPath.row + 1
        let stampName = "stamp\(clickedImageIndex).png"
        
        let alertController = UIAlertController(title: "알림", message: "스탬프를 등록하셨습니다 :)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        stamp.setStampName(stampName)
        
        writePlistFile()
    }
    
    //MARK: GMSMapView Delegate
    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        let placeMarker = marker as! PlaceMarker2
        
        if let infoView = UIView.viewFromNibName("MarkerView") as? MarkerView {
            if let photo = placeMarker.place.photo {
                infoView.markerImage.image = photo
            } else {
                infoView.markerImage.image = UIImage(named: "Detailpage_etc.png")
            }
            
            return infoView
        } else {
            return nil
        }
    }
    
    //MARK: General Function
    @IBAction func cancelToStaticsticsVD(segue : UIStoryboardSegue) {
        
    }

    //MARK: General Function
    //각 Budget Label에 데이터 저장
    func setBudget() {
        
        let train = "train"
        let food = "food"
        let landmark = "landmark"
        let hotel = "hotel"
        let ect = "ect"
        
        totalMoneyLabel.text = "\(stamp.getTotalInfosBudget()) 원"
        trafficMoneyLabel.text = "\(stamp.getBudget(train)) 원"
        foodMoneyLabel.text = "\(stamp.getBudget(food)) 원"
        landscapeMoneyLabel.text = "\(stamp.getBudget(landmark)) 원"
        hotelMoneyLabel.text = "\(stamp.getBudget(hotel)) 원"
        etcMoneyLabel.text = "\(stamp.getBudget(ect)) 원"
    }
    
    func setMapView() {
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(coordinate.latitude, longitude: coordinate.longitude, zoom: 12.0)
        
        mapView.camera = camera
    }
    
    func setCStampImages() {
        
        let imageCount = 20
        for index in 1 ... imageCount {
            self.cStampImages.append(UIImage(named: "stamp\(index).png")!)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if self.shouldPerformSegueWithIdentifier("SelectExpand", sender: sender) {
            
            let infosLocationVC = segue.destinationViewController as! InfosLocationMapViewController
            infosLocationVC.stamp = self.stamp
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if identifier == "SelectExpand" {
            
            if self.stamp.infos.isEmpty {
                let alertController = UIAlertController(title: "알림", message: "등록한 여행지가 없습니다 :(", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return false
            } else {
                return true
            }
        }

        return false
    }
}
