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
        self.textLabel?.numberOfLines = 5
        self.detailTextLabel?.numberOfLines = 5
        
        self.textLabel?.font = UIFont(name: "HiraKakuProN-W3", size: 15.0);
        self.detailTextLabel?.font = UIFont(name: "HiraKakuProN-W3", size: 12.0);
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    
//override func layoutSubviews() {
//        
//
//        super.layoutSubviews()
//        let size = self.bounds.size
//        self.textLabel?.frame = CGRectMake(CELL_MARGIN_SIZE, CELL_MARGIN_SIZE, size.width-2.0*CELL_MARGIN_SIZE, size.height*0.5-4.0*CELL_MARGIN_SIZE)
//        self.detailTextLabel?.frame = CGRectMake(CELL_MARGIN_SIZE, size.height*0.5-2.0*CELL_MARGIN_SIZE, size.width-2.0*CELL_MARGIN_SIZE, size.height*0.5-4.0*CELL_MARGIN_SIZE)
//    
//}
}

//func setFontToFit(text: String, label: UILabel) -> CGFloat {
//
//    let font = label.font
//    let expectedSize = text.
//
//}
