//
//  LeanCloud.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/19.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

class LeanCloud: NSObject {
    
    // MARK:SAVE
    func saveAllBuyer(buyers:Array<BuyerModel>,callBack:(objs:NSMutableArray)->Void) {
        let objs = NSMutableArray()
        for buyerModel in buyers {
            let obj = AVObject(className: buyerClassName)
            if  let str = buyerModel.objectId  {
                obj.objectId = str
            }
            obj.setObject(buyerModel.name, forKey: "name")
            obj.setObject(buyerModel.address, forKey: "address")
            obj.setObject(buyerModel.content, forKey: "content")
            objs.addObject(obj)
        }
        AVObject.saveAllInBackground(objs as [AnyObject]) { (success, error) -> Void in
            callBack(objs: objs)
        }
    }
    func saveAllItem(items:Array<ItemModel>,callBack:(objs:NSMutableArray)->Void){
        let objs = NSMutableArray()
        for itemModel in items{
            let obj = AVObject(className: itemClassName)
            if  let str = itemModel.objectId {
                obj.objectId = str
            }
            obj.setObject(itemModel.name, forKey: "name")
            obj.setObject(itemModel.inPrice, forKey: "inPrice")
            obj.setObject(itemModel.outPrice, forKey: "outPrice")
            obj.setObject(itemModel.number, forKey: "number")
            obj.setObject(itemModel.content, forKey: "content")
            objs.addObject(obj)
        }
        AVObject.saveAllInBackground(objs as [AnyObject]) { (success, error) -> Void in
            callBack(objs: objs)
        }
    }
    func saveOrder(orderModel:OrderModel,callBack:successBlock){
        let order = AVObject(className: orderClasName)
        if orderModel.objectId != nil {
            order.objectId = orderModel.objectId
        }
        if orderModel.buyerArr.count == 0 {
            if orderModel.itemArr.count == 0 {
                order.deleteInBackgroundWithBlock({ (success, error) in
                    callBack(success: success)
                })
                return
            }
        }
        
        order.setObject(orderModel.orderType, forKey: "orderType")
        var buyerFinish = false
        var itemFinish = false
        // 这里需要改一改,不是没有数据就保存失败,而是网络失败才保存失败,没有数据考虑一下要不要保存个空
        self.saveAllBuyer(orderModel.buyerArr) { (objs) -> Void in
            if objs.firstObject?.objectId != nil {
                order.setObject(objs, forKey: "Buyers")
                buyerFinish = true
                if buyerFinish && itemFinish {
                    order.saveInBackgroundWithBlock({ (success, error) -> Void in
                        callBack(success: success)
                    })
                }
            }else{
                // item,buyer为0时删除order
                callBack(success: false)
            }
        }
        self.saveAllItem(orderModel.itemArr) { (objs) -> Void in
            if objs.firstObject?.objectId != nil {
                order.setObject(objs, forKey: "Items")
                itemFinish = true
                if buyerFinish && itemFinish {
                    order.saveInBackgroundWithBlock({ (success, error) -> Void in
                        callBack(success: success)
                    })
                }
            }else{
                callBack(success: false)
            }
        }
        
    }
    
    
    
