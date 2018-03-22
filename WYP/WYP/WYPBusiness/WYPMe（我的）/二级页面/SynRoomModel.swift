//
//  SynRoomModel.swift
//  WYP
//
//  Created by aLaDing on 2018/3/20.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON
class SynRoomModel: HandyJSON {
    var id: String?
    
    var title: String?
    
    var logo: String?
    var path: String?
  
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.id <-- "id"
        mapper <<< self.title <-- "title"
        mapper <<< self.logo <-- "logo"
        mapper <<< self.path <-- "path"
    }
    
    required init() {}
}
