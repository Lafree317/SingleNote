//
//  BuyerModel.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/19.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit



class BuyerModel:AVObject {
    var name:String?
    var address:String?
    var content:String?
    
    init(name:String,address:String,content:String){
        super.init()
        self.name = name
        self.address = address
        self.content = content
    }
}

