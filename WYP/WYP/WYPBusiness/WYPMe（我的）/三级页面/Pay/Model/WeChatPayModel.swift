
//
//  WeChatPayModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/7/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import Foundation
import HandyJSON

class WeChatPayModel: HandyJSON {
    
    // 应用ID
    var appId: String?
    // 商户号
    var partnerId: String?
    // 预支付交易会话Id
    var prepayId: String?
    // 扩展字段
    var package: String?
    // 随机字符串
    var noncestr: String?
    // 时间戳
    var timeStamp: String?
    // 签名
    var sign: String?
    
    func mapping(mapper: HelpingMapper) {
        
    }
    
    required init() {
        
    }
}
