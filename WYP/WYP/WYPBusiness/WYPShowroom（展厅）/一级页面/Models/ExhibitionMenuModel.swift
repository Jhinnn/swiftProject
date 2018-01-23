//
//  ExhibitionMenuModel.swift
//  WYP
//
//  Created by Arthur on 2018/1/22.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class ExhibitionMenuModel: HandyJSON {
    
    
    var first: String?
    
    var second: String?
    
    var groupId: String?
    
    var isHot: String?
    
    
    var isFree: String?
    

    func mapping(mapper: HelpingMapper) {
      
    }
    
    
    required init() {}
}
