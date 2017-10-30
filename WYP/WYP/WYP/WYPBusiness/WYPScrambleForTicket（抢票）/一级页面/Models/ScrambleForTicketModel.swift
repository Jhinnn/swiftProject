//
//  ScrambleForTicketModel.swift
//  WYP
//
//  Created by 你个LB on 2017/3/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class ScrambleForTicketModel: HandyJSON {

    // 票务票数
    var ticketNumber: [TicketNumberModel]?
    // 票务信息
    var ticketInfo: [TicketModel]?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.ticketNumber <-- "group_sum"
        mapper <<< self.ticketInfo <-- "list"
    }
    
    required init() {}
}
