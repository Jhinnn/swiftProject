//
//  TicketInfoModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/27.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class TicketInfoModel: HandyJSON {

    // 票务id
    var ticketId: String?
    
    
    // 票务详情
    var ticketDetail: String?
    // 票价
    var ticketPirce: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.ticketId <-- "id"
        mapper <<< self.ticketPirce <-- "place"
        mapper <<< self.ticketDetail <-- "detail"
        
    }
    
    required init() {}
}
