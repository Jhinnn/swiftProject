//
//  GroupNoteModel.swift
//  WYP
//
//  Created by aLaDing on 2017/12/19.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import HandyJSON
import UIKit

class GroupNoteModel : HandyJSON {
    
    // 群公告 标题
    var title : String?
    // 详情
    var content : String?
    // 发布时间
    var create_time : String?
    // 图片
    var path : [String]?
    // 是否置顶
    var is_top : String?
    // 发布人
    var author : String?
    // 浏览量
    var view : String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.content <-- "description"
    }
    
    required init() {
        
    }
}
