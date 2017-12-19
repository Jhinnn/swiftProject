//
//  TopicsModel.swift
//  WYP
//
//  Created by 你个LB on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class TopicsModel: HandyJSON {

    // 用户头像
    var headImgUrl: String?
    // 用户昵称
    var nickName: String?
    // 评论内容
    var content: String?
    // 话题类型
    var type: String?
    // 时间
    var timestamp: Int?
    // 浏览量
    var seeCount: String?
    // 点赞数
    var starCount: String?
    // 是否点赞
    var isStar: String?
    // 评论数
    var commentCount: String?
    // 话题id
    var topicId: String?
    // 该用户的Id
    var peopleId: String?
    // 是否关注该用户
    var isFollow: String?
    // 该用户的粉丝数
    var peopleFans: String?
    // 该用户的好友数
    var peopleFriends: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.headImgUrl <-- "avatar128"
        mapper <<< self.nickName <-- "nickname"
        mapper <<< self.content <-- "description"
        mapper <<< self.type <-- "category"
        mapper <<< self.timestamp <-- "create_time"
        mapper <<< self.starCount <-- "like_num"
        mapper <<< self.isStar <-- "is_like"
        mapper <<< self.topicId <-- "id"
        mapper <<< self.seeCount <-- "view"
        mapper <<< self.commentCount <-- "comment"
        mapper <<< self.peopleId <-- "uid"
        mapper <<< self.isFollow <-- "is_follow"
        mapper <<< self.peopleFans <-- "fans"
        mapper <<< self.peopleFriends <-- "friend_num"
    }
    
    required init() {}
}
