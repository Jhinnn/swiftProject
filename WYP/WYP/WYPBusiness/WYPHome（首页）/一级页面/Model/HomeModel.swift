//
//  HomeModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/24.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import Foundation
import HandyJSON

class HomeModel: HandyJSON {

    // 热门发现
    var hotShowRoom: [ShowroomModel]?
    // 热门剧组
    var hotGroup: [TheaterGroupModel]?
    // 热门话题
    var hotTopics: [TopicsModel]?
    // 热门资讯
    var hotNews: [InfoModel]?
    // 阿拉丁头条
    var headLine: [HeadModel]?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.hotShowRoom <-- "group"
        mapper <<< self.hotGroup <-- "qunzu"
        mapper <<< self.hotTopics <-- "gambit"
        mapper <<< self.hotNews <-- "news"
        mapper <<< self.headLine <-- "headline"
    }
    
    required init() {}
}
