//
//  DetailInformationViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 23..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class DetailInformationViewController: UIViewController {
    
    @IBOutlet weak var myNavBar: UINavigationBar!
    @IBOutlet weak var myNavItem: UINavigationItem!
    
    var information : Information!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myNavBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        myNavBar.shadowImage = UIImage()
        myNavItem.title = information.stampName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
