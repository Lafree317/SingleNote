//
//  OrderModel.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/19.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit


class OrderModel:NSObject{
    var buyerArr:Array<BuyerModel> = []
    var itemArr:Array<ItemModel> = []
    var cellModel:HomeCellModel?
    override init() {
        super.init()


    }

}
