//
//  HomeModel.swift
//  PriceNote
//
//  Created by 胡春源 on 16/3/14.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

struct HomeCellModel:NoteCellDataSource {
    var buyerTitle = "Buyer:lafree,clover"
    var itemTitle = " - item:ball,water,someting"
    var optionTitle = "DONE"
    var model: OrderModel = OrderModel()

}

extension HomeCellModel : NoteCellDelegate {
    func optionClick(){
        
    
    }
    var optionTintColor:UIColor {

        return UIColor.init(colorLiteralRed: 51/255.0, green: 153/255.0, blue: 51/255.0, alpha: 1)
    }
}
