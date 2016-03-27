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
        model = TemplaceChoseModel(order:order,type: type, tableView: self.tableView, callBack: {
            self.tableView.reloadData()
        })
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
        if editingStyle == UITableViewCellEditingStyle.Delete {
            ZEHud.sharedInstance.showHud(self.view)
            model.removeTemplace(indexPath, callBack: { (success) in
                ZEHud.sharedInstance.hideHud()
                if success {
                    ZEHud.sharedInstance.showSuccess(self.view, text: "删除成功")
                    self.tableView.reloadData()
                }else{
                    ZEHud.sharedInstance.showError(self.view, text: "删除失败")
                }
            })
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        model.addModel(indexPath)
        self.navigationController?.popViewControllerAnimated(true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
