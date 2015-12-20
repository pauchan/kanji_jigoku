//
//  PRColor.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/18.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

extension UIColor
{
    func appColor() -> UIColor
    {
        return UIColor.flatGreenColorDark()
    }
    
    
    // a little bit pale
    func brightOrangeColor() -> UIColor
    {
        return UIColor(red: 1.0, green: 136.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    }
    
    // f08313 more fresh that the previous one
    func liveOrangeColor() -> UIColor
    {
        return UIColor(red: 240.0/255.0, green: 131.0/255.0, blue: 19.0/255.0, alpha: 1.0)
    }

    // fcd364 more fresh that the previous one
    func transparentOrangeColor() -> UIColor
    {
        return UIColor(red: 252.0/255.0, green: 211.0/255.0, blue: 100.0/255.0, alpha: 1.0)
    }
    
    func fadedOrangeColor() -> UIColor
    {
        
        return UIColor(red: 1.0, green:211.0/255.0, blue:190.0/255.0, alpha:0.95)
    }
    
    func lightGreenColor() -> UIColor
    {
        
        return UIColor(red: 160.0/255.0, green:219.0/255.0, blue:202.0/255.0, alpha:0.4)
    }
    
    func lightGrayColor() -> UIColor
    {
        return UIColor(red: 179.0/255.0, green:179.0/255.0, blue:180.0/255.0, alpha:1.0)
    }

}