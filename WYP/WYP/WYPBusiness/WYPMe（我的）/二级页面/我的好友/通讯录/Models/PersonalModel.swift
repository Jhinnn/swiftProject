//
//  personalModel.swift
//  WYP
//
//  Created by 曾雪峰 on 2017/12/23.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON
class PersonalModel: HandyJSON {
    /// 联系人姓名
    public var name: String = ""
    
    /// 联系人电话数组,一个联系人可能存储多个号码
    public var mobileArray: [String] = []
    
    /// 联系人头像
    public var headerImage: UIImage?
    
    // 用户头像链接
    public var PersonalModel: String?
    // 用户的Id
    var peopleId: String?
    // 用户的粉丝数
    var peopleFans: String?
    // 用户的好友数
    var peopleFriends: String?
    // 是否关注
    var isFollow: String?
    //阿拉丁ID
    var aldid: String?
    //电话
    public var mobile: String?
    //备注名
    var alias: String?
    
    
    //头
    public var avatar: String?
    //签名
    public var signature: String?
    //地址
    public var address: String?
    //性别1男2女
    public  var sex: String?
    //社区图片
    public var community_cover: [String] = []
    //话题图片
    public var gambit_cover: [String] = []
    //是否免打扰
    var is_push: String?
    //好友关系
    public var varis_follow: String?
    
    
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.name <-- "nickname"
        mapper <<< self.avatar <-- "avatar"
        mapper <<< self.peopleFans <-- "fans"
        mapper <<< self.peopleFriends <-- "friend_num"
        mapper <<< self.peopleId <-- "uid"
        mapper <<< self.isFollow <-- "is_follow"
        
        mapper <<< self.peopleId <-- "peopleId"
        mapper <<< self.address <-- "address"
        mapper <<< self.gambit_cover <-- "gambit_cover"
        mapper <<< self.community_cover <-- "community_cover"
        mapper <<< self.sex <-- "sex"
        mapper <<< self.varis_follow <-- "varis_follow"
        mapper <<< self.mobile <-- "mobile"
        
        
        
        
    }
    
    required init() {}
}

