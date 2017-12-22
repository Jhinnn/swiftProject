//
//  ManagerGroupInfoModel.swift
//  WYP
//
//  Created by aLaDing on 2017/12/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

import HandyJSON

class ManagerGroupInfoModel: HandyJSON {
    
    var current : String?
    // 可用总人数
    var people : String?
    // 是否开启入群验证1开启0不开启
    var check : String?
    
    required init(){}
}
