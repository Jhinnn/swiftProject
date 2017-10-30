//
//  PersonModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/4.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class PersonModel: HandyJSON {

    /// 联系人姓名
    public var name: String = ""
    
    /// 联系人电话数组,一个联系人可能存储多个号码
    public var mobileArray: [String] = []
    
    /// 联系人头像
    public var headerImage: UIImage?
    
    // 用户头像链接
    var userImage: String?
    // 用户的Id
    var peopleId: String?
    // 用户的粉丝数
    var peopleFans: String?
    // 用户的好友数
    var peopleFriends: String?
    // 是否关注
    var isFollow: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.name <-- "nickname"
        mapper <<< self.userImage <-- "avatar128"
        mapper <<< self.peopleFans <-- "fans"
        mapper <<< self.peopleFriends <-- "friend_num"
        mapper <<< self.peopleId <-- "uid"
        mapper <<< self.isFollow <-- "is_follow"
    }
    
    required init() {}
}
