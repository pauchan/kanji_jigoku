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
        self.textLabel?.numberOfLines = 3
        //self.textLabel?.adjustsFontSizeToFitWidth = true
        self.detailTextLabel?.numberOfLines = 3
        //self.detailTextLabel?.adjustsFontSizeToFitWidth = true
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
  //  override func layoutSubviews() {
        
        /*

        */
        //super.layoutSubviews()
        //let size = self.bounds.size
        //self.textLabel?.frame = CGRectMake(CELL_MARGIN_SIZE, CELL_MARGIN_SIZE, size.width-2.0*CELL_MARGIN_SIZE, size.height*0.5- 4.0*CELL_MARGIN_SIZE)
        //self.detailTextLabel?.frame = CGRectMake(CELL_MARGIN_SIZE, CELL_MARGIN_SIZE, size.width-2.0*CELL_MARGIN_SIZE, size.height*0.5- 4.0*CELL_MARGIN_SIZE)
        
   // }
}

func setLineCountToFit(text: String) -> Int {
    
    if count(text) < 20 {
        return 1
    } else if count(text) < 40 {
        return 2
    }
    return 3
}


//func setFontToFit(text: String, label: UILabel) -> CGFloat {
//
//    let font = label.font
//    let expectedSize = text.
//
//}
