//
//  MineTopicsModel.swift
//  WYP
//
//  Created by Arthur on 2017/12/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class MineTopicsModel: HandyJSON {
    
    // 用户头像
    var headImgUrl: String?
    // 用户昵称
    var nickName: String?
    // 评论内容
    var content: String?
    // 话题类型
    var type: String?
    // 话题类型
    var title: String?
    
    //显示分类
    var new_type: String?
    
    //话题分类
    var category: String?
    
    
    var status: String?
    
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
    
    //话题图片
    var cover_url: [String]?
    
    
    var follow_num: String?
    
    
    var reply: InfoReplyModel?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.headImgUrl <-- "avatar128"
        mapper <<< self.nickName <-- "nickname"
        mapper <<< self.content <-- "description"
        mapper <<< self.new_type <-- "new_type"
        mapper <<< self.category <-- "category"
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
        mapper <<< self.cover_url <-- "cover_url"
        mapper <<< self.title <-- "title"
        mapper <<< self.follow_num <-- "follow_num"
        mapper <<< self.reply <-- "reply"
    }
    
    required init() {}
}
