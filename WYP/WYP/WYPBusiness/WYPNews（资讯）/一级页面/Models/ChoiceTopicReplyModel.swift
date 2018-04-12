//
//  ChoiceTopicReplyModel.swift
//  WYP
//
//  Created by aLaDing on 2018/4/8.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class ChoiceTopicReplyModel: HandyJSON {
    var id: String?
    var uid: String?
    var pid: String?
    var news_id: String?
    var content: String?
    var cover: String?
    var create_time: String?
    var update_time: String?
    var status: String?
    var fabulous_number: String?
    var type: String?

    var view: String?
    var level: String?
    var allow_reply: String?
    var selected: String?
    var nickname: String?
    
    var avatar128: String?
    var content_text: String?
    var content_img: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.uid <-- "uid"
        mapper <<< self.id <-- "id"
        mapper <<< self.pid <-- "pid"
        mapper <<< self.news_id <-- "news_id"
        mapper <<< self.content <-- "content"
        mapper <<< self.create_time <-- "create_time"
        mapper <<< self.cover <-- "cover"
        mapper <<< self.update_time <-- "update_time"
        
        mapper <<< self.status <-- "status"
        mapper <<< self.fabulous_number <-- "fabulous_number"
        mapper <<< self.type <-- "type"
        mapper <<< self.view <-- "view"
        
        mapper <<< self.level <-- "level"
        mapper <<< self.allow_reply <-- "allow_reply"
        
        mapper <<< self.selected <-- "selected"
        mapper <<< self.nickname <-- "nickname"
        mapper <<< self.avatar128 <-- "avatar128"
        mapper <<< self.content_text <-- "content_text"
        mapper <<< self.content_img <-- "content_img"
        
    }
    
    required init() {}
}
