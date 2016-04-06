//
//  HomeViewController.swift
//  PriceNote
//
//  Created by 胡春源 on 16/3/14.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NewViewControllerDelegate,NoteCellDelegate,HistoryViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var prototypeCell:NoteCell!

    
    var model:HomeModel!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        model = HomeModel()
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        self.tableView.mj_header.beginRefreshing()
        self.tableView.registerNib(UINib.init(nibName: "NoteCell", bundle: nil), forCellReuseIdentifier: noteCellId)
        prototypeCell = self.tableView.dequeueReusableCellWithIdentifier(noteCellId) as! NoteCell
        // Do any additional setup after loading the view.
    }
    func refresh(){
        model.refresh { (success, type) in
            
            if success == false {
                ZEHud.sharedInstance.showError(self.view, text:type)
            }
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    /** 区数 */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return model.cellModels.count
    }
    /** 行数 */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    /** 行高 */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        let viewModel = model.cellModels[indexPath.section]
        prototypeCell.delegate = self
        prototypeCell.indexPath = indexPath
        prototypeCell.configure(viewModel)
        
        return prototypeCell.contentView.frame.size.height
    }
    /** cell */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(noteCellId, forIndexPath: indexPath) as! NoteCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let viewModel = model.cellModels[indexPath.section]
        cell.delegate = self
        cell.indexPath = indexPath
        cell.configure(viewModel)
        return cell
    }
    func optionClick(indexPath: NSIndexPath) {
        ZEHud.sharedInstance.showHud(self.view)
        model.setOrderdone(indexPath) { (success, type) in
            ZEHud.sharedInstance.hideHud()
            if success {
                ZEHud.sharedInstance.showSuccess(self.view, text: "订单完成")
                self.tableView.mj_header.beginRefreshing()
            }else{
                ZEHud.sharedInstance.showError(self.view, text: "订单完成失败")
            }
        }
    }
    func newSaveSuccess() {
        self.tableView.mj_header.beginRefreshing()
    }
    /** 点击事件 */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let order = model.cellModels[indexPath.section].model
        self.performSegueWithIdentifier("new", sender: order)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.001
        }else{
            return 5
        }
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "new" {
            let vc = segue.destinationViewController as! NewViewController
            vc.delegate = self
            vc.passModel = sender as? OrderModel
        }else if segue.identifier == "history" {
            let vc = segue.destinationViewController as! HistoryViewController
            vc.delegate = self
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
