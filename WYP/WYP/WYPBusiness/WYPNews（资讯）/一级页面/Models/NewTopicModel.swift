//
//  NewTopicModel.swift
//  WYP
//
//  Created by aLaDing on 2018/4/2.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class NewTopicModel: HandyJSON {

    /*
    "id": "4608",
    "description": "《城市之光》曝“你没见过的刘诗诗”特辑",
    "topic": "13",
    "create_time": "1512640744",
    "comment": "13",
    "view": "634",
    "cover": "12324875",
    "new_type": "3",
    "content": "在跳高架桥一场戏中，为了达到最完美的效果，她一晚上跳了三四十次，被邓超大赞“行动力很强”，导演徐纪周也表示：“相信大家会看到一个完全不一样的刘诗诗。”</p><p>该片由上海电影(集团)有限公司、安乐(北京)电影发行有限公司、霍尔果斯橙子映像传媒有限公司、海宁月亮开花影视文化有限公司、安乐影片有限公司、万诱引力有限公司、霍尔果斯青春光线影业有限公司、天津猫眼文化传媒有限公司出品。影片由徐纪周导演并编剧，任仲伦、江志强监制、由雷米同名小说改编，邓超、阮经天、刘诗诗主演，林嘉欣特别出演，郭京飞、雷米友情出演。本片将于12月22日全国上映",
    "nickname": "满腹书香",
    "avatar128": "http://ald.com/Uploads/Avatar/918/5a2f771d17f91.png",
    "uid": "918",
    "category": "演出文化",
    "is_like": "0",
    "like_num": "1",
    "cover_url": [
    "http://ald.com/Uploads/ziXun/1/151261e70c7.jpg"
    ]
    */
    
    var id: String?
    
    var description: String?
    
    var topic: String?
    
    var create_time: String?
    
    var comment: String?
    
    var view: String?
    
    var cover: String?
    
    var new_type: String?
    
    var content: String?
    
    var nickname: String?
    
    var avatar128: String?
    
    var uid: String?
    
    var category: String?
    
    var is_like: String?
    
    var like_num: String?
    
    var cover_url: [String]?
    
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.id <-- "id"
        mapper <<< self.description <-- "description"
        mapper <<< self.topic <-- "topic"
        mapper <<< self.create_time <-- "create_time"
        mapper <<< self.comment <-- "comment"
        mapper <<< self.view <-- "view"
        mapper <<< self.cover <-- "cover"
        mapper <<< self.new_type <-- "new_type"
        mapper <<< self.content <-- "content"
        mapper <<< self.nickname <-- "nickname"
        mapper <<< self.avatar128 <-- "avatar128"
        mapper <<< self.uid <-- "uid"
        mapper <<< self.category <-- "category"
        mapper <<< self.is_like <-- "is_like"
        mapper <<< self.like_num <-- "like_num"
        mapper <<< self.cover_url <-- "cover_url"
       
    }
    
     required init() {}
}
