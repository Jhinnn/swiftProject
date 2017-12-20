//
//  OrdersModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/21.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class OrdersModel: HandyJSON {

    // 订单图片
    var activityImage: String?
    // 订单名称
    var activityTitle: String?
    // 剧场名称
    var travelName: String?
    // 订单开始时间
    var activitySTime: String?
    // 订单结束时间
    var activityETime: String?
    // 订单价格
    var orderPrice: String?
    // 活动类型 1.问答 2.投票 3.抽奖
    var activityType: String?
    // 获得的奖品类型 1.票 2.优惠券 3.礼品
    var prizeType: String?
    // 状态
    var currentStatus: Int?
    // 票务时间Id
    var ticketTimeId: String?
    // 订单Id
    var orderId: String?

    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.activityImage <-- "pic"
        mapper <<< self.activityTitle <-- "title"
        mapper <<< self.activitySTime <-- "sTime"
        mapper <<< self.activityETime <-- "eTime"
        mapper <<< self.orderPrice <-- "place"
        mapper <<< self.activityType <-- "type"
        mapper <<< self.prizeType <-- "ticket_type"
        mapper <<< self.currentStatus <-- "ticket_status"
        mapper <<< self.ticketTimeId <-- "ticket_time_id"
        mapper <<< self.travelName <-- "vernve_name"
        mapper <<< self.orderId <-- "id"
    }
    
    required init() {}
}
