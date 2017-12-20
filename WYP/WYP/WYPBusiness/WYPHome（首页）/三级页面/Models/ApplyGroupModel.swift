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
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.groupMember <-- "user"
        mapper <<< self.groupDetail <-- "Introduction"
    }

    required init() {}
}
