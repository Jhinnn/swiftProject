//
//  RecordModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/9.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class RecordModel: HandyJSON {

    // 反馈Id
    var recordId: String?
    // 反馈标题
    var recordTitle: String?
    // 反馈时间
    var recordTime: String?
    // 唯一标识
    var recordCode: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.recordId <-- "id"
        mapper <<< self.recordTitle <-- "content"
        mapper <<< self.recordTime <-- "create_time"
        mapper <<< self.recordCode <-- "vy_id"
    }
    
    required init() {}
}
