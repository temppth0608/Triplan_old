//
//  ExpandMapViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 23..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class ExpandMapViewController: UIViewController ,GMSMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var coordinate : CLLocationCoordinate2D!
    var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    
    let locationManager = CLLocationManager()
    let dataProvider = GoogleDataProvider()

    var randomLineColor: UIColor {
        get {
            let randomRed = CGFloat(drand48())
            let randomGreen = CGFloat(drand48())
            let randomBlue = CGFloat(drand48())
            return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        }
    }
    
    var mapRadius: Double {
        get {
            let region = mapView.projection.visibleRegion()
            let verticalDistance = GMSGeometryDistance(region.farLeft, region.nearLeft)
            let horizontalDistance = GMSGeometryDistance(region.farLeft, region.farRight)
            return max(horizontalDistance, verticalDistance)*0.5
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self

        setMapView()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        // 1
        mapView.clear()
        // 2
        dataProvider.fetchPlacesNearCoordinate(self.coordinate, radius:mapRadius, types: searchedTypes) { places in
            for place: GooglePlace in places {
                // 3
                let marker = PlaceMarker(place: place)
                // 4
                marker.map = self.mapView
            }
        }
    }

    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        // 1
        let placeMarker = marker as! PlaceMarker
        
        // 2

        if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
            // 3
            infoView.nameLabel.text = placeMarker.place.name
            
            // 4
            if let photo = placeMarker.place.photo {
                infoView.placePhoto.image = photo
            } else {
                infoView.placePhoto.image = UIImage(named: "generic")
            }
            
            return infoView
        } else {
            return nil
        }
    }
    
    // 1
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 2
        if status == .AuthorizedWhenInUse {
            
            // 3
            locationManager.startUpdatingLocation()
            
            //4
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        return false
    }
    
    // 5
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        mapView.camera = GMSCameraPosition(target: self.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
        // 7
        //locationManager.stopUpdatingLocation()
        fetchNearbyPlaces(self.coordinate)
        
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        // 1
        let googleMarker = mapView.selectedMarker as! PlaceMarker
        
        // 2
        dataProvider.fetchDirectionsFrom(mapView.myLocation.coordinate, to: googleMarker.place.coordinate) {optionalRoute in
            if let encodedRoute = optionalRoute {
                // 3
                let path = GMSPath(fromEncodedPath: encodedRoute)
                let line = GMSPolyline(path: path)
                
                // 4
                line.strokeWidth = 4.0
                line.tappable = true
                line.map = self.mapView
                line.strokeColor = self.randomLineColor
                
                // 5
                mapView.selectedMarker = nil
            }
        }
    }
    
    func didTapMyLocationButtonForMapView(mapView: GMSMapView!) -> Bool {
        mapView.selectedMarker = nil
        return false
    }
    
    func setMapView() {
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(self.coordinate.latitude, longitude: self.coordinate.longitude, zoom: 14.0)
        
        mapView.camera = camera
    }
    
    @IBAction func segmentChanged(sender: AnyObject) {
        
        let segmentedControl = sender as! UISegmentedControl
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = kGMSTypeNormal
        case 1:
            mapView.mapType = kGMSTypeSatellite
        case 2:
            mapView.mapType = kGMSTypeHybrid
        default:
            mapView.mapType = mapView.mapType
        }
    }
}
