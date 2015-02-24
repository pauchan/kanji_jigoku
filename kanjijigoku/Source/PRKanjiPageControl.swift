//
//  PRKanjiPageControl.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/23.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRKanjiPageControl: UIPageControl {

    var inactiveImagesArray : [UIImage]!
    var activeImagesArray : [UIImage]!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        
        
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {

        
        super.init(coder: aDecoder)
    }

    init(kanjis : [Character], frame : CGRect) {

        super.init()
        self.numberOfPages = kanjis.count
        self.currentPage = 0
        var imgArray : [UIImageView] = [UIImageView]()
        for ch in kanjis
        {
            let font = UIFont(name: "Helvetica", size: 17.0)
            let kanji :NSAttributedString = NSAttributedString(string: ch.kanji, attributes: [NSFontAttributeName : font!])

            //let size = kanji.sizeWithAttributes()
            let size = kanji.size()
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            kanji.drawAtPoint(CGPointMake(0.0, 0.0)) //, withAttributes: [NSFontAttributeName : font!])
            let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if((find(kanjis, ch) != nil && self.subviews.count > find(kanjis, ch))){
                let index : Int = find(kanjis, ch)!
                let obj : UIView = self.subviews[index] as UIView
                var rect = obj.frame
                rect.origin.x = frame.origin.x + (CGFloat(index) / CGFloat(self.subviews.count)) * frame.size.width
                rect.size = size
                var imgView : UIImageView = UIImageView(frame: rect)
                imgView.image = image
                imgArray.append(imgView)
            }
        }
        for v in self.subviews as [UIView]
        {
            v.removeFromSuperview()
        }
        
        for v : UIView in imgArray
        {
            self.addSubview(v)
        }
        
        //self.subviews = imgArray as [AnyObject]
    }
    
}
