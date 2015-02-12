//
//  PRComboBox.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/10.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRComboBox : UITextField
{
    var selectedIndex : Int = 1
    var pickerView : UIPickerView = UIPickerView()

    override init()
    {
        super.init()
        self.inputView = pickerView
        
    }

    required init(coder aDecoder: NSCoder) {
        
        
        super.init(coder: aDecoder)
        self.inputView = pickerView
        
    }
    
    func setPickerTag(tag : Int)
    {
    
        pickerView.tag = tag
    }
    
}


