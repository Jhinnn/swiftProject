//
//  InfoModel.swift
//  InfoView
//
//  Created by ShuYan Feng on 2017/3/16.
//  Copyright © 2017年 ShuYan Feng. All rights reserved.
//

import Foundation
import HandyJSON

class InfoModel: HandyJSON {
    
    // 图集的封面
    var photosCover: String?
    // 资讯图片数组
    var infoImageArr: [String]?
    // 资讯图集内容数组
    var contentArray: [String]?
    // 资讯名称
    var infoTitle: String?
    // 资讯来源
    var infoSource: String?
    // 资讯发布时间
    var infoTime: Int?
    // 资讯浏览量
    var infoLook: String?
    // 资讯评论量
    var infoComment: String?
    // 资讯类型 （1.新闻 2.视频 3.问答 4.图集）
    var infoType: Int?
    // 新闻显示类型 (1.文字 2.上图下文 3.左文有图 4.三张图 5.大图)
    var showType: Int?
    // 是否置顶 0：未置顶  1：置顶
    var isTop: String?
    // 是否是广告 0：不是广告 1：是广告
    var isAd: String?
    // 热度 0: 热 1：不热
    var isHot: String?
    // 视频的时长
    var duration: Int?
    // id
    var newsId: String?
    // 是否 已关注  0：未关注  1：已关注
    var isFollow: String?
    // 广告链接
    var advLink: String?
    // 资讯状态
    var status: String?
    //话题类别
    var topic: String?
    
    
    
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.photosCover <-- "fengMian"
        mapper <<< self.infoImageArr <-- "cover_url"
        mapper <<< self.contentArray <-- "cover_url_title"
        mapper <<< self.infoTitle <-- "title"
        mapper <<< self.infoSource <-- "source"
        mapper <<< self.infoTime <-- "create_time"
        mapper <<< self.infoLook <-- "view"
        mapper <<< self.infoComment <-- "comment"
        mapper <<< self.infoType <-- "type"
        mapper <<< self.showType <-- "new_type"
        mapper <<< self.isTop <-- "is_top"
        mapper <<< self.isAd <-- "is_adv"
        mapper <<< self.isHot <-- "heat"
        mapper <<< self.duration <-- "time_long"
        mapper <<< self.newsId <-- "id"
        mapper <<< self.isFollow <-- "is_follow"
        mapper <<< self.advLink <-- "adv_url"
        mapper <<< self.status <-- "status"
        mapper <<< self.topic <-- "topic"
    }
    
    required init() {}
}
