//
//  MeidaModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class MediaModel: HandyJSON {

    // 路径
    var address: String?
    // id
    var mediaId: String?
    // 标题
    var title: String?
    // 浏览量
    var view: String?
    // 类型 0 视频 、1 图片
    var type: String?
    
    var duration: Int?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.address <-- "address"
        mapper <<< self.mediaId <-- "id"
        mapper <<< self.title <-- "title"
        mapper <<< self.view <-- "view"
        mapper <<< self.duration <-- "duration"
    }
    
    required init() {}
}
