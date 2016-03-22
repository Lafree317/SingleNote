//
//  HistoryModel.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/15.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

struct HistoryModel:NoteCellDataSource {
    var buyerTitle = "Buyer:lafree,clover"
    var itemTitle = " - item:ball,water,someting"
    var optionTitle = "CHECK"
}

extension HistoryModel:NoteCellDelegate {
    func optionClick(){
        
        
    }
    var optionTintColor:UIColor {
        return UIColor.init(colorLiteralRed: 178/255.0, green: 24/255.0, blue: 137/255.0, alpha: 1)
    }
}