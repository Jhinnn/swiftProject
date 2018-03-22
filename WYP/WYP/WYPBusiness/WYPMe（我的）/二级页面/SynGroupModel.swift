//
//  SynGroupModel.swift
//  WYP
//
//  Created by aLaDing on 2018/3/20.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON
class SynGroupModel: HandyJSON {
    var id: String?
    
    var title: String?
    
    var photo: String?
    var group_id: String?
    var group_title: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.id <-- "id"
        mapper <<< self.title <-- "title"
        mapper <<< self.photo <-- "photo"
        mapper <<< self.group_id <-- "group_id"
        mapper <<< self.group_title <-- "group_title"
    }
    
    required init() {}
}
