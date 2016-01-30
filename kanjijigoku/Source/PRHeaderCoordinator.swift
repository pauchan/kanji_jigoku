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

        super.init()
        
        self.headerCell = headerCell
        
        self.headerCell.levelComboBox?.inputView = levelPickerView
        self.headerCell.lessonComboBox?.inputView = lessonPickerView
        
        self.headerCell.extraMaterialSwitch?.addTarget(self, action: "enableMaterial:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.updateHeaderState()
        
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
    
    func generateLessonSummaryString(level: Int, lesson: Int) -> String
    {
    
    let arr : [Kanji]  = PRDatabaseHelper().getSelectedObjects("Kanji", level: level, lesson: lesson) as! [Kanji]
        let bla : String =  arr.map
            {
                (kanji: Kanji) -> String in kanji.kanji!
            }.reduce("")
            {
                (base,append) in base + append + " "
            }
        return bla
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
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
            labView!.text = "Lekcja \(PRStateSingleton.sharedInstance.lessonArray[row]): \(generateLessonSummaryString(PRStateSingleton.sharedInstance.currentLevel, lesson: PRStateSingleton.sharedInstance.lessonArray[row]))"
        }
        
        return labView!
    }
    
    func enableMaterial(sender: AnyObject) {
    
        PRStateSingleton.sharedInstance.extraMaterial = self.headerCell.extraMaterialSwitch!.on
    }
    
    func updateHeaderState() {
    
        self.headerCell.levelComboBox?.text = "Poziom \(PRStateSingleton.sharedInstance.currentLevel)"
        self.headerCell.lessonComboBox?.text = "Lekcja \(PRStateSingleton.sharedInstance.currentLesson)"
        self.headerCell.extraMaterialSwitch?.on = PRStateSingleton.sharedInstance.extraMaterial
    }
    
}
