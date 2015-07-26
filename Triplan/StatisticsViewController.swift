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
            
        } else {
            coordinate.latitude = (stamp.infos[0].latitude).toDouble()!
            coordinate.longitude = (stamp.infos[0].altitude).toDouble()!
            setMapView()
        }
        setBudget()
        
        for i in 0 ..< 10 {
            setCStampImages()
        }
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
        
        let cell = myCollectionView.dequeueReusableCellWithReuseIdentifier("CStampCell", forIndexPath: indexPath) as! CStampCollectionViewCell
        
        
    }
    
    //MARK: GMSMapView Delegate
    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        // 1
        let placeMarker = marker as! PlaceMarker2
        
        print("a")
        // 2
        
        if let infoView = UIView.viewFromNibName("MarkerView") as? MarkerView {

            // 4
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
    
    func setMapView() {
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(coordinate.latitude, longitude: coordinate.longitude, zoom: 12.0)
        
        mapView.camera = camera
    }
    
    func setCStampImages() {
        
        cStampImages.append(UIImage(named: "CStamp_example.png")!)
    }
}
