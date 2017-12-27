//
//  ApplyGroupModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class ApplyGroupModel: HandyJSON {

    // 群成员
    var groupMember: [PersonModel]?
    // 群简介
    var groupDetail: String?
    // 群头像
    var group_avatar : String?
    // 群公告
    var board : String?
    // 成员等级
    var rank : String?
    
    // 成员等级
    var aldrid : String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.groupMember <-- "user"
        mapper <<< self.groupDetail <-- "Introduction"
        mapper <<< self.aldrid <-- "aldrid"
    }

    required init() {}
}
