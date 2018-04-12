//
//  ChoiceTopic.swift
//  WYP
//
//  Created by aLaDing on 2018/4/8.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class ChoiceTopicModel: HandyJSON {
    
    /*
     "content": "内容太少了。",
     "nickname": "苔痕",
     "avatar128": "http://ald.com/Uploads/Avatar/916/5a936223aaa32.png",
     "category": "演出文化",
     "is_like": "0",
     "like_num": "0",
     "cover_url": [
     "http://ald.com/Uploads/Gambit/916/5a71281d35e6c.jpg"
     ]
 
 */
    var id: String?
    var uid: String?
    var description: String?
    var title: String?
    var topic: String?
    var create_time: String?
    var comment: String?
    var view: String?
    var cover: String?
    var type: String?
    var new_type: String?
    
    var content: String?
    var nickname: String?
    var avatar128: String?
    var category: String?
    var is_like: String?
    var like_num: String?
    var cover_url: [String]?
    
    var choiceTopicReplyModel: ChoiceTopicReplyModel?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.uid <-- "uid"
        mapper <<< self.id <-- "id"
        mapper <<< self.description <-- "description"
        mapper <<< self.title <-- "title"
        mapper <<< self.topic <-- "topic"
        mapper <<< self.create_time <-- "create_time"
        mapper <<< self.comment <-- "comment"
        mapper <<< self.view <-- "view"
        mapper <<< self.cover <-- "cover"
        mapper <<< self.type <-- "type"
        mapper <<< self.new_type <-- "new_type"
        
        mapper <<< self.content <-- "content"
        mapper <<< self.nickname <-- "nickname"
        mapper <<< self.avatar128 <-- "avatar128"
        mapper <<< self.category <-- "category"
        mapper <<< self.is_like <-- "is_like"
        mapper <<< self.like_num <-- "like_num"
        mapper <<< self.cover_url <-- "cover_url"
        mapper <<< self.choiceTopicReplyModel <-- "reply"
    }
    
    required init() {}
}
