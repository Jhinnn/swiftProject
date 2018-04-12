//
//  SearchGambitModel.swift
//  WYP
//
//  Created by aLaDing on 2018/4/2.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON


class SearchGambitModel: HandyJSON {
    var id: String?
    
    var title: String?
    
    var comment: String?
    
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.id <-- "id"
        mapper <<< self.title <-- "title"
        mapper <<< self.comment <-- "comment"

    }
    
    required init() {}
}
