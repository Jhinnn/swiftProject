//
//  TicketDetailModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/27.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class TicketDetailModel: HandyJSON {
    
    // 展厅相关信息
    var roomInfo: RoomInfoModel?
    // 属性
    var attribution: AttributionModel?
    // 票务时间
    var timeInfo: [TicketTimeModel]?
    // 票务详情
    var ticketInfo: TicketInfoModel?
    // 场馆位置
    var ticketVernve: TicketVernveModel?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.roomInfo <-- "xiangqing"
        mapper <<< self.attribution <-- "attr"
        mapper <<< self.timeInfo <-- "time"
        mapper <<< self.ticketInfo <-- "ticket"
        mapper <<< self.ticketVernve <-- "vernve"
    }
    
    required init() {}
    
}
