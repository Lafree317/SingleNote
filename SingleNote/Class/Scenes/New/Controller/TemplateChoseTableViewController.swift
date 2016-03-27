//
//  TemplateChoseTableViewController.swift
//  SingleNote
//
//  Created by 胡春源 on 16/3/25.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

protocol TemplateChoseTableViewControllerDelegate {
    func templateSelectModel(model:AnyObject,type:String)
}

class TemplateChoseTableViewController: UITableViewController {
    var type:String!
    var model:TemplaceChoseModel!
    var order:OrderModel!
    var delegate:TemplateChoseTableViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        model = TemplaceChoseModel(order:order,type: type, tableView: self.tableView)
        model.refresh { (success, type) in
            if success {
                
            }else{
                ZEHud.sharedInstance.showError(self.view, text: type)
            }
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return model.cellHeight
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if type == itemClassName {
            let cell = tableView.dequeueReusableCellWithIdentifier(itemCellId, forIndexPath: indexPath) as! ItemCell
            cell.setModel(model.itemArr[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(buyerCellId, forIndexPath: indexPath) as! BuyerCell
            cell.setModel(model.buyerArr[indexPath.row])
            return cell
        }
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 判断操作类型
        if editingStyle == UITableViewCellEditingStyle.Delete {
            ZEHud.sharedInstance.showHud(self.view)
            // 执行model删除方法
            model.removeTemplace(indexPath, callBack: { (success, type) in
                ZEHud.sharedInstance.hideHud()
                if success {
                    ZEHud.sharedInstance.showSuccess(self.view, text:type)
                    self.tableView.reloadData()
                }else{
                    ZEHud.sharedInstance.showError(self.view, text:type)
                }
            })
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        model.addModel(indexPath)
        self.navigationController?.popViewControllerAnimated(true)
    }
}