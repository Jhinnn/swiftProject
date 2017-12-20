//
//  AttributionModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/11.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class AttributionModel: HandyJSON {

    // 演出单位
    var first: String?
    // 导演
    var second: String?
    // 制片人
    var third: String?
    // 剧长
    var fourth: String?
    // 首演时间
    var fifth: String?
    // 国家
    var sixth: String?
    // 剧目类型
    var playType: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.first <-- "field1"
        mapper <<< self.second <-- "field2"
        mapper <<< self.third <-- "field3"
        mapper <<< self.fourth <-- "field4"
        mapper <<< self.fifth <-- "field5"
        mapper <<< self.sixth <-- "field6"
        mapper <<< self.playType <-- "jvmu"
    }
    
    required init() {}
}
