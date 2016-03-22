//
//  TemplateViewController.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/15.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit


class TemplateViewController: UIViewController {
    
    
    var buyerView:BuyerCell?
    var itemView:ItemCell?
    var status = 0
    var leanCloud = LeanCloud()
    var hud = ZEHud()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leanCloud.fetchAllOrder { (orders) -> Void in
            
        }

        
        self.setUI()

    }
    func setUI(){
        let viewRect = CGRectMake(0, 50+64, ZEScreenWidth, 140)
        buyerView = NSBundle.mainBundle().loadNibNamed("BuyerCell", owner: self, options: nil).first as? BuyerCell
        buyerView?.frame = viewRect
        itemView = NSBundle.mainBundle().loadNibNamed("ItemCell", owner: self, options: nil).first as? ItemCell
        itemView?.frame = viewRect
        self.view.addSubview(buyerView!)
        
        
    }
    @IBAction func segementChange(sender: UISegmentedControl) {
        status = sender.selectedSegmentIndex

        if status == NoteType.buyer.rawValue {
            self.view.addSubview(buyerView!)
            itemView?.removeFromSuperview()
        }else {
            self.view.addSubview(itemView!)
            buyerView?.removeFromSuperview()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func clearAction(sender: UIBarButtonItem) {
        if status == NoteType.buyer.rawValue{
            buyerView?.clear()
        }else{
            itemView?.clear()
        }

    }

    @IBAction func saveAction(sender: UIButton) {
        hud.showHud(self.view)
        weak var weakSelf = self
        if status == NoteType.buyer.rawValue {
        
            if let model = buyerView?.getBuyerModel() {
                let arr:Array<BuyerModel>= Array(arrayLiteral: model)
                leanCloud.saveAllBuyer(arr, callBack: { (objs) -> Void in
                    let obj = objs.firstObject as! AVObject
                    if obj.objectId != nil {
                        weakSelf!.buyerView?.clear()
                        weakSelf?.hud.hideHud()
                        weakSelf?.hud.showSuccess((weakSelf?.view)!, text: "保存成功")
                    } else {
                        weakSelf?.hud.showError((weakSelf?.view)!, text: "保存失败")
                    }
                })
            }else{
                weakSelf?.hud.showError((weakSelf?.view)!, text: "没有姓名")
            }
        }else{
            if let model = itemView?.getItemModel() {
                let arr:Array<ItemModel> = Array(arrayLiteral: model)
                leanCloud.saveAllItem(arr, callBack: { (objs) -> Void in
                    let obj = objs.firstObject as! AVObject
                    if obj.objectId != nil {
                        weakSelf!.itemView?.clear()
                        weakSelf?.hud.hideHud()
                        weakSelf?.hud.showSuccess((weakSelf?.view)!, text: "保存成功")
                    }else{
                        weakSelf?.hud.showError((weakSelf?.view)!, text: "保存失败")
                    }
                })
            }else{
                self.hud.showError((weakSelf?.view)!, text: "没有物品名")
            }
        }
        
        
    }

}
