//
//  PRKanjiPageControl.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/23.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRKanjiHeader: UIView {

    var inactiveImagesArray : [UIImage]!
    var activeImagesArray : [UIImage]!
    
    override init(frame: CGRect) {
        
        
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {

        
        super.init(coder: aDecoder)
    }

    init(kanjis : [Kanji], frame: CGRect) {

        super.init(frame : frame)
        
        inactiveImagesArray = [UIImage]()
        activeImagesArray = [UIImage]()

        
        for ch in kanjis
        {
            let font = UIFont().appFontOfSize(17.0)
            let kanji :NSAttributedString = NSAttributedString(string: ch.kanji, attributes: [NSFontAttributeName : font])
            let activeKanji :NSAttributedString = NSAttributedString(string: ch.kanji, attributes: [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.redColor()])

            
            UIGraphicsBeginImageContextWithOptions(kanji.size(), false, 0.0)
            kanji.drawAtPoint(CGPointMake(0.0, 0.0)) //, withAttributes: [NSFontAttributeName : font!])
            inactiveImagesArray.append(UIGraphicsGetImageFromCurrentImageContext())
            activeKanji.drawAtPoint(CGPointMake(0.0, 0.0))
            activeImagesArray.append(UIGraphicsGetImageFromCurrentImageContext())
            UIGraphicsEndImageContext()
            
        }

        self.backgroundColor = UIColor.whiteColor()
        for v in self.subviews as! [UIView]
        {
            v.removeFromSuperview()
        }
        
    }
    
    func setupView(frame: CGRect)
    {
        for v in self.subviews as! [UIView]
        {
            v.removeFromSuperview()
        }
        
        for (index, value : UIImage) in enumerate(inactiveImagesArray)
        {
            let leftMargin : CGFloat = (((1.0 / CGFloat(inactiveImagesArray.count)) * frame.size.width - value.size.width) / 2.0) as CGFloat
            //let leftMargin :CGFloat = (frame.size.width - value.size.width*CGFloat(inactiveImagesArray.count))/2.0 as! CGFloat
            let rect = CGRectMake(frame.origin.x + leftMargin + (CGFloat(index) / CGFloat(inactiveImagesArray.count)) * frame.size.width, 10.0, value.size.width, value.size.height)
            var imgView : UIImageView = UIImageView(frame: rect)
//            if index == self.currentPage
//            {
//                imgView.image = activeImagesArray[index]
//            }
//            else
//            {
//                imgView.image = value
//            }
            self.addSubview(imgView)
        }
        
    }
    
}
