//
//  GimbitModel.swift
//  WYP
//
//  Created by aLaDing on 2018/4/3.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class GimbitModel: HandyJSON {
    
    var id: String?
    
    var class_name: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.id <-- "id"
        mapper <<< self.class_name <-- "class_name"
    }
    
    required init() {}

}
