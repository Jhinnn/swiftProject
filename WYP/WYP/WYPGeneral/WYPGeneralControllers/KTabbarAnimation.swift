//
//  KTabbarAnimation.swift
//  Demo
//
//  Created by 杨 on 2017/6/16.
//  Copyright © 2017年 杨. All rights reserved.
//

import UIKit

class KTabbarAnimation: UITabBar {
    override func layoutSubviews() {
        super.layoutSubviews()
        // 遍历 UITabBar 的子视图
        for tabBarButton in subviews  {
            // 通过字符串找到子视图中的 UITabBarButton 类
            if tabBarButton.isKind(of: NSClassFromString("UITabBarButton")!) {
                // 将 View 强转成 Control
                let tabBarButtonTwo = tabBarButton as! UIControl
                // 添加点击动画的函数
                tabBarButtonTwo .addTarget(self, action: #selector(tabBarButtonClick(tabBarButton:)), for: .touchUpInside)
                
            }
        }
    }
    
    func tabBarButtonClick(tabBarButton: UIControl) -> Void {
        for imageView in tabBarButton.subviews {
            if imageView.isKind(of: NSClassFromString("UITabBarSwappableImageView")!) {
                // 动画
                let animation = CAKeyframeAnimation.init()
                animation.keyPath = "transform.scale"
                animation.values = [1.0, 1.3, 0.9, 1.15, 0.95, 1.02, 1.0]
                animation.duration = 1
                animation.calculationMode = kCAAnimationCubic
                // 把动画添加上去
                imageView.layer.add(animation, forKey: nil)
            }
        }
    }
}


class KImageViewAnimation: UIImageView {
    func startAnimation() {
        let KeyAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        KeyAnimation.duration = 8.0
        KeyAnimation.values = [1.0, 1.2, 1.0]
        KeyAnimation.keyTimes = [0.0, 0.5, 1.0]
        KeyAnimation.repeatCount = Float.greatestFiniteMagnitude
        KeyAnimation.calculationMode = kCAAnimationLinear
        KeyAnimation.isRemovedOnCompletion = false
        KeyAnimation.fillMode = kCAFillModeForwards
        self.layer.add(KeyAnimation, forKey: "SCALE")
    }
    
}
