//
//  InviteFriendsModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/7.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class InviteFriendsModel: HandyJSON {

    // 集票Id
    var ticketId: String?
    // 活动图片
    var ticketImage: String?
    // 活动标题
    var ticketTitle: String?
    // 活动类型 1.问答 2.投票 3.抽奖
    var activityType: String?
    // 票务是否兑换 0：未兑换 1：已兑换
    var isExchange: Int?
    // 票数
    var ticketNumber: Int?
    // 票务时间Id
    var ticketTimeId: String?
    // 结束时间
    var ticketEndTime: Int?

    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.ticketId <-- "id"
        mapper <<< self.ticketImage <-- "pic"
        mapper <<< self.ticketTitle <-- "title"
        mapper <<< self.activityType <-- "type"
        mapper <<< self.isExchange <-- "is_exchange"
        mapper <<< self.ticketNumber <-- "number"
        mapper <<< self.ticketTimeId <-- "ticket_time_id"
        mapper <<< self.ticketEndTime <-- "eTime"
    }

    required init() {}
}
