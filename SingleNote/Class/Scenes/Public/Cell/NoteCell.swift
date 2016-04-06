//
//  NoteCell.swift
//  PriceNote
//
//  Created by 胡春源 on 16/3/14.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

protocol NoteCellDataSource{
    var buyerTitle:String{ get }
    var itemTitle:String{ get }
    var optionTitle:String { get }
    var model:OrderModel { get }
}
protocol NoteCellDelegate{
    func optionClick(indexPath:NSIndexPath)
 
}

extension NoteCellDelegate {
    var optionTintColor : UIColor {
        return .whiteColor()
    }
}



class NoteCell: UITableViewCell {


    @IBOutlet weak var buyer: UILabel!
    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var option: UIButton!
    
    private var dataSource:NoteCellDataSource?
    var delegate:NoteCellDelegate?
    var indexPath:NSIndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(dataSource:NoteCellDataSource){
        self.dataSource = dataSource
        buyer.text = dataSource.model.buyersTitle
        buyer.sizeToFit()
        item.text = dataSource.model.itemsTitle
        item.sizeToFit()
        option.setTitle(dataSource.optionTitle, forState: UIControlState.Normal)
        self.item.layoutIfNeeded()
        self.contentView.frame = CGRectMake(0, 0, ZEScreenWidth, CGRectGetMaxY(self.item.frame) + 8)
    }
    @IBAction func buttonAction(sender: UIButton) {
        delegate?.optionClick(indexPath)
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
