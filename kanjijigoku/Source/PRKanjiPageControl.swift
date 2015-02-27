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
    //var activeImagesArray : [UIImage]!
    
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

    init(kanjis : [Character], frame: CGRect) {

        super.init(frame : frame)
        
        inactiveImagesArray = [UIImage]()
        
        self.numberOfPages = kanjis.count
        self.currentPage = 0

        for ch in kanjis
        {
            let font = UIFont(name: "Helvetica", size: 17.0)
            let kanji :NSAttributedString = NSAttributedString(string: ch.kanji, attributes: [NSFontAttributeName : font!])
            
            UIGraphicsBeginImageContextWithOptions(kanji.size(), false, 0.0)
            kanji.drawAtPoint(CGPointMake(0.0, 0.0)) //, withAttributes: [NSFontAttributeName : font!])
            inactiveImagesArray.append(UIGraphicsGetImageFromCurrentImageContext())
            UIGraphicsEndImageContext()
            
        }
        for v in self.subviews as [UIView]
        {
            v.removeFromSuperview()
        }
        self.backgroundColor = UIColor.whiteColor()
        
    }
    
    func setupView(frame: CGRect)
    {
        for (index, value : UIImage) in enumerate(inactiveImagesArray)
        {
            let rect = CGRectMake(frame.origin.x + (CGFloat(index) / CGFloat(inactiveImagesArray.count)) * frame.size.width, 10.0, value.size.width, value.size.height)
            var imgView : UIImageView = UIImageView(frame: rect)
            imgView.image = value
            self.addSubview(imgView)
        }
        
    }
    
}
