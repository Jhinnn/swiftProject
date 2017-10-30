//
//  TicketNumberModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/4.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class TicketNumberModel: HandyJSON {

    // 票务id
    var ticketId: String?
    // 票数
    var ticketNumber: String?
    // 票务名称
    var ticketName: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.ticketId <-- "id"
        mapper <<< self.ticketNumber <-- "sum"
        mapper <<< self.ticketName <-- "title"
    }
    
    required init() {}
}
