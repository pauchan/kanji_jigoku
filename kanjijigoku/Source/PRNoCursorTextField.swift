//
//  PRNoCursorTextField.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/03/06.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRNoCursorTextField: UITextField {

    override func caretRect(for position: UITextPosition) -> CGRect
    {
        
        return CGRect.zero
    }
    
}
