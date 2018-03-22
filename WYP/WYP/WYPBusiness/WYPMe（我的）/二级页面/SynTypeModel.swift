//
//  SynTypeModel.swift
//  WYP
//
//  Created by aLaDing on 2018/3/20.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON
class SynTypeModel: HandyJSON {
    
    var id: String?
    
    var class_name: String?
    
   
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.id <-- "id"
        mapper <<< self.class_name <-- "class_name"

    }
    
    required init() {}
}
