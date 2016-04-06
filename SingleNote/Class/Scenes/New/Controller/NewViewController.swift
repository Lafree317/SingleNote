//
//  NewViewController.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/19.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

protocol NewViewControllerDelegate {
    func newSaveSuccess()
}

class NewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NewFooterViewDelegate {
    var passModel:OrderModel?
    
    @IBOutlet weak var tableView: UITableView!

    var model:NewModel!
    var leanCloud = LeanCloud()
    var hud = ZEHud.sharedInstance
    var delegate:NewViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    func setUI(){
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.registerNib(UINib.init(nibName: buyerCellNib, bundle: nil), forCellReuseIdentifier: buyerCellId)
        self.tableView.registerNib(UINib.init(nibName: itemCellNib, bundle: nil), forCellReuseIdentifier: itemCellId)
        model = NewModel(model: passModel)
    }
    
    @IBAction func saveOrderAction(sender: UIButton) {
        hud.showHud(self.view)
        model.saveOrder { (success, type) in
            if success {
                ZEHud.sharedInstance.showSuccess(self.view, text: type)
                self.navigationController?.popViewControllerAnimated(true)
                self.delegate?.newSaveSuccess()
            }else{
                ZEHud.sharedInstance.showSuccess(self.view, text: type)
            }
        }
        
    }
    
    
    // MARK: - Table view data source
    /** 区数 */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    /** 行数 */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return model.order.buyerArr.count
        } else {
            return model.order.itemArr.count
        }

    }
    /** 行高 */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    /** cell */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(buyerCellId, forIndexPath: indexPath) as! BuyerCell
            cell.setModel(model.order.buyerArr[indexPath.row])
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(itemCellId, forIndexPath: indexPath) as! ItemCell
            cell.setModel(model.order.itemArr[indexPath.row])
            return cell
        }
    }
    
    /** 点击事件 */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        self.view.endEditing(true)
    }
    // MARK:Footer
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = NSBundle.mainBundle().loadNibNamed("NewFooterView", owner: self, options: nil).first as! NewFooterView
        footer.section = section
        footer.delegate = self
        return footer
        
    }
    func buttonClickPass(section: Int, type: FooterType) {
        if type == .new {
            if section == 0 {
                model.addModel(NoteType.buyer)
            } else {
                model.addModel(NoteType.item)
            }
        } else {
            var sender = ""
            if section == 0 {
                sender = buyerClassName
            }else{
                sender = itemClassName
            }
            
            
           self.performSegueWithIdentifier("templateChose", sender: sender)
        
        }
        self.tableView.reloadData()
    }
    // MARK:Header
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = NSBundle.mainBundle().loadNibNamed("NewHeaderView", owner: self, options: nil).first as! NewHeaderView
        var title = "购买者"
        if section == 1 {
            title = "物品"
        }
        header.titleLabel.text = title
        return header
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    // MARK: - Delete
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 判断操作类型
        if editingStyle == UITableViewCellEditingStyle.Delete {
            hud.showHud(self.view)
            // 执行model删除方法
            model.removeObject(indexPath, callBack: { (success, type) in
                self.hud.hideHud()
                if success {
                    self.tableView.reloadData()
                    self.hud.showSuccess(self.view, text: type)
                    if type == "订单不完整删除成功" {
                        self.navigationController?.popViewControllerAnimated(true)
                        self.delegate?.newSaveSuccess()
                    }
                } else {
                    self.hud.showError(self.view, text: type)
                }
            })
            
        }
    }
    
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier ==  "templateChose" {
            let vc = segue.destinationViewController as! TemplateChoseTableViewController
            vc.type = sender as! String
            vc.order = model.order
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
