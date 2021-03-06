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
        leanCloud.fetchAllOrder(checkString) { (orders, type) in
            self.cellModels = Array()
            
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
    func setOrderdone(indexPath:NSIndexPath,callBack:successTypeBlock){
        let order = cellModels[indexPath.section].model
        order.orderType = doneString
        leanCloud.saveOrder(order) { (success, type) in

            callBack(success: success, type: type)
        }
    }
}
