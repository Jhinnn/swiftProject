//
//  HeadModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/9/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import Foundation
import HandyJSON

class HeadModel: HandyJSON {
    
    // 轮播标题
    var text: String?
    // 资讯Id
    var newsId: String?
    
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.text <-- "text"
        mapper <<< self.newsId <-- "id"
    }
    
    required init() {}
}

