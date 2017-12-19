//
//  ShowroomModel.swift
//  WYP
//
//  Created by 你个LB on 2017/3/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class ShowroomModel: HandyJSON {

    // 是否置顶 0:未置顶  1：置顶
    var isTop: String?
    // 标题
    var title: String?
    // 竖版
    var logo: String?
    // 图片
    var background: String?
    // 项目认证 0:未认证  1:认证
    var isProject: Int?
    // 企业认证 0:未认证  1:认证
    var isCompany: Int?
    // 剧目类型
    var groupTypeName: String?
    // 群组数
    var groupCount: String?
    // 评论数
    var contentCount: String?
    // 关注数
    var groupFollow: String?
    // 粉丝数
    var fensiCount: String?
    // 是否上映 0：未上映  1：已上映
    var showStatus: String?
    // 展厅id
    var groupId: String?
    // 是否最热 0：热 1：不热
    var isHot: String?
    // 是否免费 0.免费  1.收费
    var isFree: String?

    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.isTop <-- "is_top"
        mapper <<< self.title <-- "title"
        mapper <<< self.logo <-- "logo"
        mapper <<< self.background <-- "background"
        mapper <<< self.groupTypeName <-- "group_type_name"
        mapper <<< self.groupCount <-- "group_count"
        mapper <<< self.contentCount <-- "content_count"
        mapper <<< self.groupFollow <-- "group_follow"
        mapper <<< self.fensiCount <-- "fensi_count"
        mapper <<< self.showStatus <-- "show"
        mapper <<< self.groupId <-- "id"
        mapper <<< self.isHot <-- "heat"
        mapper <<< self.isProject <-- "is_project"
        mapper <<< self.isCompany <-- "type"
        mapper <<< self.isFree <-- "is_spend"
    }
    
    
    required init() {}
}
