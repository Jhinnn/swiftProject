//
//  UserModel.swift
//  WYP
//
//  Created by 你个LB on 2017/3/9.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class UserModel: HandyJSON {
    
    // 唯一id
    var userId: String?
    
    // 唯一标示（userId进行base64转换后的字符串）
    var token: String?
    
    // 昵称
    var nickName: String?
    
    // 手机号
    var mobilePhoneNumber: String?
    
    // 性别
    var sex: NSNumber?
    
    // 头像地址
    var headImgUrl: String?
    
    // 粉丝数
    var fans: String?
    
    // 好友数
    var friends: String?
    
    // 等级
    var level: String?
    
    // 积分
    var lvScore: String?
    
    // 出生日期
    var birthday: String?
    
    // 省地址
    var province: String?
    
    // 市地址
    var city: String?
    
    // 区地址
    var district: String?
    
    // 家庭地址
    var address: String?
    
    // 上次登录时间
    var lastLoginTime: String?
    
    // 个性签名
    var signature: String?
    
    // 融云签名
    var rcToken: String?
    
    // 融云用户id
    // var rcUserId: String?

    
    // 用户数据原型字典
    var userInfo: NSDictionary?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.userId <-- "uid"
        mapper <<< self.token <-- "open_id"
        mapper <<< self.nickName <-- "nickname"
        mapper <<< self.mobilePhoneNumber <-- "mobile"
        mapper <<< self.headImgUrl <-- "avatar"
        mapper <<< self.lvScore <-- "score"
        mapper <<< self.province <-- "pos_province"
        mapper <<< self.city <-- "pos_city"
        mapper <<< self.district <-- "pos_district"
        mapper <<< self.lastLoginTime <-- "last_login_time"
        mapper <<< self.rcToken <-- "rtoken"
        
    }
    
    required init() {}
}

