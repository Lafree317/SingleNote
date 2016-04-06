//
//  BuyerCell.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/19.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

class BuyerCell: UITableViewCell,UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressTV: UITextView!
    @IBOutlet weak var contentTV: UITextView!
    var buyerModel:BuyerModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        buyerModel = BuyerModel(className: buyerClassName)
        buyerModel?.setDetail("", address: "", content: "")
        
        // Initialization code
        self.nameField.delegate = self
        self.addressTV.delegate = self
        self.contentTV.delegate = self
    }
    func textViewDidEndEditing(textView: UITextView) {
        refreshModel()
    }
    func textFieldDidEndEditing(textField: UITextField) {
        refreshModel()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
    func refreshModel(){
        buyerModel!.name = self.nameField.text
        buyerModel!.address = self.addressTV.text
        buyerModel!.content = self.contentTV.text
    }
    func getBuyerModel() -> BuyerModel?{
        let str = nameField.text!
        if str.characters.count > 0{
            return buyerModel
        }else{
            return nil
        }
    }
    
    func clearString(){
        
        self.nameField.text = ""
        self.addressTV.text = ""
        self.contentTV.text = ""
    }
    
    
    
    func setModel(buyer:BuyerModel){
        self.buyerModel = buyer
        self.nameField.text = buyer.name
        self.addressTV.text = buyer.address
        self.contentTV.text = buyer.content
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
