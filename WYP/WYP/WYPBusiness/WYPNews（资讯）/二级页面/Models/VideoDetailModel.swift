//
//  VideoDetailModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/28.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class VideoDetailModel: HandyJSON {

    // 路径
    var videoPath: String?
    // 时长
    var videoDuration: String?
    // 标题
    var videoTitle: String?
    // 详情
    var videoDetail: String?
    // 视频来源
    var videoSource: String?
    // 视频创建时间
    var videoCreateTime: Int?
    // 视频点赞数
    var videoLikeNumber: String?
    // 是否点赞
    var isStar: String?
    // 是否关注该资讯
    var isFollow: String?
    // 视频评论数
    var videoCommentNumber: String?
    // 视频浏览数
    var videoSeeNumber: String?
    // 评论
    var comment: [CommentModel]?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.videoPath <-- "path"
        mapper <<< self.videoDuration <-- "time_long"
        mapper <<< self.videoTitle <-- "title"
        mapper <<< self.videoDetail <-- "description"
        mapper <<< self.videoSource <-- "source"
        mapper <<< self.videoCreateTime <-- "create_time"
        mapper <<< self.videoLikeNumber <-- "fabulousCount"
        mapper <<< self.isStar <-- "zan"
        mapper <<< self.isFollow <-- "follow"
        mapper <<< self.videoSeeNumber <-- "view"
        mapper <<< self.comment <-- "comments"
        // 评论数
        mapper <<< self.videoCommentNumber <-- "comment_num"
    }
    
    required init() {}
}
