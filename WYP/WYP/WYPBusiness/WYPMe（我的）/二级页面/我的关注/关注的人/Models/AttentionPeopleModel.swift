//
//  AttentionPeopleModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/3.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class AttentionPeopleModel: HandyJSON {

    // 关注的人的头像
    var icon: String?
    // 昵称
    var nickName: String?
    // 个性签名
    var signature: String?
    // 真实姓名
    var realName: String?
    // 关注的人的id
    var peopleId: String?
    // 是否添加关注
    var isFollow: String?
    // 电话
    var phoneNumber: String?
    // 粉丝数
    var fans: String?
    // 好友数
    var friends: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.icon <-- "avatar128"
        mapper <<< self.nickName <-- "nickname"
        mapper <<< self.signature <-- "signature"
        mapper <<< self.realName <-- "real_nickname"
        mapper <<< self.phoneNumber <-- "mobile"
        mapper <<< self.peopleId <-- "uid"
        mapper <<< self.isFollow <-- "follow"
        mapper <<< self.friends <-- "friend_num"
    }
    
    required init() {}
    
}
