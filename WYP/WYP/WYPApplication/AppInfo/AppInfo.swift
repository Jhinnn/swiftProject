
//
//  AppInfo.swift
//  WYP
//
//  Created by 你个LB on 2017/4/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit


class AppInfo: NSObject {

    let kUserInfo = "kUserInfo"
    
    // 单例对象
    static let shared = AppInfo()
    
    // 初始化方法
    override init() {
        super.init()
    }
    
    // 是否登录
    var isLogin: Bool {
        if user == nil {
            return false
        }
        return true
    }
    
    // token方便使用
    var _user: UserModel?
    var user: UserModel? {
        get{
            // 判断当前对象的_user属性有没有值（判断内存），没有的话，加载本地缓存
            if _user != nil {
                // 有值
                return _user
            }
            // 加载本地缓存
            let userInfo = UserDefaults.standard.object(forKey: kUserInfo) as! NSDictionary?
            // 判断用户数据是否存在
            if userInfo == nil {
                // 不存在
                return nil
            }
            _user = UserModel.deserialize(from: userInfo)
            _user?.userInfo = userInfo
            return _user
        }
        
        set{
            _user = newValue
            // 判断 清除数据 or 储存数据
            if newValue == nil {
                // 清除本地用户数据
                UserDefaults.standard.removeObject(forKey: kUserInfo)
            } else {
                // 储存用户数据到本地
                UserDefaults.standard.set(newValue?.userInfo, forKey: kUserInfo)
            }
            // 立即执行
            UserDefaults.standard.synchronize()
        }
    }
}
