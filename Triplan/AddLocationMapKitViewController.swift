//
//  AddLocationMapKitViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 18..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit
import MapKit

class AddLocationMapKitViewController: UIViewController ,NSURLConnectionDataDelegate{
    
    @IBOutlet weak var autocompleteTextField: AutoCompleteTextField!
    @IBOutlet weak var mapView: MKMapView!
    
    private var responseData:NSMutableData?
    private var selectedPointAnnotation:MKPointAnnotation?
    private var connection:NSURLConnection?
    
    private let googleMapsKey = "AIzaSyD6Bf1UeEtmiehMzRibwmig5YJLOYps6lU"
    private let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"

    var latitude : String = ""
    var longitude : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField()
        handleTextFieldInterfaces()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureTextField(){
        autocompleteTextField.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        autocompleteTextField.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        autocompleteTextField.autoCompleteCellHeight = 35.0
        autocompleteTextField.maximumAutoCompleteCount = 20
        autocompleteTextField.hidesWhenSelected = true
        autocompleteTextField.hidesWhenEmpty = true
        autocompleteTextField.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        autocompleteTextField.autoCompleteAttributes = attributes
    }
    
    private func handleTextFieldInterfaces(){
        autocompleteTextField.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if self!.connection != nil{
                    self!.connection!.cancel()
                    self!.connection = nil
                }
                let urlString = "\(self!.baseURLString)?key=\(self!.googleMapsKey)&input=\(text)"
                let url = NSURL(string: urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
                if url != nil{
                    let urlRequest = NSURLRequest(URL: url!)
                    self!.connection = NSURLConnection(request: urlRequest, delegate: self)
                } else if url == nil {
                    
                }
            }
        }
        
        autocompleteTextField.onSelect = {[weak self] text, indexpath in
            Location.geocodeAddressString(text, completion: { (placemark, error) -> Void in
                if placemark != nil{
                    let coordinate = placemark!.location!.coordinate
                    self?.latitude = coordinate.latitude.description
                    self?.longitude = coordinate.longitude.description
                    self!.addAnnotation(coordinate, address: text)
                    self!.mapView.setCenterCoordinate(coordinate, zoomLevel: 11, animated: true)
                }
            })
        }
    }
    
    
    //MARK: NSURLConnectionDelegate
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        responseData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        responseData?.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        if responseData != nil{
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(responseData!, options: [])
                let status = result["status"] as? String
                if status == "OK" {
                    if let predictions = result["predictions"] as? NSArray{
                        var locations = [String]()
                        for dict in predictions as! [NSDictionary]{
                            locations.append(dict["description"] as! String)
                        }
                        self.autocompleteTextField.autoCompleteStrings = locations
                    }
                }
            } catch _ {
                
            }
        }
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
    
    //MARK: Map Utilities
    private func addAnnotation(coordinate:CLLocationCoordinate2D, address:String?){
        if selectedPointAnnotation != nil{
            mapView.removeAnnotation(selectedPointAnnotation!)
        }
        
        selectedPointAnnotation = MKPointAnnotation()
        selectedPointAnnotation?.coordinate = coordinate
        selectedPointAnnotation?.title = address
        mapView.addAnnotation(selectedPointAnnotation!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SaveLocation" {
            
        }
    }
}


