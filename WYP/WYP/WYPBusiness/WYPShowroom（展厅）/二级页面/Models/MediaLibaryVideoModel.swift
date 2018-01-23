//
//  MediaLibaryModel.swift
//  WYP
//
//  Created by Arthur on 2018/1/22.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class MediaLibaryVideoModel: HandyJSON {

    
    var id: String?
    var title: String?
    
    var address: String?
    var view: String?
   
    var place: String?
    
    var duration: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.id <-- "id"
        mapper <<< self.title <-- "title"
        mapper <<< self.address <-- "address"
        mapper <<< self.view <-- "view"
        mapper <<< self.place <-- "place"
        mapper <<< self.duration <-- "duration"
    }
    
    required init() {}
}
