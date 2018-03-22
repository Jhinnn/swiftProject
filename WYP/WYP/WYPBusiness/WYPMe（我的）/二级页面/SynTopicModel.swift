//
//  SynTopicModel.swift
//  WYP
//
//  Created by aLaDing on 2018/3/20.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON
class SynTopicModel: HandyJSON {
    var id: String?
    
    var title: String?
    
    var topic: String?
    var create_time: String?
    var comment: String?
    
    var view: String?
    
    var cover: String?
    
    var new_type: String?
    var class_name: String?
    var cover_url: [String]?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.id <-- "id"
        mapper <<< self.title <-- "title"
        mapper <<< self.topic <-- "topic"
        mapper <<< self.create_time <-- "create_time"
        mapper <<< self.comment <-- "comment"
        mapper <<< self.view <-- "view"
        mapper <<< self.cover <-- "cover"
        mapper <<< self.new_type <-- "new_type"
        mapper <<< self.class_name <-- "class_name"
        mapper <<< self.cover_url <-- "cover_url"
    }
    
    required init() {}
}
