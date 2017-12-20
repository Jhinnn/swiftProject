//
//  TheaterGroupModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/19.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class TheaterGroupModel: HandyJSON {

    // 群组名称
    var groupName: String?
    // 项目类型
    var groupRoomType: String?
    // 群组人数
    var groupCount: String?
    // 群组总人数
    var peopleNumber: String?
    // 群id
    var groupId: String?
    // 群icon
    var groupPhoto: String?
    // 群类型
    var groupType: String?
    // 群是否是vip
    var isVip: String?
    // 是否加入 0: 未加入   1: 已加入
    var isJoin: String?
    // 展厅名称
    var roomName: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.roomName <-- "group_name"
        mapper <<< self.groupName <-- "title"
        mapper <<< self.groupRoomType <-- "hjlx"
        mapper <<< self.groupCount <-- "current_number"
        mapper <<< self.peopleNumber <-- "peoplenumber"
        mapper <<< self.groupId <-- "id"
        mapper <<< self.groupPhoto <-- "photo"
        mapper <<< self.groupType <-- "typename"
        mapper <<< self.isVip <-- "jiav"
        mapper <<< self.isJoin <-- "is_join"
    }
    
    required init() {}
}
