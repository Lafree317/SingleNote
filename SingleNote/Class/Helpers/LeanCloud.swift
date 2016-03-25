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
            let obj = AVObject(className: "Buyer")
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
            let obj = AVObject(className: "Item")
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
    func saveOrder(orderModel:OrderModel,callBack:(success:Bool)->Void){
        let order = AVObject(className: "Order")
        if orderModel.objectId != nil {
            order.objectId = orderModel.objectId
        }
        order.setObject(orderModel.orderType, forKey: "orderType")
        var buyerFinish = false
        var itemFinish = false
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
    func fetchAllOrder(orderType:String,callBack:(orders:Array<OrderModel>)->Void){
        let query = AVQuery(className: "Order")
        query.orderByAscending("creatAt")
        query.whereKey("orderType", equalTo: orderType)
        query.includeKey("Buyers")
        query.includeKey("Items")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objs, error) -> Void in
            var orders:Array<OrderModel> = []
            if objs == nil || objs.count <= 0 {
                callBack(orders: orders)
                return;
            }
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
            callBack(orders: orders)
        }
    
    }
    
    func fetchAllBuyer(callBack:(buyers:Array<BuyerModel>)->Void){
        let query = AVQuery(className: "Buyer")
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
        let query = AVQuery(className: "Item")
        query.orderByAscending("creatAt")
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
    func ResolveItemsWithObjs(objs:[AnyObject!]) ->Array<ItemModel>{
        var itemArr:Array<ItemModel> = []
        for obj in objs {
            let itemDic = obj.dictionaryForObject()
            let name = itemDic.valueForKey("name") as! String
            let inPrice = itemDic.valueForKey("inPrice") as! Int
            let outPrice = itemDic.valueForKey("outPrice") as! Int
            let number = itemDic.valueForKey("number") as! Int
            var content = ""
            if  let str = itemDic.valueForKey("content")  {
                content = str as! String
            }
            let itemModel = ItemModel(name: name, inPrice: inPrice, outPrice: outPrice, number: number, content: content)
            itemModel.objectId = obj.objectId
            itemArr.append(itemModel)
        }
        return itemArr
    }
    func ResolveBuyersWithObjs(objs:[AnyObject!]) ->Array<BuyerModel>{
        var buyerArr:Array<BuyerModel> = []
        for obj in objs {
            let buyerDic = obj.dictionaryForObject()
            let name = buyerDic.valueForKey("name") as! String
            
            var address = ""
            if let str = buyerDic.valueForKey("address"){
                address = str as! String
            }
            var content = ""
            if let str = buyerDic.valueForKey("content") {
                content = str as! String
            }
            let buyerModel = BuyerModel(name: name, address: address, content: content)
            buyerModel.objectId = obj.objectId
            buyerArr.append(buyerModel)
        }
        return buyerArr
    }
/* 弃用方法
    func saveBuyerModelInBackGround(buyer buyerModel:BuyerModel,callBack:(obj:AVObject)->Void){
        let obj = AVObject(className: "Buyer")
        obj.setObject(buyerModel.name, forKey: "name")
        obj.setObject(buyerModel.address, forKey: "address")
        obj.setObject(buyerModel.content, forKey: "content")
        obj.saveInBackgroundWithBlock { (success, error) -> Void in
            callBack(obj: obj)
        }
    }
    
    func saveItemModelInBackGround(item itemModel:ItemModel,callBack:(obj:AVObject)->Void){
        let obj = AVObject(className: "Item")
        obj.setObject(itemModel.name, forKey: "name")
        obj.setObject(itemModel.inPrice, forKey: "inPrice")
        obj.setObject(itemModel.outPrice, forKey: "outPrice")
        obj.setObject(itemModel.number, forKey: "number")
        obj.setObject(itemModel.content, forKey: "content")
        
        obj.saveInBackgroundWithBlock { (success, error) -> Void in
            callBack(obj: obj)
        }
        
    }
*/
}
