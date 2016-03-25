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
    
    func refresh(callBack:()->Void){
        cellModels = Array()
        leanCloud.fetchAllOrder("normol") { (orders) in
            for order in orders{
                var model = HomeCellModel()
                model.model = order
                self.cellModels.append(model)
            }
            callBack()
        }
    }
    func setOrderdone(indexPath:NSIndexPath,callBack:(success:Bool)->Void){
        let order = cellModels[indexPath.row].model
        order.orderType = "done"
        leanCloud.saveOrder(order) { (success) in
            callBack(success: success)
        }
    }
}
