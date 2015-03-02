//
//  PRFilterController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/03/02.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRFilterController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {

    
    @IBOutlet weak var levelComboBox: UITextField!
    @IBOutlet weak var lessonComboBox: UITextField!
    var levelPickerView = UIPickerView()
    var lessonPickerView = UIPickerView()
    
    
    override init() {
        
        
        self.levelComboBox?.inputView = levelPickerView
        self.lessonComboBox?.inputView = lessonPickerView
        
        super.init()
        
        levelPickerView.delegate = self
        lessonPickerView.delegate = self
        
    }

    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.levelComboBox?.inputView = levelPickerView
        self.lessonComboBox?.inputView = lessonPickerView
        
        levelPickerView.delegate = self
        lessonPickerView.delegate = self
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.levelComboBox?.inputView = levelPickerView
        self.lessonComboBox?.inputView = lessonPickerView
        
        levelPickerView.delegate = self
        lessonPickerView.delegate = self
    }
    
    
    
    @IBAction func filterSwitch(sender: UISwitch) {
        
        
        if sender.on
        {
            PRStateSingleton.sharedInstance.filterOn = true
            PRStateSingleton.sharedInstance.filterLevel = PRStateSingleton.sharedInstance.currentLevel
            PRStateSingleton.sharedInstance.filterLesson = PRStateSingleton.sharedInstance.currentLesson
            
            self.levelComboBox?.text = "Poziom \(PRStateSingleton.sharedInstance.currentLevel)"
            self.lessonComboBox?.text = "Lekcja \(PRStateSingleton.sharedInstance.currentLesson)"
        
            levelComboBox.enabled = true
            lessonComboBox.enabled = true
            
            
        }
        else
        {
            PRStateSingleton.sharedInstance.filterOn = false
        
            levelComboBox.enabled = false
            lessonComboBox.enabled = false
            levelComboBox.text = ""
            lessonComboBox.text = ""
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
    self.levelComboBox?.text = "Poziom \(PRStateSingleton.sharedInstance.levelArray[row])"
    PRStateSingleton.sharedInstance.currentLevel = PRStateSingleton.sharedInstance.levelArray[row]
    self.lessonComboBox?.becomeFirstResponder()
    }
    else
    {
    self.lessonComboBox?.text = "Lekcja \(PRStateSingleton.sharedInstance.lessonArray[row])"
    PRStateSingleton.sharedInstance.currentLesson = PRStateSingleton.sharedInstance.lessonArray[row]
    self.lessonComboBox?.resignFirstResponder()
    }
    
    }
    
}
