//
//  InfosLocationMapViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 12. 1..
//  Copyright © 2015년 태현. All rights reserved.
//

import UIKit

class InfosLocationMapViewController: UIViewController , GMSMapViewDelegate , CLLocationManagerDelegate{

    @IBOutlet weak var mapView: GMSMapView!
    var stamp : Stamp!
    var coordinates : [CLLocationCoordinate2D]!
    var displayInfos = [Information]()
    var displayInfosCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        setDisplayInfos()
        setCoordinates()
        setMapView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDisplayInfos() {
        for index in 0..<self.stamp.infos.count {
            if self.stamp.infos[index].latitude != "" || self.stamp.infos[index].longitude != "" {
                displayInfos.append(self.stamp.infos[index])
                displayInfosCount++
            }
        }
    }
    
    func setMapView() {
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(coordinates[0].latitude, longitude: coordinates[0].longitude, zoom: 11.0)
        mapView.camera = camera
        
        for index in 0..<displayInfosCount {
            let marker = GMSMarker(position: self.coordinates[index])
            
            switch displayInfos[index].category {
            case "ect":
                marker.icon = UIImage(named: "addpaln_ect.png")
            case "food":
                marker.icon = UIImage(named: "addpaln_food.png")
            case "hotel":
                marker.icon = UIImage(named: "addpaln_hotel.png")
            case "landmark":
                marker.icon = UIImage(named: "addpaln_landmark.png")
            default:
                marker.icon = UIImage(named: "addpaln_train.png")
            }
            
            marker.title = stamp.infos[index].locationTitle
            marker.map = self.mapView
        }
    }

    func setCoordinates() {
        coordinates = Array()
        
        for index in 0..<self.displayInfosCount {
            coordinates.append(CLLocationCoordinate2D(latitude: Double(displayInfos[index].latitude)!, longitude: Double(displayInfos[index].longitude)!))
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
