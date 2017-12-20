//
//  RecordsDetailModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/12.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class RecordsDetailModel: HandyJSON {

    // 用户或客服的头像
    var userImage: String?
    // 用户或客服的昵称
    var userNickName: String?
    // 时间
    var createTime: String?
    // 内容
    var content: String?
    // 类型 1：客服 2：用户
    var recordType: Int?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.userImage <-- "avatar"
        mapper <<< self.userNickName <-- "nickname"
        mapper <<< self.createTime <-- "create_time"
        mapper <<< self.content <-- "content"
        mapper <<< self.recordType <-- "type"
    }
    
    required init() {}
}
