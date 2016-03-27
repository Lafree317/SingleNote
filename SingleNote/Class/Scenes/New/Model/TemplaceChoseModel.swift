//
//  TemplaceChoseModel.swift
//  SingleNote
//
//  Created by 胡春源 on 16/3/25.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

class TemplaceChoseModel: NSObject {
    var type:String!
    var leanCloud:LeanCloud!
    var cellHeight:CGFloat = 140
    var order:OrderModel!
    var count:Int{
        get{
            if type == itemClassName {
                return itemArr.count
            }else{
                return buyerArr.count
            }
        }
    }
    var buyerArr:Array<BuyerModel> = []
    var itemArr:Array<ItemModel> = []
    init(order:OrderModel,type:String,tableView:UITableView) {
        super.init()
        leanCloud = LeanCloud()
        self.order = order
        self.type = type

        tableView.registerNib(UINib.init(nibName: itemCellNib, bundle: nil), forCellReuseIdentifier:itemCellId)
        tableView.registerNib(UINib.init(nibName: buyerCellNib, bundle: nil), forCellReuseIdentifier: buyerCellId)
    }
    func refresh(callback:successTypeBlock){
        if type == itemClassName {
            leanCloud.fetchAllItem({ (items, success, type) in
                self.itemArr = items
                callback(success: success, type: type)
            })
        }else{
            leanCloud.fetchAllBuyer({ (buyers, type) in
                let success:Bool
                if type != successType{
                    success = false
                }else{
                    self.buyerArr = buyers
                    success = true
                }
                callback(success: success, type: type)
                
            })
        }
    }
    func addModel(indexPath:NSIndexPath){
        if type == itemClassName {
            order.itemArr.append(itemArr[indexPath.row])
            var arr:Array<Int> = []
            for  i in 0..<order.itemArr.count{
                let item = order.itemArr[i]
                if item.name == "" {
                    // 倒序
                    arr.insert(i, atIndex: 0)
                }
            }
            for i in 0 ..< arr.count {
                order.itemArr.removeAtIndex(arr[i])
            }

        }else{
            order.buyerArr.append(buyerArr[indexPath.row])

            var arr:Array<Int> = []
            for  i in 0..<order.buyerArr.count{
                let buyer = order.buyerArr[i]
                if buyer.name == "" {
                    if buyer.name == "" {
                        // 倒序
                        arr.insert(i, atIndex: 0)
                    }
                }
            }
            for i in 0 ..< arr.count {
                order.buyerArr.removeAtIndex(arr[i])
            }
        }
    }
    
    
    func removeTemplace(indexpath:NSIndexPath,callBack:successTypeBlock) {
        let model:AVObject
        // 取出model
        if type == buyerClassName {
            model = buyerArr[indexpath.row]
        }else{
            model = itemArr[indexpath.row]
        }
        // 执行删除方法
        leanCloud.deleteAVobject(model) { (success, type) in
            if success {
                if self.type == buyerClassName {
                    self.buyerArr.removeAtIndex(indexpath.row)
                }else{
                    self.itemArr.removeAtIndex(indexpath.row)
                }
            }
            callBack(success: success, type: type)
        }
    }

}
