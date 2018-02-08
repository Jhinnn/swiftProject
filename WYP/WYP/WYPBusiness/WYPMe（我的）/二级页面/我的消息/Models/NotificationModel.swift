//
//  NotificationModel.swift
//  WYP
//
//  Created by 你个LB on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class NotificationModel: HandyJSON {
    // 消息id
    var id: String?
    
    // 通知类型 1.添加好友 2.推荐好友入群 3.抢票活动/兑换票务 4.订单消息 5.通过群组审核 6.通过好友审核 7.被踢出群组
    var type: String?
    
    // 通知内容
    var content: String?
    
    // 通知时间戳
    var timestamp: Int?
    
    // 添加好友请求的昵称 | 群组名称
    var nickname: String?
    
    // 展厅名称
    var roomName: String?
    
    // 添加好友请求的头像
    var headerImage: String?
    
    // 添加好友请求的id
    var friendId: String?
    
    // 是否已成为好友
    var isFriend: String?
    
    // 是否已经进群
    var isGroup: String?
    
    // 新闻id
    var news_id: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.content <-- "message_details"
        mapper <<< self.timestamp <-- "create_time"
        mapper <<< self.friendId <-- "uid"
        mapper <<< self.nickname <-- "nickname"
        mapper <<< self.roomName <-- "room_name"
        mapper <<< self.headerImage <-- "avatar128"
        mapper <<< self.isFriend <-- "is_friend"
        mapper <<< self.isGroup <-- "is_group"
        mapper <<< self.news_id <-- "news_id"
    }
    
    required init() {}
}
