//
//  DetailInformationViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 23..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit
import Photos

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

class DetailInformationViewController: UIViewController ,GMSMapViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegate {
    
    @IBOutlet weak var myNavBar: UINavigationBar!
    @IBOutlet weak var myNavItem: UINavigationItem!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var information : Information!
    var coordinate : CLLocationCoordinate2D!
    var imagePickerController = UIImagePickerController()
    var images : [UIImage]!
    var totalImageCountNeeded:Int! // <-- The number of images to fetch
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        myNavBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        myNavBar.shadowImage = UIImage()
        myNavItem.title = information.stampName
        
        self.mapView.delegate = self
        
        if !((information.latitude).toDouble() != nil) {
            coordinate = CLLocationCoordinate2D(
                latitude: -33.868 ,
                longitude: 151.2086
            )
        } else if !((information.longitude).toDouble() != nil) {
            coordinate = CLLocationCoordinate2D(
                latitude: -33.868 ,
                longitude: 151.2086
            )
        } else {
            coordinate = CLLocationCoordinate2D(
                latitude: (information.latitude).toDouble()! ,
                longitude: (information.longitude).toDouble()!
            )
            setMapView()
        }
        
        fetchPhotos()
        setLocationAddress(coordinate)
        setOuletValue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - CollectionView DataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCellWithReuseIdentifier("PictureCell", forIndexPath: indexPath) as! PictureCollectionViewCell
        
        cell.pictureImageView.image = images[indexPath.item]
        
        return cell
    }

    // MARK: - CollectionView Delegate
    
    // MARK: - General Function
    func fetchPhotos () {
        images = []
        totalImageCountNeeded = 10
        self.fetchPhotoAtIndexFromEnd(0)
    }
    
    // Repeatedly call the following method while incrementing
    // the index until all the photos are fetched
    func fetchPhotoAtIndexFromEnd(index:Int) {
        
        let imgManager = PHImageManager.defaultManager()
        
        // Note that if the request is not set to synchronous
        // the requestImageForAsset will return both the image
        // and thumbnail; by setting synchronous to true it
        // will return just the thumbnail
        let requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        
        // Sort the images by creation date
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        let fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
            
        // If the fetch result isn't empty,
        // proceed with the image request
        if fetchResult.count > 0 {
        // Perform the image request
            imgManager.requestImageForAsset(fetchResult.objectAtIndex(fetchResult.count - 1 - index) as! PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.AspectFill, options: requestOptions, resultHandler: { (image, _) in
            // Add the returned image to your array
                self.images.append(image!)
                if index + 1 < fetchResult.count && self.images.count < self.totalImageCountNeeded {
                    self.fetchPhotoAtIndexFromEnd(index + 1)
                } else {
                    // Else you have completed creating your array
                }
            })
        }
    }
    
    func setMapView() {
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude((information.latitude).toDouble()!, longitude: (information.longitude).toDouble()!, zoom: 14.0)
        
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
                self.locationAddressLabel.text = lines.joinWithSeparator("\n")
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
            categoryImageView.image = UIImage(named: "Detailpage_etc.png")
        }
    }
    
    // MARK: - IBAction function
    @IBAction func cancelToDetailInformationVC(segue : UIStoryboardSegue) {
        
    }
    
    // MARK: - Navigation Controll
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SelectExpand" {
            
            let expandMapVC = segue.destinationViewController as! ExpandMapViewController
            expandMapVC.coordinate = self.coordinate
        } else if segue.identifier == "SelectPicture"{
            
            let pictureVC = segue.destinationViewController as! PictureViewController
            
            for index in 0 ..< images.count {
                pictureVC.pageImages.append(images[index])
            }
        }
    }
}
