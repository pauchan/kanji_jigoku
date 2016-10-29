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
        self.tableView = UITableView(frame: self.view.frame, style:  UITableViewStyle.grouped)
        let nib = UINib(nibName: "PRFilterCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "PRFilterCell")
        self.navigationItem.title = "Ustawienia"
        self.filterController = PRFilterController()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Baza danych"
        } else {
            return "Filtr"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PRFilterCell", for: indexPath) as! PRFilterCell
            cell.contentView.isUserInteractionEnabled = false
            self.filterController.updateWithCell(cell)
            self.filterController?.updateFilterCell(PRStateSingleton.sharedInstance.filterOn)
            return cell
        } else {
            switch((indexPath as NSIndexPath).row) {
            case 0:
                var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "PRSettingsCell") as UITableViewCell!
                if cell == nil {
                    cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "PRSettingsCell")
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell!.contentView.isUserInteractionEnabled = false
                    cell!.textLabel?.text = "Aktualizacja bazy danych"
                }
                return cell!
            case 1:
                var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "PRSettingsCell") as UITableViewCell!
                if cell == nil {
                    cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "PRSettingsCell")
                    cell!.selectionStyle = UITableViewCellSelectionStyle.blue
                    
                    cell!.contentView.isUserInteractionEnabled = false
                    cell!.tintColor = UIColor.white
                    
                    let checkmark = UIImageView(image: generateCheckmarkImage())
                    cell!.accessoryView = checkmark
                    cell!.accessoryType = UITableViewCellAccessoryType.checkmark
                    cell!.textLabel?.text = "Automatyczne aktualizacje"
                    cell!.detailTextLabel?.text = "Automatycznie sprawdzaj aktualizacje bazy po uruchomieniu aplikacji, jesli urzadzenie jest polaczone z internetem."
                    cell!.detailTextLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                    cell!.detailTextLabel?.numberOfLines = 0
                }   
                cell!.accessoryView?.isHidden = !UserDefaults.standard.bool(forKey: "PRKanjiJigokuAutoDbUpdate")
                return cell!
            case 2:
                var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "PRSettingsCell") as UITableViewCell!
                if cell == nil
                {
                    cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "PRSettingsCell")
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell!.textLabel?.text = "Reset Aplikacji"
                    cell!.detailTextLabel?.text = "Ustawienia aplikacji zostana zresetowane, a baza danych ponownie zaladowana do sieci."
                    cell!.contentView.isUserInteractionEnabled = false
                    cell!.detailTextLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                    cell!.detailTextLabel?.numberOfLines = 0
                }
                return cell!
            default:
                let cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "PRSettingsCell") as UITableViewCell!
                return cell!
            }
        }
        
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if (indexPath as NSIndexPath).section == 0
        {
            return 70.0
        }
        else
        {
            return 160.0
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
                updateDb()
            }
            else if (indexPath as NSIndexPath).row == 1 {
                
                if let cell = tableView.cellForRow(at: indexPath) {
                    if UserDefaults.standard.bool(forKey: "PRKanjiJigokuAutoDbUpdate") {
                        UserDefaults.standard.set(false, forKey: "PRKanjiJigokuAutoDbUpdate")
                        cell.accessoryView?.isHidden = true
                    } else {
                        cell.accessoryView?.isHidden = false
                        UserDefaults.standard.set(true, forKey: "PRKanjiJigokuAutoDbUpdate")
                    }
                    UserDefaults.standard.synchronize()
                    tableView.reloadData()
                }
            }
            else { // row == 2
                let appDomain = Bundle.main.bundleIdentifier
                UserDefaults.standard.removePersistentDomain(forName: appDomain!)
                updateDb()
            }
        }
        else //section == 1
        {
            
        }
    }

    func updateDb() {
        let backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.center = self.tableView.center
        backgroundView.addSubview(indicator)
        indicator.startAnimating()
        UIApplication.shared.keyWindow!.addSubview(backgroundView)
            // do some task
            //PRDatabaseHelper().syncDatabase()
            let operationQueue = OperationQueue()
        let importOperation = ImportOperation(remoteImport: false)
            importOperation.completionBlock = {
                    DispatchQueue.main.async(execute: {
                        backgroundView.removeFromSuperview()
                        PRDatabaseHelper().loadAppSettings()
                        self.navigationController?.popToRootViewController(animated: false)
                        })
            }
            operationQueue.addOperation(importOperation)
        
        
    }
}
