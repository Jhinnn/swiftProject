//
//  ShowRoomDetailModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/19.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class ShowRoomDetailModel: HandyJSON {
    
    // 展厅相关信息
    var roomInfo: RoomInfoModel?
    // 属性
    var attribution: AttributionModel?
    // 公告
    
    // 媒体库
    var image: [MediaModel]?
    var video: [MediaModel]?
    
    // 群组
    var group: [TheaterGroupModel]?
    // 项目成员
    var member: [MemberModel]?
    // 话题
    var gambit: [InfoModel]?
    
    // 资讯
    var recentNews: [InfoModel]?
    // 评论
    var comment: [CommentModel]?
    // 公告
    var announ: [AnnouncementModel]?
    
    var dynamic: [StatementModel]?
    
    //评论数量
    var plcount: String?
    

    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.roomInfo <-- "xiangqing"
        mapper <<< self.attribution <-- "attr"
        mapper <<< self.image <-- "image"
        mapper <<< self.video <-- "video"
        mapper <<< self.group <-- "group_count"
        mapper <<< self.member <-- "Mon"
        mapper <<< self.recentNews <-- "new"
        mapper <<< self.comment <-- "pinglun"
        mapper <<< self.announ <-- "announcement"
        mapper <<< self.plcount <-- "plcount"
        mapper <<< self.dynamic <-- "dynamic"
    }
    
    required init() {}
    
}

