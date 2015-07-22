//
//  AddLocationMapKitViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 18..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class AddLocationMapKitViewController: UIViewController ,GooglePlacesAutocompleteDelegate{
    
    let gpaViewController = GooglePlacesAutocomplete(apiKey:"AIzaSyD6Bf1UeEtmiehMzRibwmig5YJLOYps6lU", placeType: .Address)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        gpaViewController.placeDelegate = self
        presentViewController(gpaViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension AddLocationMapKitViewController: GooglePlacesAutocompleteDelegate {
    func placeSelected(place: Place) {
        println(place.description)
        
        place.getDetails { details in
            println(details)
        }
    }
    
    func placeViewClosed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
