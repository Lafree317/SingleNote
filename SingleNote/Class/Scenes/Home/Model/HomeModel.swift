//
//  HomeModel.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/21.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

class HomeModel: NSObject {
    var cellModels:Array<HomeCellModel> = []
    let leanCloud = LeanCloud()
    
    func refresh(callBack:successTypeBlock){
        cellModels = Array()
        leanCloud.fetchAllOrder(checkString) { (orders, type) in
            
            for order in orders{
                var model = HomeCellModel()
                model.model = order
                self.cellModels.append(model)
            }
            if orders.count > 0 {
                callBack(success: true, type: type)
            }else{
                callBack(success: false, type: type)
            }
        }
    }
    func setOrderdone(indexPath:NSIndexPath,callBack:successBlock){
        let order = cellModels[indexPath.row].model
        order.orderType = doneString
        leanCloud.saveOrder(order) { (succ) in
            
//            callBack(success: succe, type: "")
        }
    }
}
