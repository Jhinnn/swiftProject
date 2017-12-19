//
//  CityModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/7/3.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import Foundation
import HandyJSON

class CityModel: HandyJSON {
    
    var cityName: String?
    var cityId: String?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.cityName <-- "name"
        mapper <<< self.cityId <-- "id"
    }
    
    required init() {}
}
