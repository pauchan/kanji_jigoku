
//
//  File.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/16.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRPickerDataSource : NSObject, UIPickerViewDataSource, UIPickerViewDelegate
{
    
    var sourceArray = [Int]()
    var additionalLabel = String()
    var selectedItem = 0

    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {

            return sourceArray.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        if pickerView.tag == 11
        {
            return "\(additionalLabel) \(sourceArray[row])"
        }
        else
        {
            return "\(additionalLabel) \(sourceArray[row])"
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedItem = sourceArray[row]
        pickerView.resignFirstResponder()
    }
    


}