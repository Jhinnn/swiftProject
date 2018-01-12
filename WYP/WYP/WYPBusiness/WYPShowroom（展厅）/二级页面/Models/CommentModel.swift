//
//  CommentModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class CommentModel: HandyJSON {

    //个人id
    var uid: String?
    // 评论id
    var commentId: String?
    // 头像
    var userPhoto: String?
    // 昵称
    var nickName: String?
    // 点赞数
    var zanNumber: String?
    // 是否点赞
    var isStar: String?
    // 评论内容
    var content: String?
    // 创建时间
    var createTime: String?
    // 是否关注该用户
    var is_follow: Int?
    // 该用户的好友数
    var friendsNum: String?
    // 该用户的粉丝数
    var fansNumber: String?
    // 话题回复数
    var replyCount: Int?
    // 评论图片
    var cover_url: [String]?
    
    

    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.uid <-- "uid"
        mapper <<< self.commentId <-- "id"
        mapper <<< self.userPhoto <-- "avatar128"
        mapper <<< self.cover_url <-- "cover_url"
        mapper <<< self.nickName <-- "nickname"
        mapper <<< self.zanNumber <-- "like_num"
        mapper <<< self.isStar <-- "is_like"
        mapper <<< self.content <-- "content"
        mapper <<< self.createTime <-- "create_time"
        mapper <<< self.replyCount <-- "reply_count"
        mapper <<< self.is_follow <-- "is_follow"
        
    }
    
    required init() {}
    
}