    // MARK:FETCH
    func fetchAllOrder(orderType:String,callBack:ordersBlock){
        let query = AVQuery(className: orderClasName)
        query.orderByAscending("creatAt")
        if orderType != "all" {
            query.whereKey("orderType", equalTo: orderType)
        }
        query.includeKey("Buyers")
        query.includeKey("Items")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objs, error) -> Void in
            var orders:Array<OrderModel> = []
            if objs == nil || objs.count <= 0 {
                callBack(orders: orders)
                return;
            }
            orders = self.resolveOrderWithObjs(objs)
            callBack(orders: orders)
        }
    
    }
    func fetchOrderWityType(obj:AVObject,callBack:ordersBlock){
        let query = AVQuery(className: "Order")
        let key:String
        if obj.className == buyerClassName {
            key = "Buyers"
        }else{
            key = "Items"
        }
        query.whereKey(key, containedIn:[obj])
        query.findObjectsInBackgroundWithBlock { (objs, error) in
            var orders:Array<OrderModel> = []
            if objs == nil || objs.count <= 0 {
                callBack(orders: orders)
                return;
            }
            orders = self.resolveOrderWithObjs(objs)
            callBack(orders: orders)
        }
        
    }
    func fetchAllBuyer(callBack:(buyers:Array<BuyerModel>)->Void){
        let query = AVQuery(className: buyerClassName)
        query.orderByAscending("creatAt")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objs, error) -> Void in
            var buyerArr:Array<BuyerModel> = []
            if objs == nil || objs.count <= 0 {
                callBack(buyers: buyerArr)
                return;
            }
            buyerArr = self.ResolveBuyersWithObjs(objs)
            callBack(buyers: buyerArr)
        }
    }
    
    func fetchAllItem(callBack:(buyers:Array<ItemModel>)->Void){
        let query = AVQuery(className: itemClassName)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objs, error) -> Void in
            var itemArr:Array<ItemModel> = []
            if objs == nil || objs.count <= 0 {
                callBack(buyers: itemArr)
                return;
            }
            itemArr = self.ResolveItemsWithObjs(objs)
            callBack(buyers: itemArr)
        }
    }
    
    
    // MARK:FUNC
    func resolveOrderWithObjs(objs:[AnyObject!]) -> Array<OrderModel> {
        var orders:Array<OrderModel> = []
        for obj in objs {
            let dic = (obj as! AVObject)
            let localData = dic.valueForKey("localData") as! NSDictionary
            var itemArr:Array<ItemModel> =  []
            let items = localData.valueForKey("Items") as? [AnyObject!]
            if items != nil || items!.count > 0 {
                itemArr = self.ResolveItemsWithObjs(items!)
            }
            var buyerArr:Array<BuyerModel> = []
            let buyers = localData.valueForKey("Buyers") as? [AnyObject!]
            
            if buyers != nil || buyers?.count > 0{
                buyerArr = self.ResolveBuyersWithObjs(buyers!)
            }
            let order = OrderModel()
            order.buyerArr = buyerArr
            order.itemArr = itemArr
            
            order.orderType = localData.valueForKey("orderType") as! String
            order.objectId = obj.objectId
            orders.append(order)
        }
        return orders
    }
    func ResolveItemsWithObjs(objs:[AnyObject!]) ->Array<ItemModel>{
        var itemArr:Array<ItemModel> = []
        for obj in objs {
            if obj.className != itemClassName {
                break
            }
            let itemDic = obj.dictionaryForObject()
            
            
            let itemModel = ItemModel(className:itemClassName)
            var name :String = ""
            if let nameS = itemDic.valueForKey("name"){
                name = nameS as! String
            }else{
                break
            }
            let inPrice = itemDic.valueForKey("inPrice") as! Int
            let outPrice = itemDic.valueForKey("outPrice") as! Int
            let number = itemDic.valueForKey("number") as! Int
            var content = ""
            if  let str = itemDic.valueForKey("content")  {
                content = str as! String
            }
            
            itemModel.setDetail(name, inPrice: inPrice, outPrice: outPrice, number: number, content: content)
            itemModel.objectId = obj.objectId
            itemArr.append(itemModel)
        }
        return itemArr
    }
    func ResolveBuyersWithObjs(objs:[AnyObject!]) ->Array<BuyerModel>{
        var buyerArr:Array<BuyerModel> = []

        for obj in objs {
            if obj.className != buyerClassName {
                break
            }
            let buyerDic = obj.dictionaryForObject()
            var name = ""
            if let nameS = buyerDic.valueForKey("name"){
                name = nameS as! String
            }else{
                break
            }
            
            var address = ""
            if let str = buyerDic.valueForKey("address"){
                address = str as! String
            }
            var content = ""
            if let str = buyerDic.valueForKey("content") {
                content = str as! String
            }
            let buyerModel = BuyerModel(className: buyerClassName)
            buyerModel.setDetail(name, address: address, content: content)
            
            buyerModel.objectId = obj.objectId
            buyerArr.append(buyerModel)
        }
        return buyerArr
    }

    
    
    // MARK: - Delete
    // 为以后扩展留好方法
    func deleteAVobject(obj:AVObject,callBack:successBlock){
        // 删除一个元素
        obj.deleteInBackgroundWithBlock { (success, error) in
            // 查找和这个元素有关的订单
            if !success {
                callBack(success: false)
                return
            }
            self.fetchAllOrder("all", callBack: { (orders) in
                // 如果有就遍历删除
                if orders.count > 0 {
                    for order in orders {
                        self.saveOrder(order, callBack: { (success) in
                            if !success {
                                // 如果保存中有一次不成功
                                callBack(success: false)
                            }
                        })
                    }
                }
                // 处理完毕 回调成功
                callBack(success: true)
            })

        }
    }
}
