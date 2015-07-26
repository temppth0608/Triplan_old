//
//  PictureViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 26..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        // Do any additional setup after loading the view.
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
