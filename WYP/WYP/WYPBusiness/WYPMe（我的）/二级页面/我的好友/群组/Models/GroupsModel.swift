//
//  GroupsModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/21.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class GroupsModel: HandyJSON {

    // 群组头像
    var groupIconName: String?
    // 群组名称
    var groupTitleName: String?
    
    // 群组id
    var groupId: String?
    // 群组类型
    var groupType: String?
    // 群组名称
    var roomName: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.groupId <-- "id"
        mapper <<< self.groupIconName <-- "photo"
        mapper <<< self.groupTitleName <-- "title"
        mapper <<< self.groupType <-- "type"
        mapper <<< self.roomName <-- "group_name"
    }
    
    required init() {}
}

