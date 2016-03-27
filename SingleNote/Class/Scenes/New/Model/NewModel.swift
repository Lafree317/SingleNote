//
//  NewModel.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/19.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit



class NewModel: NSObject {
    var order:OrderModel!
    var leanCloud = LeanCloud()
        
    init(model:OrderModel?){
        super.init()
        if model == nil {
            order = OrderModel()
            self.addModel(.buyer)
            self.addModel(.item)
        }else{
            self.order = model
        }
    }
    func addModel(type:NoteType) {
        if type == .buyer {
            let buyerModel = BuyerModel(className: buyerClassName)
            buyerModel.setDetail("", address: "", content: "")
            order.buyerArr.append(buyerModel)

        } else {
            let itemModel = ItemModel(className: itemClassName)
            itemModel.setDetail("", inPrice: 0, outPrice: 0, number: 0, content: "")
            order.itemArr.append(itemModel)
        }
    }
    func removeObject(indexpath:NSIndexPath,callBack:successTypeBlock){

        // 删除元素
        if indexpath.section == 0 {
            if self.order.buyerArr.count > 0 {
                self.order.buyerArr.removeAtIndex(indexpath.row)
            }
        }else{
            if  self.order.itemArr.count > 0 {
                self.order.itemArr.removeAtIndex(indexpath.row)
            }
        }
        // 保存订单
        leanCloud.saveOrder(self.order) { (success, type) in
            callBack(success: success, type: type)
        }
    }
    func saveOrder(callback:successTypeBlock){
        leanCloud.saveOrder(order) { (success, type) in
            callback(success: success, type: type)
        }
    }
}



