//
//  NewViewController.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/19.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

class NewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NewFooterViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let buyerCellId = "BuyerCellIdentifer"
    let itemCellId = "ItemCellIdentifer"
    var model:NewModel!
    var leanCloud = LeanCloud()
    var hud = ZEHud()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    func setUI(){
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.registerNib(UINib.init(nibName: "BuyerCell", bundle: nil), forCellReuseIdentifier: buyerCellId)
        self.tableView.registerNib(UINib.init(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: itemCellId)
        model = NewModel()
    }
    
    @IBAction func saveOrderAction(sender: UIButton) {
        hud.showHud(self.view)
        weak var weakSelf = self
        leanCloud.saveOrder(model.order) { (success) -> Void in
            weakSelf!.hud.hideHud()
            if success{
                weakSelf!.hud.showSuccess(self.view, text: "保存成功")
            } else {
                weakSelf!.hud.showError(self.view, text: "保存失败")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
