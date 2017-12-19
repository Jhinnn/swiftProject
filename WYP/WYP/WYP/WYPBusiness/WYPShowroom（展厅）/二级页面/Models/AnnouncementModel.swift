//
//  AnnouncementModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/11.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class AnnouncementModel: HandyJSON {

    // 公告标题
    var announTitle: String?
    var announId: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.announTitle <-- "title"
        mapper <<< self.announId <-- "id"
    }
    
    required init() {}
}
