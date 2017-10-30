//
//  AttentionRoomModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/8.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class AttentionRoomModel: HandyJSON {

    // 展厅名称
    var roomTitle: String?
    // 展厅Id
    var roomId: String?
    // 展厅图片
    var roomPhoto: String?
    // 竖版图片
    var logo: String?
    // 展厅介绍
    var roomDetail: String?
    // 展厅活动
    var roomActivity: String?
    // 展厅成员
    var roomMember: String?
    // 是否免费
    var isFree: String?
    
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.roomTitle <-- "title"
        mapper <<< self.roomId <-- "id"
        mapper <<< self.roomPhoto <-- "background"
        mapper <<< self.logo <-- "logo"
        mapper <<< self.roomDetail <-- "detail"
        mapper <<< self.roomActivity <-- "event"
        mapper <<< self.roomMember <-- "member"
        mapper <<< self.isFree <-- "is_spend"
    }
    
    required init() {}
}
