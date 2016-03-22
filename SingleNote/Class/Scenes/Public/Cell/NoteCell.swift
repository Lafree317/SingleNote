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
}
protocol NoteCellDelegate{
    func optionClick()
    var optionTintColor : UIColor{ get }
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
    private var delegate:NoteCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(dataSource:NoteCellDataSource,delegate:NoteCellDelegate){
        self.dataSource = dataSource
        self.delegate = delegate
        
        buyer.text = dataSource.buyerTitle
        item.text = dataSource.itemTitle
        option.setTitle(dataSource.optionTitle, forState: UIControlState.Normal)
        option.tintColor = delegate.optionTintColor
        
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
