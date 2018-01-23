//
//  UIColor+Extension.swift
//  WYP
//
//  Created by 你个LB on 2017/3/7.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    /// 用十六进制颜色创建UIColor
    ///
    /// - Parameter hexColor: 十六进制颜色 (0F0F0F)
    convenience init(hexColor: String) {
        
        var cString:String = hexColor.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }

    /// 将颜色转换为图片
    ///
    /// - Parameter color: <#color description#>
    /// - Returns: <#return value description#>
    class func getImageWithColor(color:UIColor)->UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // 主题颜色
    open class var themeColor: UIColor {
        return UIColor(hexColor: "#dc3a20")
    }
    
    open class var menuColor: UIColor {
        return UIColor.init(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
    }
    
    // 导航栏颜色
    open class var naviColor: UIColor {
        return UIColor(hexColor: "#dc3a20")
    }
    
    // 控制器背景颜色
    open class var vcBgColor: UIColor {
        return UIColor(hexColor: "#f1f2f4")
    }
    
    // 浏览量/评论量等颜色 
    open class var viewGrayColor: UIColor {
        return UIColor(hexColor: "#787878")
    }
}



