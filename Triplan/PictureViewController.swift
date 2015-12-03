//
//  PictureViewController.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 26..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController ,UIScrollViewDelegate{

    @IBOutlet weak var imageScrollView: UIScrollView!
    
    var pageImages : [UIImage] = []
    var pageViews : [UIImageView?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageScrollView.delegate = self;
        
        imageScrollView.showsHorizontalScrollIndicator = false;
        imageScrollView.showsVerticalScrollIndicator = false;

        // Do any additional setup after loading the view.
        let pageCount = pageImages.count;
        
        for _ in 0..<pageCount {
            pageViews.append(nil);
        }
        
        let pagesScrollViewSize = imageScrollView.frame.size;
        imageScrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count), height: pagesScrollViewSize.height)
        
        loadVisiblePages();
    }
    
    func loadPage(page:Int) {
        if page < 0 || page >= pageImages.count {
            return;
        }
        
        if let _ = pageViews[page] {
            
        }else {
            var frame = imageScrollView.bounds;
            frame.origin.x = frame.size.width * CGFloat(page);
            frame.origin.y = 0.0;
            
            let newPageView = UIImageView(image: pageImages[page]);
            //newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame;
            
            imageScrollView.addSubview(newPageView);
            
            pageViews[page] = newPageView;
        }
    }
    
    func purgePage(page:Int) {
        if page < 0 || page >= pageImages.count {
            return;
        }
        
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview();
            pageViews[page] = nil;
        }
    }
    
    func loadVisiblePages() {
        let pageWidth = imageScrollView.frame.size.width;
        let page = Int(floor((imageScrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)));
        
        let firstPage = page - 1;
        let lastPage = page + 1;
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for var index = firstPage; index <= lastPage; ++index {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        loadVisiblePages();
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
