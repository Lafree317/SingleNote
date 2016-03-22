//
//  NewModel.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/19.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit



class NewModel: NSObject {
    var order:OrderModel!

        
    override init(){
        super.init()
        order = OrderModel()
        self.addModel(.buyer)
        self.addModel(.item)
    }
    func addModel(type:NoteType) {
        if type == .buyer {
            let buyerModel = BuyerModel(name: "", address: "", content: "")
            order.buyerArr.append(buyerModel)

        } else {
            let itemModel = ItemModel(name: "", inPrice: 0, outPrice: 0, number: 0, content: "")
            order.itemArr.append(itemModel)
        }
    }

    
    
    
}
