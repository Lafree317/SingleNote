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
        // 遍历出所有的buyerModel
        for buyerModel in buyers {
            // 创建avobject对象存储buyerModel的数据
            let obj = AVObject(className: buyerClassName)
            if  let str = buyerModel.objectId  {
                obj.objectId = str
            }
            obj.setObject(buyerModel.name, forKey: "name")
            obj.setObject(buyerModel.address, forKey: "address")
            obj.setObject(buyerModel.content, forKey: "content")
            objs.addObject(obj)
        }
        // 保存所有AVObject
        AVObject.saveAllInBackground(objs as [AnyObject]) { (success, error) -> Void in
            // 回调avobject数组 操作后avobject会有id
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
    
    // 保存,更新订单
    func saveOrder(orderModel:OrderModel,callBack:successTypeBlock){
        let order = AVObject(className: orderClasName)
        
        
        // 如果有objectId就变成更新操作
        if orderModel.objectId != nil {
            order.objectId = orderModel.objectId
        }
        
        // 如果order中有一个数组长度为0 就return
        if orderModel.buyerArr.count == 0 || orderModel.itemArr.count == 0 {
            if orderModel.objectId != nil {
                order.deleteInBackgroundWithBlock({ (success, error) in

                    if success {
                        callBack(success: true, type: "订单不完整删除成功")
                    }else{
                        callBack(success: true, type: "订单不完整删除失败,请手动删除")
                    }
                })
            }else{
                callBack(success: true, type: "订单不完整,数据错误,请手动删除")
            }
            return
        }

        order.setObject(orderModel.orderType, forKey: "orderType")
        var buyerFinish = false
        var itemFinish = false
        // 保存所有的buyer
        self.saveAllBuyer(orderModel.buyerArr) { (objs) -> Void in
            if objs.firstObject?.objectId != nil {
                // 如果回调的avobj有id代表成功
                order.setObject(objs, forKey: "Buyers")
                buyerFinish = true
                // 两个保存都成功才能执行orde保存方法
                if buyerFinish && itemFinish {
                    // 保存order
                    order.saveInBackgroundWithBlock({ (success, error) -> Void in
                        callBack(success: true, type: "订单保存/更新成功")
                    })
                }
            }else{
                callBack(success: false, type: "由于购买者数据有误,保存失败")
            }
        }
        self.saveAllItem(orderModel.itemArr) { (objs) -> Void in
            if objs.firstObject?.objectId != nil {
                // 如果有id则成功
                order.setObject(objs, forKey: "Items")
                itemFinish = true
                
                if buyerFinish && itemFinish {
                    order.saveInBackgroundWithBlock({ (success, error) -> Void in
                        callBack(success: true, type: "订单保存/更新成功")
                    })
                }
            }else{
                callBack(success: false, type: "由于物品数据有误,保存失败")
            }
        }
        
    }
    
    
    
    // MARK:FETCH
    func fetchAllOrder(orderType:String,callBack:ordersStrBlock){
        let query = AVQuery(className: orderClasName)
        query.orderByAscending("creatAt")
        // 如果查找type == all 就不添加type
        if orderType != "all" {
            query.whereKey("orderType", equalTo: orderType)
        }
        query.includeKey("Buyers")
        query.includeKey("Items")
        query.orderByDescending("createdAt")
        // 开始查找
        query.findObjectsInBackgroundWithBlock { (objs, error) -> Void in
            var orders:Array<OrderModel> = []
            // 如果没有返回值就返回空数组
            if error != nil {
                callBack(orders: orders, type: netError)
                return;
            }else if objs.count <= 0 {
                callBack(orders: orders, type: arrCountZero)
                return;
            }
            // 如果有返回值就执行解析方法
            orders = self.resolveOrderWithObjs(objs)
            // 回调数组
            callBack(orders: orders, type: successType)
        }
    }
    
    
    
    func fetchOrderWityType(obj:AVObject,callBack:ordersStrBlock){
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
            if error != nil {
                callBack(orders: orders, type: netError)
                return;
            }else if objs.count <= 0 {
                callBack(orders: orders, type: arrCountZero)
                return;
            }
            orders = self.resolveOrderWithObjs(objs)
            callBack(orders: orders, type: successType)
        }
        
    }
    
    // 查找所有buyer
    func fetchAllBuyer(callBack:buyersBlock){
        let query = AVQuery(className: buyerClassName)
        query.orderByAscending("creatAt")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objs, error) -> Void in
            var buyerArr:Array<BuyerModel> = []
            if error != nil{
                callBack(buyers: buyerArr, type: netError)
            }else if objs.count == 0{
                callBack(buyers: buyerArr, type: arrCountZero)
                return;
            }
            buyerArr = self.ResolveBuyersWithObjs(objs)
            callBack(buyers: buyerArr, type: successType)
        }
    }
    
    // 查找所有item
    func fetchAllItem(callBack:itemsBlock){
        let query = AVQuery(className: itemClassName)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objs, error) -> Void in
            var itemArr:Array<ItemModel> = []
            let success:Bool
            let type:String
            if error != nil {
                success = false
                type = netError
            }else if(objs.count == 0){
                success = false
                type = arrCountZero
            }else{
                success = true
                type = successType
                itemArr = self.ResolveItemsWithObjs(objs)
            }
            callBack(items: itemArr, success: success, type: type)
        }
    }
    
    
    // MARK:FUNC
    func resolveOrderWithObjs(objs:[AnyObject!]) -> Array<OrderModel> {
        var orders:Array<OrderModel> = []
        // 循环遍历
        for obj in objs {
            let dic = (obj as! AVObject)
            // 取出数据
            let localData = dic.valueForKey("localData") as! NSDictionary
            
            
            // 解析item数组
            var itemArr:Array<ItemModel> =  []
            let items = localData.valueForKey("Items") as? [AnyObject!]
            // 如果有值就执行解析方法
            if items != nil || items!.count > 0 {
                itemArr = self.ResolveItemsWithObjs(items!)
            }
            
            // 解析buyer数组
            var buyerArr:Array<BuyerModel> = []
            let buyers = localData.valueForKey("Buyers") as? [AnyObject!]
            if buyers != nil || buyers?.count > 0{
                buyerArr = self.ResolveBuyersWithObjs(buyers!)
            }
            
            // 创建order对象并赋值
            let order = OrderModel()
            order.buyerArr = buyerArr
            order.itemArr = itemArr
            order.orderType = localData.valueForKey("orderType") as! String
            order.objectId = obj.objectId
            
            // 加入数组
            orders.append(order)
        }
        return orders
    }
    func ResolveItemsWithObjs(objs:[AnyObject!]) ->Array<ItemModel>{
        var itemArr:Array<ItemModel> = []
        for obj in objs {
            // 如果不是想要的数据就终止循环
            if obj.className != itemClassName {
                break
            }
            let itemDic = obj.dictionaryForObject()
            
            let itemModel = ItemModel(className:itemClassName)
            
            // 如果没有名字就终止循环
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
            // 创建对象并赋值
            itemModel.setDetail(name, inPrice: inPrice, outPrice: outPrice, number: number, content: content)
            itemModel.objectId = obj.objectId
            itemArr.append(itemModel)
        }
        return itemArr
    }
    // 解析buyer的obj数组
    func ResolveBuyersWithObjs(objs:[AnyObject!]) ->Array<BuyerModel>{
        var buyerArr:Array<BuyerModel> = []

        for obj in objs {
            // 如果不是规定的对象就终止循环
            if obj.className != buyerClassName {
                break
            }
            
            // 解析数据并赋值
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
            
            // 创建对象
            let buyerModel = BuyerModel(className: buyerClassName)
            buyerModel.setDetail(name, address: address, content: content)
            buyerModel.objectId = obj.objectId
            buyerArr.append(buyerModel)
        }
        return buyerArr
    }

    
    
    // MARK: - Delete
    func deleteAVobject(obj:AVObject,callBack:successTypeBlock){
        // 删除一个元素
        obj.deleteInBackgroundWithBlock { (success, error) in
            if !success {
                callBack(success: false, type: "删除失败")
                return
            }
            // 查找和这个元素有关的订单
            self.fetchAllOrder("all", callBack: { (orders, type) in
                    // 便利数组保存
                    for order in orders {
                        // 更新取到的order方法
                        self.saveOrder(order, callBack: { (success, type) in
                            if !success {
                                // 如果保存中有一次不成功
                                callBack(success: false, type: type)
                            }
                        })
                    }
                // 处理完毕 回调成功
                callBack(success: true, type: successType)
            })

        }
    }
}
