//
//  HistoryViewController.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/15.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UITabBarDelegate,UITableViewDataSource {
    let noteCellId = "noteCellId"
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.registerNib(UINib.init(nibName: "NoteCell", bundle: nil), forCellReuseIdentifier: noteCellId)
        // Do any additional setup after loading the view.
    }


    // MARK: - Table view data source
    /** 区数 */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    /** 行数 */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    /** 行高 */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    /** cell */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(noteCellId, forIndexPath: indexPath) as! NoteCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let viewModel = HistoryModel()
        cell.configure(viewModel, delegate: viewModel)
        
        // Configure the cell...
        
        return cell
    }
    
    /** 点击事件 */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
