 //
//  Header.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/20.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

 enum NoteType: Int {
     case buyer = 0, item
 }
 let ZEScreenWidth = UIScreen.mainScreen().bounds.size.width
 let ZEScreenHight = UIScreen.mainScreen().bounds.size.height
 let buyerCellId = "BuyerCellIdentifer"
 let itemCellId = "ItemCellIdentifer"
 let itemCellNib = "ItemCell"
 let buyerCellNib = "BuyerCell"
 let noteCellId = "noteCellId"
 let buyerClassName = "Buyer"
 let itemClassName = "Item"
 let orderClasName = "Order"
 let doneString = "done"
 let checkString = "normol"
 
 
 // MARK:Block
 let successType = "成功"
 let errorType = "失败"
 let netError = "网络状态不佳"
 let arrCountZero = "当前查询无数据"
 typealias successBlock = (success:Bool)->Void
 typealias ordersBlock = (orders:Array<OrderModel>)->Void
 typealias ordersStrBlock = (orders:Array<OrderModel>,type:String) ->Void
 typealias successTypeBlock = (success:Bool,type:String) -> Void
 typealias buyersBlock = (buyers:Array<BuyerModel>,type:String) -> Void
 typealias itemsBlock = (items:Array<ItemModel>,success:Bool,type:String) -> Void

// typealias normolBlock = (type:String) ->Void
 
 
 