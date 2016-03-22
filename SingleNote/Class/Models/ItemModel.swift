//
//  ItemModel.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/19.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

class ItemModel:NSObject {
    var name:String?
    var inPrice:Int?
    var outPrice:Int?
    var number:Int?
    var content:String?
    
    init(name:String,inPrice:Int,outPrice:Int,number:Int,content:String){
        super.init()
        self.name = name
        self.inPrice = inPrice
        self.outPrice = outPrice
        self.number = number
        self.content = content
    }
    
}


