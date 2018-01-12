//
//  CommunityModel.swift
//  WYP
//
//  Created by Arthur on 2018/1/11.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class CommunityModel: HandyJSON {

    
    var id: String?
    
    var uid: String?

    var path: String?
    var dynamic_path: [String]?
    var create_time: String?
    var nickname: String?
    var content: String?
    
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.id <-- "id"
        mapper <<< self.uid <-- "uid"
        mapper <<< self.path <-- "path"
        mapper <<< self.dynamic_path <-- "dynamic_path"
        mapper <<< self.create_time <-- "create_time"
        mapper <<< self.nickname <-- "nickname"
        mapper <<< self.content <-- "content"

    }
    
    required init() {}
    
}
