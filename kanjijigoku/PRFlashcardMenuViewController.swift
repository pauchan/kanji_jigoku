//
//  PRFlashcardViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/10.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRFlashcardMenuViewController : UITableViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate
{
    var _tableItems : NSArray

    override init(style: UITableViewStyle) {
        
        if let path = NSBundle.mainBundle().pathForResource("flashcardItems", ofType: "plist") {
            self._tableItems = NSArray(contentsOfFile: path)!
        }
        else
        {
            self._tableItems = []
        }
        super.init(style: style)
    }

    override init() {
        
        if let path = NSBundle.mainBundle().pathForResource("flashcardItems", ofType: "plist") {
            self._tableItems = NSArray(contentsOfFile: path)!
        }
        else
        {
            self._tableItems = []
        }
        super.init()
        
    }

    required init(coder aDecoder: NSCoder) {
        
        if let path = NSBundle.mainBundle().pathForResource("flashcardItems", ofType: "plist") {
            _tableItems = NSArray(contentsOfFile: path)!
        }
        else
        {
            self._tableItems = []
        }
        

        super.init(coder: aDecoder)

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        if let path = NSBundle.mainBundle().pathForResource("flashcardItems", ofType: "plist") {
            _tableItems = NSArray(contentsOfFile: path)!
        }
        else
        {
            self._tableItems = []
        }
        super.init(nibName : nibNameOrNil, bundle : nibBundleOrNil)
    }
    
override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "settings")
    self.navigationItem.title = "Kanji Jigoku"
    // Do any additional setup after loading the view, typically from a nib.
    let nib : UINib = UINib(nibName: "PRHeaderViewCell", bundle: nil)
    self.tableView.registerNib(nib, forCellReuseIdentifier: "PRHeaderViewCell")
    self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PRFlashcardCell")
    self.tableView.tableFooterView = UIView()
    

    
}

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
    if(indexPath.section == 0)
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PRHeaderViewCell", forIndexPath: indexPath) as PRHeaderViewCell
        cell.levelComboBox.pickerView.delegate = self;
        cell.lessonComboBox.pickerView.delegate = self;
        
        cell.levelComboBox.tag = 11
        cell.lessonComboBox.tag = 12
        
        cell.levelComboBox.text = NSString(format:"Poziom: %d", PRStateSingleton.sharedInstance.currentLevel)
        cell.lessonComboBox.text = NSString(format:"Lekcja: %d", PRStateSingleton.sharedInstance.currentLesson)
    
        return cell
        
    }
        else
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PRFlashcardCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = _tableItems[indexPath.row] as? String
        return cell
    }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(indexPath.section == 0)
        {
            return 80.0
        }
        else
        {
            return 45.0
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
    if(section == 0)
    {
        return 1
    }
    else
    {
        return _tableItems.count
    }
}
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
//        if(pickerView.tag == 11)
//        {
//            let ret : NSString = NSString(format: "Poziom %d", arguments: PRStateSingleton.sharedInstance.currentLevel)
//            return String
//        }
//        else
//        {
//        
//            return CString(format: "Poziom %d", arguments: PRStateSingleton.sharedInstance.currentLevel)
//        }
//    }
    
}