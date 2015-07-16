//
//  SlidePanelViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 5. 9..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class SlidePanelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTable: UITableView!
    var panelMenu : [PanelMenu] = [];
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //테이블 뷰 경계선 설정
        myTable.separatorStyle = .None
        myTable.backgroundColor = UIColor.clearColor()
        myTable.delegate = self
        myTable.dataSource = self
        
        panelMenu = [PanelMenu(icon: "navi_menu@2x.png", menuName: "App Guide"),
                    PanelMenu(icon: "navi_menu@2x.png", menuName: "Main For Developer"),
                    PanelMenu(icon: "navi_menu@2x.png", menuName: "Review"),
                    PanelMenu(icon: "navi_menu@2x.png", menuName: "About")]
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return panelMenu.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = myTable.dequeueReusableCellWithIdentifier("slidePanelCell", forIndexPath: indexPath) as! SlidePanelCell
        
        cell.iconImageView.image = UIImage(named: "\(panelMenu[indexPath.row].icon)")
        cell.menuLabel.text = "\(panelMenu[indexPath.row].menuName)"
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        dismissViewControllerAnimated(true, completion: nil)
//    }
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        
//        return .LightContent
//    }

    /*
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//정적 프로토타입 셀을 위한 temp class
class PanelMenu {
    
    var icon : String
    var menuName : String
    
    init(icon :String, menuName : String) {
        self.icon = icon
        self.menuName = menuName
    }
}
