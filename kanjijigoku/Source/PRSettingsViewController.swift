//
//  PRSettingsTableViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/25.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRSettingsViewController: UITableViewController {
    
    var filterController : PRFilterController!
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.view.frame, style:  UITableViewStyle.Grouped)
        let nib = UINib(nibName: "PRFilterCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "PRFilterCell")
        self.navigationItem.title = "Ustawienia"
        self.filterController = PRFilterController()
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Baza danych"
        } else {
            return "Filtr"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("PRFilterCell", forIndexPath: indexPath) as! PRFilterCell
            cell.contentView.userInteractionEnabled = false
            self.filterController.updateWithCell(cell)
            self.filterController?.updateFilterCell(PRStateSingleton.sharedInstance.filterOn)
            return cell
        } else {
            switch(indexPath.row) {
            case 0:
                var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("PRSettingsCell") as UITableViewCell!
                if cell == nil {
                    cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "PRSettingsCell")
                    cell!.selectionStyle = UITableViewCellSelectionStyle.None
                    cell!.contentView.userInteractionEnabled = false
                    cell!.textLabel?.text = "Aktualizacja bazy danych"
                }
                return cell!
            case 1:
                var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("PRSettingsCell") as UITableViewCell!
                if cell == nil {
                    cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "PRSettingsCell")
                    cell!.selectionStyle = UITableViewCellSelectionStyle.Blue
                    
                    cell!.contentView.userInteractionEnabled = false
                    cell!.tintColor = UIColor.whiteColor()
                    
                    let checkmark = UIImageView(image: generateCheckmarkImage())
                    cell!.accessoryView = checkmark
                    cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                    cell!.textLabel?.text = "Automatyczne aktualizacje"
                    cell!.detailTextLabel?.text = "Automatycznie sprawdzaj aktualizacje bazy po uruchomieniu aplikacji, jesli urzadzenie jest polaczone z internetem."
                    cell!.detailTextLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
                    cell!.detailTextLabel?.numberOfLines = 0
                }   
                cell!.accessoryView?.hidden = !NSUserDefaults.standardUserDefaults().boolForKey("PRKanjiJigokuAutoDbUpdate")
                return cell!
            case 2:
                var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("PRSettingsCell") as UITableViewCell!
                if cell == nil
                {
                    cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "PRSettingsCell")
                    cell!.selectionStyle = UITableViewCellSelectionStyle.None
                    cell!.textLabel?.text = "Reset Aplikacji"
                    cell!.detailTextLabel?.text = "Ustawienia aplikacji zostana zresetowane, a baza danych ponownie zaladowana do sieci."
                    cell!.contentView.userInteractionEnabled = false
                    cell!.detailTextLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
                    cell!.detailTextLabel?.numberOfLines = 0
                }
                return cell!
            default:
                let cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("PRSettingsCell") as UITableViewCell!
                return cell!
            }
        }
        
    }
        
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if indexPath.section == 0
        {
            return 70.0
        }
        else
        {
            return 160.0
        }
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                updateDb()
            }
            else if indexPath.row == 1 {
                
                if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    if NSUserDefaults.standardUserDefaults().boolForKey("PRKanjiJigokuAutoDbUpdate") {
                        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "PRKanjiJigokuAutoDbUpdate")
                        cell.accessoryView?.hidden = true
                    } else {
                        cell.accessoryView?.hidden = false
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "PRKanjiJigokuAutoDbUpdate")
                    }
                    NSUserDefaults.standardUserDefaults().synchronize()
                    tableView.reloadData()
                }
            }
            else { // row == 2
                let appDomain = NSBundle.mainBundle().bundleIdentifier
                NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
                updateDb()
            }
        }
        else //section == 1
        {
            
        }
    }

    func updateDb() {
        let backgroundView = UIView(frame: UIScreen.mainScreen().bounds)
        backgroundView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicator.center = self.tableView.center
        backgroundView.addSubview(indicator)
        indicator.startAnimating()
        UIApplication.sharedApplication().keyWindow!.addSubview(backgroundView)
            // do some task
            //PRDatabaseHelper().syncDatabase()
            let operationQueue = NSOperationQueue()
        let importOperation = ImportOperation(remoteImport: false)
            importOperation.completionBlock = {
                    dispatch_async(dispatch_get_main_queue(), {
                        backgroundView.removeFromSuperview()
                        PRDatabaseHelper().loadAppSettings()
                        self.navigationController?.popToRootViewControllerAnimated(false)
                        })
            }
            operationQueue.addOperation(importOperation)
        
        
    }
}
