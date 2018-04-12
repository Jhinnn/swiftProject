//
//  ExpertModel.swift
//  WYP
//
//  Created by aLaDing on 2018/4/4.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class ExpertModel: HandyJSON {
    var uid: String?
    var nickname: String?
    var avatar: String?
    var signature: String?
    var is_follow: String?
    var is_v: String?
    var v_info: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.uid <-- "uid"
        mapper <<< self.nickname <-- "nickname"
        mapper <<< self.avatar <-- "avatar"
        mapper <<< self.signature <-- "signature"
        mapper <<< self.is_follow <-- "is_follow"
        mapper <<< self.is_v <-- "is_v"
        mapper <<< self.v_info <-- "v_info"
    
    }
    
    required init() {}
}
