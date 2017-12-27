//
//  BaseViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/2/24.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // 刷新加载
    enum RequestType {
        case update
        case loadMore
    }
    // 加载页数
    var pageNumber: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.vcBgColor
        
        // 取消滑动视图自动偏移
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.isTranslucent = false
        
        // item颜色
        navigationController?.navigationBar.tintColor = UIColor.white
    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UIViewController {
    
    // 改进写法【推荐】
    struct RuntimeKey {
        static let backButtonkey = UnsafeRawPointer.init(bitPattern: "backButtonkey".hashValue)
        /// ...其他Key声明
    }
    
    var naviItemHidesBackButton: Bool {
        set {
            if newValue {
                navigationItem.leftBarButtonItem = nil
            }
            objc_setAssociatedObject(self, RuntimeKey.backButtonkey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, RuntimeKey.backButtonkey) as? Bool ?? false
        }
    }
}
