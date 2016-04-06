//
//  HistoryModel.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/15.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

class HistoryModel: NSObject {
    var cellModels:Array<HistoryViewModel> = []
    let leanCloud = LeanCloud()
    
    func refresh(callBack:()->Void){
        cellModels = Array()
        leanCloud.fetchAllOrder(doneString) { (orders, type) in
            for order in orders{
                var model = HistoryViewModel()
                model.model = order
                self.cellModels.append(model)
            }
            callBack()
        }
    }
    func setOrderdone(indexPath:NSIndexPath,callBack:successTypeBlock){
        let order = cellModels[indexPath.row].model
        order.orderType = checkString
        leanCloud.saveOrder(order) { (success, type) in
            callBack(success: success, type: type)
        }
    }
}
