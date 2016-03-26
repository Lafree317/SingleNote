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
    func removeObject(indexpath:NSIndexPath,callBack:successBlock){
        let model:AVObject
        // 如果提前删除数组元素 保存失败会崩
        if indexpath.section == 0 {
            model = order.buyerArr[indexpath.row]
            self.order.buyerArr.removeAtIndex(indexpath.row)
        }else{
            model = order.itemArr[indexpath.row]
            self.order.itemArr.removeAtIndex(indexpath.row)
        }
        leanCloud.deleteAVobject(order, obj: model) { (success) in
            callBack(success: success)
        }
        
    }
}



