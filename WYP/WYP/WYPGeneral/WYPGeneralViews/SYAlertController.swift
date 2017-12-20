//
//  SYAlertController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/7.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class SYAlertController: UIAlertController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    class func showAlertController(view: UIViewController, title: String, message: String) {
        
        let alert = SYAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        view.present(alert, animated: false, completion: nil)
//        return alert
    }
    
}

