//
//  NewFooterView.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/20.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit
enum FooterType: Int {
    case new = 0, history
}
protocol NewFooterViewDelegate{
    func buttonClickPass(section:Int,type:FooterType)
}

class NewFooterView: UIView {
    var section:Int?
    var delegate:NewFooterViewDelegate?
    
    
    /** 从模板挑选 */
    @IBAction func HistroyCreatAction(sender: UIButton) {
        delegate?.buttonClickPass(section!, type: .history)
    }
    /** 新建一个 */
    @IBAction func newModelAction(sender: UIButton) {
        delegate?.buttonClickPass(section!, type: .new)
    }


}
