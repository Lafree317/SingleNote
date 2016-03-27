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

        // 如果提前删除数组元素 保存失败会崩
        if indexpath.section == 0 {
            if self.order.buyerArr.count > 0 {
                self.order.buyerArr.removeAtIndex(indexpath.row)
            }
        }else{
            if  self.order.itemArr.count > 0 {
                self.order.itemArr.removeAtIndex(indexpath.row)
            }
        }
        // 如果取出的obj为空
        leanCloud.saveOrder(self.order) { (success) in
            
            
            
            callBack(success: success)
            
            
            
    }
//        // 先删除一个obj
//        leanCloud.deleteAVobject(model!) { (success) in
//            if success {
//                // 成功后order的数组里面删除那个值
//                if indexpath.section == 0 {
//                    self.order.buyerArr.removeAtIndex(indexpath.row)
//                }else{
//                    self.order.itemArr.removeAtIndex(indexpath.row)
//                }
//                // 更新order
//                self.leanCloud.saveOrder(self.order!, callBack: { (success) in
//                    // 回调是否成功
//                    callBack(success: success)
//                })
//            }else{
//                callBack(success: false)
//            }
//            
//        }
        
    }
}



