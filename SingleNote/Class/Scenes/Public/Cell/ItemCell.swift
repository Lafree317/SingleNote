//
//  ItemCell.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/19.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var inPriceField: UITextField!
    @IBOutlet weak var outPriceField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var contentTV: UITextView!
    var itemModel:ItemModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        itemModel = ItemModel(name: "", inPrice: 0, outPrice: 0, number: 0, content: "")
        self.nameField.delegate = self
        self.inPriceField.delegate = self
        self.outPriceField.delegate = self
        self.numberField.delegate = self
        self.contentTV.delegate = self
        // Initialization code
    }
    func textViewDidEndEditing(textView: UITextView) {
        refreshModel()
    }
    func textFieldDidEndEditing(textField: UITextField) {
        refreshModel()
    }
    func refreshModel(){
        itemModel?.name = self.nameField.text
        var inPrice:Int = 0
        if inPriceField.text?.characters.count > 0 {
            inPrice = Int(inPriceField.text!)!

        }
        var outPrice:Int = 0
        if outPriceField.text?.characters .count > 0 {
            outPrice = Int(outPriceField.text!)!
        }
        
        var number:Int = 0
        if numberField.text?.characters.count > 0 {
            number = Int(numberField.text!)!
        }
        itemModel?.inPrice = inPrice
        itemModel?.outPrice = outPrice
        itemModel?.number = number
        itemModel?.content = contentTV.text
    }
    /** 获取ItemModel */
    func getItemModel() -> ItemModel?{
        let str = nameField.text!
        if str.characters.count > 0 {
            return itemModel
        }else{
            return nil
        }
    }
    
    func setModel(item:ItemModel){
        itemModel = item
        self.nameField.text = item.name
        var inPriceStr = ""
        var outPriceStr = ""
        var numberStr = ""
        if item.name?.characters.count > 0 {
            inPriceStr = "\(item.inPrice!)"
            outPriceStr = "\(item.outPrice!)"
            numberStr = "\(item.number!)"
        }
        self.inPriceField.text = inPriceStr
        self.outPriceField.text = outPriceStr
        self.numberField.text = numberStr
        self.contentTV.text = item.content
    }
    
    
    func clear(){
        self.nameField.text = ""
        self.inPriceField.text = ""
        self.outPriceField.text = ""
        self.numberField.text = ""
        self.contentTV.text = ""
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
