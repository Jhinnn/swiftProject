//
//  ExhibitionModel.swift
//  WYP
//
//  Created by Arthur on 2018/1/22.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class ExhibitionModel: HandyJSON {
    
    // 是否置顶 0:未置顶  1：置顶
    var title: String?
    // 标题
    var id: String?
    // 竖版
    var pid: String?
    // 图片
    var level: String?

    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.title <-- "title"
        mapper <<< self.id <-- "id"
        mapper <<< self.pid <-- "pid"
        mapper <<< self.level <-- "level"
    }
    
    
    required init() {}
}
