//
//  InfoReplyModel.swift
//  WYP
//
//  Created by aLaDing on 2018/4/2.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class InfoReplyModel: HandyJSON {
    
//    "id": "29615",
//    "pid": "0",
//    "uid": "918",
//    "news_id": "8034",
//    "content": "不错不错",
//    "cover": "",
//    "create_time": "1516152173",
//    "update_time": "0",
//    "status": "1",
//    "ip": "",
//    "fabulous_number": "0",
//    "type": "0",
//    "view": "4",
//    "level": "1",
//    "allow_reply": "1",
//    "content_text": "不错不错",
//    "content_img": []
    
    
    var id: String?
    
    var pid: String?
    
    var news_id: String?

    var content_text: String?
    
    var fabulous_number: String?
    
    var view: String?
    
    var status: String?
    
    var content_img: [String]?
    
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.id <-- "id"
        mapper <<< self.news_id <-- "news_id"
        mapper <<< self.content_text <-- "content_text"
        mapper <<< self.fabulous_number <-- "fabulous_number"
        mapper <<< self.status <-- "status"
        mapper <<< self.content_img <-- "content_img"
        mapper <<< self.view <-- "view"
    }
    
    required init() {}
}
