//
//  TicketVernveModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/27.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import HandyJSON

class TicketVernveModel: HandyJSON {

    // 场馆Id
    var vernveId: String?
    // 场馆名称
    var vernveName: String?
    // 场馆经度
    var vernveLongitude: String?
    // 场馆纬度
    var vernveLatitude: String?
    // 场馆位置
    var vernveAddress: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.vernveId <-- "id"
        mapper <<< self.vernveName <-- "vernve_name"
        mapper <<< self.vernveLongitude <-- "longitude"
        mapper <<< self.vernveLatitude <-- "latitude"
        mapper <<< self.vernveAddress <-- "adresse"
    }
    
    required init() {}
}
