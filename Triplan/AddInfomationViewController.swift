//
//  AddInfomationViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 15..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class AddInfomationViewController: UIViewController , CLWeeklyCalendarViewDelegate, UITextFieldDelegate, UITextViewDelegate{

    @IBOutlet weak var myNavBar: UINavigationBar!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var trafficButton: UIButton!
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    var calendarView : CLWeeklyCalendarView!
    // 눌러진 카테고리에 스트링값 저장
    var selectedCategory : String = "train"
    var info : Information!
    // 눌려진 NSDate객체
    var selectedDate : NSDate!
    // infomation이 속한 stamp이름
    var belongedStampName : String!
    var latitude : String! = ""
    var altitude : String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myNavBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        myNavBar.shadowImage = UIImage()

        if !(calendarView != nil) {
            calendarView = CLWeeklyCalendarView(frame: CGRect(x: 0, y: 64.0, width: view.bounds.width, height: 80.0))
        }
        calendarView.delegate = self
        locationTextField.delegate = self
        budgetTextField.delegate = self
        memoTextView.delegate = self
        self.view.addSubview(self.calendarView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - CLCalendar Delegate
    func CLCalendarBehaviorAttributes() -> [NSObject : AnyObject]! {
        return [CLCalendarWeekStartDay : 1]
    }
    
    func dailyCalendarViewDidSelect(date: NSDate!) {
        selectedDate = date
    }
    
    // MARK: - Text Field, View Delegate
    
    //다른 화면을 터치하면 키보드 숨겨짐
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    //텍스트 필드에서 리턴을 눌럿을때 키보드 숨김
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.locationTextField.resignFirstResponder()
        self.budgetTextField.resignFirstResponder()
        
        return true
    }
    
    // textView의 내용이 변할때 메소드
    func textViewDidChange(textView: UITextView) {
        self.memoTextView.textColor = UIColor.blackColor()
    }
    
    // 키보드를 눌럿을때 화면을 위로 올림
    func textViewDidBeginEditing(textView: UITextView) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        self.view.frame = CGRectMake(0,-130,self.view.frame.size.width,self.view.frame.size.height);
        UIView.commitAnimations();
    }
    
    // 다시 화면을 복귀
    func textViewDidEndEditing(textView: UITextView) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        UIView.commitAnimations();

    }

    // MARK: - IBAction function
    @IBAction func touchCategoryButton(sender : AnyObject) {
        
        //눌러진 버튼이미지의 tag값을 저장
        var selectedButton : Int = sender.tag as Int
        
        //버튼 클릭시 이미지 변환까지
        switch selectedButton {
        case 1:
            trafficButton.setImage(UIImage(named: "addpaln_train.png"), forState: UIControlState.Normal)
            foodButton.setImage(UIImage(named: "add_icon_food.png"), forState: UIControlState.Normal)
            cameraButton.setImage(UIImage(named: "add_icon_camera.png"), forState: UIControlState.Normal)
            homeButton.setImage(UIImage(named: "add_icon_home.png"), forState: UIControlState.Normal)
            locationButton.setImage(UIImage(named: "add_icon_spot.png"), forState: UIControlState.Normal)
            selectedCategory = "train"
        case 2:
            trafficButton.setImage(UIImage(named: "add_icon_train.png"), forState: UIControlState.Normal)
            foodButton.setImage(UIImage(named: "addpaln_food.png"), forState: UIControlState.Normal)
            cameraButton.setImage(UIImage(named: "add_icon_camera.png"), forState: UIControlState.Normal)
            homeButton.setImage(UIImage(named: "add_icon_home.png"), forState: UIControlState.Normal)
            locationButton.setImage(UIImage(named: "add_icon_spot.png"), forState: UIControlState.Normal)
            selectedCategory = "food"
        case 3:
            trafficButton.setImage(UIImage(named: "add_icon_train.png"), forState: UIControlState.Normal)
            foodButton.setImage(UIImage(named: "add_icon_food.png"), forState: UIControlState.Normal)
            cameraButton.setImage(UIImage(named: "addpaln_landmark.png"), forState: UIControlState.Normal)
            homeButton.setImage(UIImage(named: "add_icon_home.png"), forState: UIControlState.Normal)
            locationButton.setImage(UIImage(named: "add_icon_spot.png"), forState: UIControlState.Normal)
            selectedCategory = "landmark"
        case 4:
            trafficButton.setImage(UIImage(named: "add_icon_train.png"), forState: UIControlState.Normal)
            foodButton.setImage(UIImage(named: "add_icon_food.png"), forState: UIControlState.Normal)
            cameraButton.setImage(UIImage(named: "add_icon_camera.png"), forState: UIControlState.Normal)
            homeButton.setImage(UIImage(named: "addpaln_hotel.png"), forState: UIControlState.Normal)
            locationButton.setImage(UIImage(named: "add_icon_spot.png"), forState: UIControlState.Normal)
            selectedCategory = "hotel"
        default:
            trafficButton.setImage(UIImage(named: "add_icon_train.png"), forState: UIControlState.Normal)
            foodButton.setImage(UIImage(named: "add_icon_food.png"), forState: UIControlState.Normal)
            cameraButton.setImage(UIImage(named: "add_icon_camera.png"), forState: UIControlState.Normal)
            homeButton.setImage(UIImage(named: "add_icon_home.png"), forState: UIControlState.Normal)
            locationButton.setImage(UIImage(named: "addpaln_ect.png"), forState: UIControlState.Normal)
            selectedCategory = "ect"
        }
    }
    
    // MARK: - Navigation Control
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SaveInfomation" {
            
            if !(budgetTextField.text.toInt() != nil) {
                budgetTextField.text = "0"
            }

            info = Information(
                pStampName: belongedStampName,
                pDateOfInformation: selectedDate,
                pCategory: selectedCategory,
                pLocationTitle: locationTextField.text,
                pBudget: budgetTextField.text.toInt()!,
                pMemo: memoTextView.text,
                pAltitude: altitude,
                pLatitude: latitude)
        }
    }
    
    @IBAction func cancelToAddInformationVC(segue : UIStoryboardSegue) {
        
    }
    
    @IBAction func saveLocation(segue : UIStoryboardSegue) {
        
        let addLocationMapKitVC = segue.sourceViewController as! AddLocationMapKitViewController
        latitude = addLocationMapKitVC.latitude
        altitude = addLocationMapKitVC.altitude
        locationTextField.text = addLocationMapKitVC.autocompleteTextField.text
    }
}