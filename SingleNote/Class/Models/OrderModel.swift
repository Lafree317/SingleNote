//
//  OrderModel.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/19.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit


class OrderModel:AVObject{
    var buyerArr:Array<BuyerModel> = []
    var itemArr:Array<ItemModel> = []
    var orderType:String = checkString
    
    var buyersTitle:String?{
        get {
            var title = ""
            for buyer in buyerArr{
                if title != "" {
                    title += ","
                }
                title = title + "\(buyer.name!)"
            }
            return title
            }
        set(value){
            self.buyersTitle = value
        }
    }
    var itemsTitle:String?{
        get {
            var title = ""
            for item in itemArr{
                if title != "" {
                    title += ","
                }
                title = title + "\(item.name!)"
            }
            return title
        }
        set(value){
            self.buyersTitle = value
        }
    }
    var cellModel:HomeCellModel?
    override init() {
        super.init()

        
    }

}
