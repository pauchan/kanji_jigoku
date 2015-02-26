//
//  PRMenuViewExtension.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/26.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

extension UIViewController
{
    
    func prKanjiJigokuRightBarItemShowSettings(sender: AnyObject)
    {
        self.navigationController?.pushViewController(PRSettingsViewController(), animated: false)
    }

}