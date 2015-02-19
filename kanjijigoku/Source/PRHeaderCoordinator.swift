//
//  PRHeaderCoordinator.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/19.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRHeaderCoordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var headerCell : PRHeaderViewCell!
    var levelPickerView = UIPickerView()
    var lessonPickerView = UIPickerView()
    
    
    
    init(headerCell : PRHeaderViewCell) {
        
        
        self.headerCell = headerCell
        
        self.headerCell.levelComboBox?.inputView = levelPickerView
        self.headerCell.lessonComboBox?.inputView = lessonPickerView
        
        self.headerCell.levelComboBox?.text = "Poziom \(PRStateSingleton.sharedInstance.currentLevel)"
        self.headerCell.lessonComboBox?.text = "Lekcja \(PRStateSingleton.sharedInstance.currentLesson)"
        
        super.init()
        
        levelPickerView.delegate = self
        lessonPickerView.delegate = self
        
    }
    

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == levelPickerView
        {
            return PRStateSingleton.sharedInstance.levelArray.count
        }
        else
        {
            return PRStateSingleton.sharedInstance.lessonArray.count
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        if pickerView == levelPickerView
        {
            return "Poziom \(PRStateSingleton.sharedInstance.levelArray[row])"
        }
        else
        {
            return "Lekcja \(PRStateSingleton.sharedInstance.lessonArray[row])"
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == levelPickerView
        {
            self.headerCell.levelComboBox?.text = "Poziom \(PRStateSingleton.sharedInstance.levelArray[row])"
            PRStateSingleton.sharedInstance.currentLevel = PRStateSingleton.sharedInstance.levelArray[row]
            self.headerCell.lessonComboBox?.becomeFirstResponder()
        }
        else
        {
            self.headerCell.lessonComboBox?.text = "Lekcja \(PRStateSingleton.sharedInstance.lessonArray[row])"
            PRStateSingleton.sharedInstance.currentLesson = PRStateSingleton.sharedInstance.lessonArray[row]
            self.headerCell.lessonComboBox?.resignFirstResponder()
        }
        
    }
    
    
    
}
