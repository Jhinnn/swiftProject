//
//  TicketTimeModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/27.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class TicketTimeModel: HandyJSON {

    // 票务时间
    var ticketTime: String?
    // 票数
    var ticketNumber: String?
    // 抢票人数
    var ticketPeople: String?
    
    // 
    var ticketTimeId: String?
    
    // 
    var type: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.ticketTime <-- "ticket_time"
        mapper <<< self.ticketNumber <-- "ticket_num"
        mapper <<< self.ticketPeople <-- "people_num"
        mapper <<< self.ticketTimeId <-- "id"
        mapper <<< self.type <-- "type"
    }
    
    required init() {}
}
