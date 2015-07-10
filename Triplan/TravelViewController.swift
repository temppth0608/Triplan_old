//
//  TravelViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 5..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class TravelViewController: UIViewController {
    
    @IBOutlet weak var myNavBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        myNavBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        myNavBar.shadowImage = UIImage()
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
