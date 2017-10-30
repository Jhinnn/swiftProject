//
//  WalletModel.swift
//  WYP
//
//  Created by 你个LB on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import HandyJSON

class CouponModel: HandyJSON {
    
    var id: String?
    
    var type: String?
    
    var money: String?
    
    var startTime: String?
    
    var endTime: String?
    
    var useStatus: String?
    
    var ticketName: String?
    
    var promotionCode: String?
    
    var ticketTimeId: String?
    
    func mapping(mapper: HelpingMapper) {
        
        mapper <<< self.id <-- "id"
        
        mapper <<< self.type <-- "type"
        
        mapper <<< self.money <-- "quota"
        
        mapper <<< self.startTime <-- "sTime"
        
        mapper <<< self.endTime <-- "eTime"
        
        mapper <<< self.useStatus <-- "is_use"
        
        mapper <<< self.ticketName <-- "title"
        
        mapper <<< self.promotionCode <-- "code"
        
        mapper <<< self.ticketTimeId <-- "ticket_time_id"
        
    }
    
    required init() {}
}
