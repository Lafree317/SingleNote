//
//  HomeModel.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/21.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

class HomeModel: NSObject {
    var cellModels:Array<HomeCellModel> = []
    let leanCloud = LeanCloud()
    init(callBack:()->Void) {
        super.init()
        leanCloud.fetchAllOrder { (orders) -> Void in
            
            for order in orders{
                var model = HomeCellModel()
                model.model = order
                self.cellModels.append(model)
            }
            callBack()
        }
        
    }
}
