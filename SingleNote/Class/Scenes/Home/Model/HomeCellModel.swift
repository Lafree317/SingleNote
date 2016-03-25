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
    var leanCloud = LeanCloud()
}


