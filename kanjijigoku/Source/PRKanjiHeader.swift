//
//  PRKanjiPageControl.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/23.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRKanjiHeader: UIView {

    var inactiveImagesArray : [UIImage] = []
    var activeImagesArray : [UIImage] = []
    var currentPage: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(kanjis : [Kanji], frame: CGRect) {

        super.init(frame : frame)
        inactiveImagesArray = [UIImage]()
        activeImagesArray = [UIImage]()
        
        for ch in kanjis
        {
            let font = UIFont().appFontOfSize(17.0)
            let kanji :NSAttributedString = NSAttributedString(string: ch.kanji!, attributes: [NSFontAttributeName : font])
            let activeKanji :NSAttributedString = NSAttributedString(string: ch.kanji!, attributes: [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.red])

            
            UIGraphicsBeginImageContextWithOptions(kanji.size(), false, 0.0)
            kanji.draw(at: CGPoint(x: 0.0, y: 0.0))
            inactiveImagesArray.append(UIGraphicsGetImageFromCurrentImageContext()!)
            activeKanji.draw(at: CGPoint(x: 0.0, y: 0.0))
            activeImagesArray.append(UIGraphicsGetImageFromCurrentImageContext()!)
            UIGraphicsEndImageContext()
            
        }

        self.backgroundColor = UIColor.white
        for v in self.subviews  {
            v.removeFromSuperview()
        }
    }
    
    func setupView(_ frame: CGRect)
    {
        for v in self.subviews  {
            v.removeFromSuperview()
        }
        
        for (index, value): (Int, UIImage) in inactiveImagesArray.enumerated()
        {
            let leftMargin : CGFloat = (((1.0 / CGFloat(inactiveImagesArray.count)) * frame.size.width - value.size.width) / 2.0) as CGFloat
            let rect = CGRect(x: frame.origin.x + leftMargin + (CGFloat(index) / CGFloat(inactiveImagesArray.count)) * frame.size.width, y: 10.0, width: value.size.width, height: value.size.height)
            let imgView : UIImageView = UIImageView(frame: rect)
            if index == self.currentPage {
                imgView.image = activeImagesArray[index]
            } else {
                imgView.image = value
            }
            self.addSubview(imgView)
        }
    }
}
