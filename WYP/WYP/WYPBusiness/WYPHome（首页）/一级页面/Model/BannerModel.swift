//
//  BannerModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/7/6.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import Foundation
import HandyJSON

class BannerModel: HandyJSON {
    
    var bannerId: String?
    // 广告标题
    var bannerTitle: String?
    // 图片
    var bannerImage: String?
    // 跳转类型  0：广告详情，1：URl,2:展厅，3:活动
    var bannerType: String?
    // 展厅Id
    var roomId: String?
    // 活动Id
    var ticketId: String?
    // 展厅的类型 0：免费 1：付费
    var isFree: String?
    // 跳转到指定的url
    var url: String?
    // 活动时间Id
    var ticketTimeId: String?
    // 活动类型
    var ticketType: String?
    // 是否关联票务
    var isTicket: Int?
    
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.bannerId <-- "id"
        mapper <<< self.bannerTitle <-- "title"
        mapper <<< self.bannerImage <-- "logo"
        mapper <<< self.bannerType <-- "isjob"
        mapper <<< self.roomId <-- "group_id"
        mapper <<< self.ticketId <-- "ticket_id"
        mapper <<< self.isFree <-- "is_spend"
        mapper <<< self.ticketType <-- "type_id"
        mapper <<< self.ticketTimeId <-- "ticket_time_id"
        mapper <<< self.isTicket <-- "is_ticket"
    }
    
    required init() {}
}
