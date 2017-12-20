//
//  VideoInfoModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/15.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class VideoInfoModel: HandyJSON {

    // 视频Id
    var videoId: String?
    // 视频封面
    var videoPic: String?
    // 视频标题
    var videoTitle: String?
    // 视频信息
    var videoDetail: String?
    // 视频地址
    var videoAddress: String?
    // 视频浏览量
    var videoSee: Int?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.videoId <-- "id"
        mapper <<< self.videoPic <-- "photo"
        mapper <<< self.videoTitle <-- "title"
        mapper <<< self.videoDetail <-- "info"
        mapper <<< self.videoAddress <-- "video"
        mapper <<< self.videoSee <-- "view"
    }
    
    required init() {}
}
