//
//  ZEHud.swift
//  HandNote
//
//  Created by 胡春源 on 16/3/19.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

class ZEHud: NSObject {
    var hud:MBProgressHUD?
    func showHud(view:UIView){
        hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud?.dimBackground = true
//        hud?.removeFromSuperViewOnHide = true
    }
    func hideHud(){
        hud?.hide(true, afterDelay: 0.7)
    }
    func showSuccess(view:UIView,text:String){
        hud?.hide(true)
        hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud?.labelText = text
        hud?.customView = UIImageView(image: UIImage.init(named: "success"))
        hud?.mode = MBProgressHUDMode.CustomView
        hud?.removeFromSuperViewOnHide = true
        hud?.hide(true, afterDelay: 0.7)
    }
    func showError(view:UIView,text:String){
        hud?.hide(true)
        hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud?.labelText = text
        hud?.customView = UIImageView(image: UIImage.init(named: "error"))
        hud?.mode = MBProgressHUDMode.CustomView
        hud?.removeFromSuperViewOnHide = true
        hud?.hide(true, afterDelay: 0.7)
    }
}
