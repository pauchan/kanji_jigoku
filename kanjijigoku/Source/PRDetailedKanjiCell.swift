//
//  PRDetailedKanjiCell.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/07/08.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

private let CELL_MARGIN_SIZE: CGFloat = 5.0

import UIKit

class PRDetailedKanjiCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.textLabel?.numberOfLines = 0
        self.detailTextLabel?.numberOfLines = 0
        
        self.textLabel?.font = UIFont().appFontOfSize(15.0)
        self.detailTextLabel?.font = UIFont.systemFontOfSize(12.0)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
