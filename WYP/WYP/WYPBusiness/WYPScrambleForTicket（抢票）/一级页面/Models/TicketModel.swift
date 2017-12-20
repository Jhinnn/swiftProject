//
//  TicketModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/4.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class TicketModel: HandyJSON {
    
    // 抽奖状态
    enum LotteryState {
        case pickedUp
        case haveTickets
    }
    
    // 票务状态
    enum TicketState {
        case end
        case going
        case stop
    }
    
    // 票当前状态
    var ticketState: TicketState?
    // 活动类型 1.问答 2.投票 3.抽奖
    var ticketType: Int?
    // 票务时间id
    var ticketTimeId: String?
    // 票务id
    var ticketId: String?
    // 票务图片
    var ticketPic: String?
    // 票无标题
    var ticketTitle: String?
    // 场馆名称
    var ticketVernve: String?
    // 开始时间
    var ticketStartTime: String?
    // 结束时间
    var ticketEndTime: String?
    // 是否置顶
    var isTop: String?
    // 票价
    var ticketPirce: String?
    // 距离
    var ticketDistance: String?
    // 参与抢票人数
    var ticketPeople: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.ticketType <-- "type"
        mapper <<< self.ticketTimeId <-- "ticket_time_id"
        mapper <<< self.ticketId <-- "ticket_id"
        mapper <<< self.ticketPic <-- "pic"
        mapper <<< self.ticketTitle <-- "title"
        mapper <<< self.ticketVernve <-- "vernve_name"
        mapper <<< self.ticketStartTime <-- "ticket_time"
        mapper <<< self.ticketEndTime <-- "eTime"
        mapper <<< self.isTop <-- "is_top"
        mapper <<< self.ticketPirce <-- "place"
        mapper <<< self.ticketDistance <-- "distance"
        mapper <<< self.ticketPeople <-- "attentionCount"
    }
    
    required init() {}
}
