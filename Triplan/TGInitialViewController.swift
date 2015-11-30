//
//  TGInitialViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 19..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class TGInitialViewController: UIViewController ,TGCameraDelegate{

    @IBOutlet weak var photoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TGCamera.setOption(kTGCameraOptionSaveImageToAlbum, value: true)
        photoView.clipsToBounds = false
        let clearButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "clearTapped")
        self.navigationItem.rightBarButtonItem = clearButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TGCameraDelegate required
    func cameraDidCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cameraDidTakePhoto(image: UIImage!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cameraDidSelectAlbumPhoto(image: UIImage!) {
        photoView.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - TGCameraDelegate optional
    
    func cameraWillTakePhoto() {
        
    }
    func cameraDidSavePhotoAtPath(assetURL: NSURL!) {
        
    }
    
    func cameraDidSavePhotoWithError(error: NSError!) {
        
    }
    
    // MARK: - general function
    func clearTapped() {
        photoView.image = nil
    }
    
    // MARK: - IBAction function
    @IBAction func takePhotoTapped(sender: AnyObject) {
        let navigationController = TGCameraNavigationController.newWithCameraDelegate(self)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
}
