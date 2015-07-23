//
//  DetailInformationViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 23..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

class DetailInformationViewController: UIViewController ,GMSMapViewDelegate{
    
    @IBOutlet weak var myNavBar: UINavigationBar!
    @IBOutlet weak var myNavItem: UINavigationItem!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    
    
    var information : Information!
    var coordinate : CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myNavBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        myNavBar.shadowImage = UIImage()
        myNavItem.title = information.stampName
        self.mapView.delegate = self
        
        coordinate = CLLocationCoordinate2D(latitude: (information.latitude).toDouble()!
                                        , longitude: (information.altitude).toDouble()!)
        
        setMapView()
        setLocationAddress(coordinate)
        setOuletValue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setMapView() {
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude((information.latitude).toDouble()!, longitude: (information.altitude).toDouble()!, zoom: 14.0)
        
        mapView.camera = camera
    }
    
    func setOuletValue() {
        
        setCategoryImage(information.category)
        locationNameLabel.text = information.locationTitle
        budgetLabel.text = "\(information.budget) 원"
        memoTextView.text = information.memo
    }
    
    func setLocationAddress(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            
            //Add this line
            if let address = response?.firstResult() {
                let lines = address.lines as! [String]
                self.locationAddressLabel.text = join("\n", lines)
            }
        }
    }
    
    func setCategoryImage(category : String) {
        
        switch category {
        case "train" :
            categoryImageView.image = UIImage(named: "Detailpage_trip.png")
        case "food" :
            categoryImageView.image = UIImage(named: "Detailpage_food.png")
        case "landmark" :
            categoryImageView.image = UIImage(named: "Detailpage_landmark.png")
        case "hotel" :
            categoryImageView.image = UIImage(named: "Detailpage_hotel.png")
        default :
            categoryImageView.image = UIImage(named: "Detailpage_ect.png")
        }
    }
}
