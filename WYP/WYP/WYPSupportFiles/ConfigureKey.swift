//
//  ConfigureKey.swift
//  WYP
//
//  Created by 你个LB on 2017/3/6.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

// 极光
public var JPushAppKey: String {
    // Master Secret : 4534a66d075bd9fcaf0152cd
    return "ed4e4bdf704f8c6b8a15e4a4"
}
// 友盟
public var UMengAppKey: String {
    return "58bfb0f845297d0df8000209"
}

//public var UMengAppKey: String {
//    return "58bfb0f845297d0df8000209"
//}
// 微信
public var WeChatAppKey: String {
    return "wx4ed7078e7307cb60"
}

public var WeChatAppSecret: String {
    return "a643068aaabbceb36ee7684819e8922f"
}

// 微信支付
// 绑定支付的APPID
public var WXAPPID: String {
    return "wx4ed7078e7307cb60"
}
// 商户号
public var MCHID: String {
    return ""
}

// QQ
public var QQAppKey: String {
    return "1105955141"
}

public var QQAppSecret: String {
    return "uXX1b6886oB6VNIU"
}

// 新浪
public var sinaAppKey: String {
    return "1833151579"
}

public var sinaAppSecret: String {
    return "2360560aa469857adfcc0c2952082340"
}

// 融云  bmdehs6pbiihs
public var RCIMAppKey: String {
//    return "bmdehs6pbiihs"
    return "pkfcgjstp99g8"
}

public var RCIMAppSecret: String {
//    return "dzqRtU1zsixR"
    return "WfNbcHkrHx"
}

// 屏幕的宽度
public var kScreen_width: CGFloat {
    return UIScreen.main.bounds.size.width
}

// 屏幕的高度
public var kScreen_height: CGFloat {
    return UIScreen.main.bounds.size.height
}

// 屏幕的尺寸
public var kScreen_size: CGSize {
    return UIScreen.main.bounds.size
}

// 
public var width_height_ratio: CGFloat {

   return kScreen_width / 375
}

public var NAVIGATION_BAR_HEIGHT: CGFloat {
    
    
    
    if deviceTypeIPhoneX() {
        return 88
    }
    return 64
}

// 当前设备系统版本
public var kSystemVersion: String {
    return UIDevice.current.systemVersion
}

// 当前应用程序版本号
public var versionString: String {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
}

// 是否是发布版本
public var isProduction: Bool {
    return true
}

// 随机数（设置最大值）
public func random(max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max) + 1))
}

// 随机数（设置区间）
public func random(min: Int, max: Int) -> Int {
    return random(max: max - min) + min
}

// 判断设备是iPhone4
public func deviceTypeIPhone4() -> Bool {
    return UIScreen.main.bounds.size.height == 480
}

// 判断设备是iPhone5
public func deviceTypeIphone5() -> Bool {
    return UIScreen.main.bounds.size.height == 568
}

// 判断设备是iPhone6
public func deviceTypeIPhone6() -> Bool {
    return UIScreen.main.bounds.size.height == 667
}

// 判断设备是iPhone6Plus
public func deviceTypeIPhone6Plus() -> Bool {
    return UIScreen.main.bounds.size.height == 736
}


// 判断设置iphone X
public func deviceTypeIPhoneX() -> Bool {
    return UIScreen.main.bounds.size.height == 812
}

// 资讯分页导航
public var newsCurrentIndex: NSInteger = 0
// 展厅分页导航
public var roomsCurrentIndex: NSInteger = 0
// 抢票分页导航
public var ticketsCurrentIndex: NSInteger  = 0

// 浏览量/评论量等字体大小
public var grayTextFont = UIFont.systemFont(ofSize: 11)
