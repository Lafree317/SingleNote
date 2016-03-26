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
typealias successBlock = (success:Bool)->Void
 