//
//  GeneralMethod.swift
//  WYP
//
//  Created by 你个LB on 2017/3/8.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class GeneralMethod: NSObject {

    // 未登录时的提示框
    class func alertToLogin(viewController: UIViewController) {
        let alert = SYAlertController(title: "", message: "该功能需要登录后使用，请您先登录", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "关闭", style: .default, handler: nil)
        let toAction = UIAlertAction(title: "登录", style: .default, handler: { (_) in
            // 跳转登录页面
            let navi = BaseNavigationController(rootViewController: LogInViewController())
            viewController.present(navi, animated: true) {}
        })
        alert.addAction(closeAction)
        alert.addAction(toAction)
        viewController.present(alert, animated: false, completion: nil)
    }
}
