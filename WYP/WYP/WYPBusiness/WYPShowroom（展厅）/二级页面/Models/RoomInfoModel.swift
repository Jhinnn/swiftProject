//
//  RoomInfoModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/21.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class RoomInfoModel: HandyJSON {

    // 展厅图片
    var background: String?
    // 竖版图片
    var logo: String?
    // 展厅名称
    var title: String?
    // 演出单位
    var unit: String?
    // 项目认证 0:未认证 1：项目认证
    var isProject: Int?
    // 企业认证 0:未认证 1：企业认证
    var isCommpany: Int?
    // 展厅介绍
    var detail: String?
    // 展厅分类
    var typeId: Int?
    // 是否收藏该展厅
    var isLike: Int?
    // 关注数
    var followedCount: String?
    // 是否关联票务
    var isTicket: Int?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.background <-- "background"
        mapper <<< self.logo <-- "logo"
        mapper <<< self.title <-- "title"
        mapper <<< self.detail <-- "detail"
        mapper <<< self.isCommpany <-- "type"
        mapper <<< self.typeId <-- "type_id"
        mapper <<< self.isProject <-- "is_project"
        mapper <<< self.isLike <-- "is_like"
        mapper <<< self.followedCount <-- "like_num"
        mapper <<< self.isTicket <-- "is_ticket"
    }
    
    required init() {}

}
