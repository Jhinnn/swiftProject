//
//  BaseNavigationController.swift
//  WYP
//
//  Created by 你个LB on 2017/2/24.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    var pan: UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18)]
        //标题颜色
        navigationBar.titleTextAttributes = dict as? [String : AnyObject]
        
        //item颜色
        navigationBar.tintColor = UIColor.white
        
        // 导航栏颜色
        navigationBar.barTintColor = UIColor.naviColor
        
        navigationBar.isTranslucent = false
        
        // 添加侧滑手势
        let target = self.interactivePopGestureRecognizer?.delegate
        pan = UIPanGestureRecognizer.init(target: target!, action: Selector(("handleNavigationTransition:")))
        self.view.addGestureRecognizer(pan!)
        
        self.interactivePopGestureRecognizer?.isEnabled = false
        pan?.delegate = self
        
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 隐藏控制器的底部栏
        viewController.hidesBottomBarWhenPushed = true
        
        // 清除返回系统默认的按钮
        //        viewController.navigationItem.hidesBackButton = true
        let backBarBtnItem = UIBarButtonItem()
        backBarBtnItem.title = ""
        viewController.navigationItem.backBarButtonItem = backBarBtnItem
        
        // 设置返回按钮
        if !viewController.naviItemHidesBackButton {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        } else {
            viewController.navigationItem.leftBarButtonItem = backBarBtnItem
        }
        
        // 调用父类的跳转方法
        super.pushViewController(viewController, animated: animated)
    }
    
    // 返回按钮
    lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 36, height: 20)
        backButton.setImage(UIImage(named: "common_navback_button_normal_iPhone"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        return backButton
    }()
    
    // 返回按钮点击事件
    func backButtonAction(button: UIButton) {
        popViewController(animated: true)
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.childViewControllers.count > 1
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isKind(of: NSClassFromString("UITableViewCellContentView")!))! {
            // 系统左滑返回失效
            return false
            
        } else if (touch.view?.superview?.isKind(of: WMPlayer.self))! {
            // 播放器关闭侧滑效果
            return false
        } else {
            return true
        }
    }
}
