//
//  KRefreshDataCount.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/7/4.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class KRefreshDataCount: NSObject {
    
    // 创建显示的Label
    var label = UILabel()
    
    // MARK:- 显示刷新几条数据
    func showNewDataCountAlert(count: Int, alertFrame: CGRect, view: UIView) {
        
        // 显示文字
        if count > 0 {
            label.text = "成功为您推荐了新内容"
        } else {
            label.text = "暂无更新，休息一会儿"
        }
        
        // 设置背景
        label.backgroundColor = UIColor.init(red: 217 / 250.0, green: 60 / 250.0, blue: 42 / 250.0, alpha: 1.0)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14.0)
        
        // 设置大小
        label.frame = alertFrame
        
        // 添加到导航控制器的view
//        addNavContr.view.insertSubview(label, belowSubview: addNavContr.navigationBar)
        view.addSubview(label)
        
        // 动画
        let duration = 1.0
        label.alpha = 0.0
        UIView.animate(withDuration: duration, animations: {
            // 往下移动一个label的高度
            self.label.transform = CGAffineTransform(translationX: 0, y: self.label.frame.height)
            self.label.alpha = 1.0
            
        }) { (finished) in  // 向下移动完毕
            
            // 延迟delay秒后，再执行动画
            let delay = 2.0
            UIView.animate(withDuration: delay, animations: {
                // 恢复到原来的位置
                self.label.transform = CGAffineTransform.identity
                self.label.alpha = 0.0
            }, completion: { (finshed) in
                // 删除控件
                self.label.removeFromSuperview()
            })
        }
    }
    
}

