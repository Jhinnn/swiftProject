//
//  MainTabBarController.swift
//  WYP
//
//  Created by 你个LB on 2017/2/24.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 给tabbar添加动画
        let myBar = KTabbarAnimation.init()
        setValue(myBar, forKey: "tabBar")
        
        // 设置选中标题的颜色
        let attributesDic: [String : Any] = [NSForegroundColorAttributeName: UIColor.themeColor]
        UITabBarItem.appearance().setTitleTextAttributes(attributesDic, for: .selected)
        
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AppInfo.shared.user?.token != nil {
            self.tabBar.items?[4].title = "我的"
        } else {
            self.tabBar.items?[4].title = "未登录"
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // 判断是否登录
        if let _ = AppInfo.shared.user?.token {
            return true
        }
        // 判断是否是我的控制器
        let baseNaviVC = viewController as! BaseNavigationController
        if baseNaviVC.viewControllers.first?.isKind(of: MeViewController.self) ?? false {
            // 跳转登录页面
            let navi = BaseNavigationController(rootViewController: LogInViewController())
            present(navi, animated: true) {
                
            }
            return false
        }
        return true
    }
    
}
