//
//  TemplateView.swift
//  SingleNote
//
//  Created by 胡春源 on 16/4/6.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit
protocol TemplateViewDelegate {
    func templateViewCloseAction()
}
class TemplateView: UIView {

    var buyerView:BuyerCell?
    var itemView:ItemCell?
    var status = 0
    
    @IBOutlet weak var contentView: UIView!
    var delegate:TemplateViewDelegate?
    var leanCloud:LeanCloud?
    override func awakeFromNib() {
        buyerView = NSBundle.mainBundle().loadNibNamed("BuyerCell", owner: self, options: nil).first as? BuyerCell
        buyerView?.frame = self.contentView.bounds
        itemView = NSBundle.mainBundle().loadNibNamed("ItemCell", owner: self, options: nil).first as? ItemCell
        itemView?.frame = self.contentView.bounds
        self.contentView.addSubview(buyerView!)
        leanCloud = LeanCloud()
    }
    
    /** 保存 */
    @IBAction func saveAction(sender: UIButton) {
        ZEHud.sharedInstance.showHud(superview!)
        weak var weakSelf = self
        if status == NoteType.buyer.rawValue {
            
            if let model = buyerView?.getBuyerModel() {
                let arr:Array<BuyerModel>= Array(arrayLiteral: model)
                leanCloud!.saveAllBuyer(arr, callBack: { (objs) -> Void in
                    let obj = objs.firstObject as! AVObject
                    if obj.objectId != nil {
                        weakSelf!.buyerView?.clearString()
                        ZEHud.sharedInstance.hideHud()
                        ZEHud.sharedInstance.showSuccess(self.superview!, text: "保存成功")
                        self.delegate?.templateViewCloseAction()
                    } else {
                        ZEHud.sharedInstance.showError(self.superview!, text: "保存失败")
                    }
                })
            }else{
                ZEHud.sharedInstance.showError(superview!, text: "没有姓名")
            }
        }else{
            if let model = itemView?.getItemModel() {
                let arr:Array<ItemModel> = Array(arrayLiteral: model)
                leanCloud!.saveAllItem(arr, callBack: { (objs) -> Void in
                    let obj = objs.firstObject as! AVObject
                    if obj.objectId != nil {
                        weakSelf!.itemView?.clear()
                        ZEHud.sharedInstance.hideHud()
                        ZEHud.sharedInstance.showSuccess(self.superview!, text: "保存成功")
                        self.delegate?.templateViewCloseAction()
                    }else{
                        ZEHud.sharedInstance.showError(self.superview!, text: "保存失败")
                    }
                })
            }else{
                ZEHud.sharedInstance.showError(superview!, text: "没有物品名")
            }
        }

        
    }
    /** 关闭 */
    @IBAction func closeAction(sender: UIButton) {
        delegate?.templateViewCloseAction()
        
    }
    /** 清空 */
    @IBAction func clearAction(sender: UIButton) {
        if status == NoteType.buyer.rawValue{
            buyerView?.clearString()
        }else{
            itemView?.clear()
        }
    }
    /** 改变选项 */
    @IBAction func segementChange(sender: UISegmentedControl) {
        status = sender.selectedSegmentIndex
        if status == NoteType.buyer.rawValue {
            self.contentView.addSubview(buyerView!)
            itemView?.removeFromSuperview()
        }else {
            self.contentView.addSubview(itemView!)
            buyerView?.removeFromSuperview()
        }
    }
}
