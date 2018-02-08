//
//  IntelligentModel.swift
//  WYP
//
//  Created by Arthur on 2018/2/1.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class IntelligentModel: HandyJSON {

    var avatar: String?
    
    var uid: String?
    
    var reply_count: String?
    
    var nickname: String?
    
    var is_follow: String?
    
    var signature: String?
    
    var is_v: String?
    
    var is_invite: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.avatar <-- "avatar"
        mapper <<< self.uid <-- "uid"
        mapper <<< self.reply_count <-- "reply_count"
        mapper <<< self.nickname <-- "nickname"
        mapper <<< self.is_follow <-- "is_follow"
        mapper <<< self.signature <-- "signature"
        mapper <<< self.is_v <-- "is_v"
        mapper <<< self.is_invite <-- "is_invite"
     
    }
    
    required init() {}
}
