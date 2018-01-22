//
//  HomeSearcModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import Foundation
import HandyJSON

class HomeSearcModel: HandyJSON {

    // 票务
    var tickets: [TicketModel]?
    // 资讯
    var news: [InfoModel]?
    // 发现
    var rooms: [ShowroomModel]?
    
    //话题
    var gambit: [InfoModel]?
    
    //社区
    var community: [StatementModel]?
    
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.tickets <-- "ticket"
        mapper <<< self.news <-- "News"
        mapper <<< self.rooms <-- "group"
        mapper <<< self.gambit <-- "Gambit"
        mapper <<< self.community <-- "Dynamic"
    }
    
    required init() {}
}
