//
//  MemberModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/19.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class MemberModel: HandyJSON {

    // 项目成员头像
    var memberPhoto: String?
    // 项目成员真是姓名
    var realName: String?
    // 项目成员昵称
    var nickName: String?
    // 项目成员的职业
    var profession: String?
    // 如果是饰演，显示饰演的角色
    var portray: String?
    // 成员id
    var memberId: String?
    // 是否关注
    var isFllow: String?
    // 粉丝数
    var memberFans: String?
    // 好友数
    var friendsNumber: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.memberPhoto <-- "avatar128"
        mapper <<< self.realName <-- "realname"
        mapper <<< self.nickName <-- "nickname"
        mapper <<< self.profession <-- "hangye"
        mapper <<< self.portray <-- "portray"
        mapper <<< self.memberId <-- "uid"
        mapper <<< self.isFllow <-- "follow"
        mapper <<< self.memberFans <-- "fans"
        mapper <<< self.friendsNumber <-- "friend_num"
    }
    
    required init() {}
}
