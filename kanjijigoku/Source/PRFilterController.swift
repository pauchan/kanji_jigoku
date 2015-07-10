//
//  PRFilterController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/03/02.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRFilterController: NSObject, UIPickerViewDataSource, UIPickerViewDelegate  {

    
    var levelPickerView = UIPickerView()
    var lessonPickerView = UIPickerView()
    
    var filterCell : PRFilterCell! // = PRFilterCell()
    
    init(filterCell: PRFilterCell)
    {
        self.filterCell = filterCell
        
        self.filterCell.levelComboBox?.inputView = levelPickerView
        self.filterCell.lessonComboBox?.inputView = lessonPickerView
        
        super.init()
        
        levelPickerView.delegate = self
        lessonPickerView.delegate = self
        
        self.filterCell.filterSwitch?.addTarget(self, action: "filterSwitch:", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func filterSwitch(sender: UISwitch) {
        
        
        if sender.on
        {
            PRStateSingleton.sharedInstance.filterOn = true
            PRStateSingleton.sharedInstance.filterLevel = PRStateSingleton.sharedInstance.filterLevel
            PRStateSingleton.sharedInstance.filterLesson = PRStateSingleton.sharedInstance.filterLesson
            
            self.filterCell.levelComboBox?.text = "Poziom \(PRStateSingleton.sharedInstance.filterLevel)"
            self.filterCell.lessonComboBox?.text = "Lekcja \(PRStateSingleton.sharedInstance.filterLesson)"
        
            filterCell.levelComboBox.enabled = true
            filterCell.lessonComboBox.enabled = true
            
            
        }
        else
        {
            PRStateSingleton.sharedInstance.filterOn = false
        
            filterCell.levelComboBox.enabled = false
            filterCell.lessonComboBox.enabled = false
            filterCell.levelComboBox.text = ""
            filterCell.lessonComboBox.text = ""
        }
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
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
    if pickerView == levelPickerView {
        
        self.filterCell.levelComboBox?.text = "Poziom \(PRStateSingleton.sharedInstance.levelArray[row])"
        PRStateSingleton.sharedInstance.filterLevel = PRStateSingleton.sharedInstance.levelArray[row]
        self.filterCell.lessonComboBox?.becomeFirstResponder()
    }
    else {
        self.filterCell.lessonComboBox?.text = "Lekcja \(PRStateSingleton.sharedInstance.lessonArray[row])"
        PRStateSingleton.sharedInstance.filterLesson = PRStateSingleton.sharedInstance.lessonArray[row]
        self.filterCell.lessonComboBox?.resignFirstResponder()
    }
    }
    
    
    func generateLessonSummaryString(level: Int, lesson: Int) -> String
    {
        
        let arr : [Character]  = PRDatabaseHelper().getSelectedObjects("Character", level: level, lesson: lesson) as! [Character]
        var bla : String =  arr.map
            {
                (kanji: Character) -> String in kanji.kanji
            }.reduce("")
                {
                    (base,append) in base + append + " "
        }
        return bla
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        var labView : UILabel? = view as? UILabel
        
        if labView == nil
        {
            labView = UILabel()
            labView?.textAlignment = NSTextAlignment.Center
            if pickerView == lessonPickerView
            {
                labView!.font = UIFont().appFontOfSize(14.0)
            }
        }
        if pickerView == levelPickerView
        {
            labView!.text = "Poziom \(PRStateSingleton.sharedInstance.levelArray[row])"
        }
        else
        {
            labView!.text = "Lekcja \(PRStateSingleton.sharedInstance.lessonArray[row]): \(generateLessonSummaryString(PRStateSingleton.sharedInstance.filterLevel, lesson: PRStateSingleton.sharedInstance.lessonArray[row]))"
        }
        
        return labView!
    }

    
}
