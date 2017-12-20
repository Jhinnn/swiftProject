//
//  RecordsDetailFrameModel.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/12.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class RecordsDetailFrameModel: NSObject {

    // 用户头像的frame
    var userImageF: CGRect?
    // 昵称的frame
    var nickNameF: CGRect?
    // 内容的frame
    var contentF: CGRect?
    // 时间的frame
    var timeF: CGRect?
    // 单元格的高度
    var cellHeight: CGFloat?
    
    // 数据模型
    var recordModel: RecordsDetailModel? {
        willSet {
            switch newValue?.recordType ?? 0 {
            case 1:
                userImageF = CGRect(x: 30, y: 20, width: 36, height: 36)
                break
            case 2:
                userImageF = CGRect(x: 13, y: 20, width: 36, height: 36)
                break
            default:
                break
            }
            nickNameF = CGRect(x: (userImageF?.minX)! - 8, y: (userImageF?.maxY)! + 10, width: 50, height: 13)
            let contentSize = String().stringSize(text: (newValue?.content)!, font: UIFont.systemFont(ofSize: 14), maxSize: CGSize(width: kScreen_width - (userImageF?.maxX)! - 20, height: 500))
            contentF = CGRect(x: (nickNameF?.maxX)! + 5, y: 20, width: kScreen_width - (userImageF?.maxX)! - 20, height: contentSize.height)
            timeF = CGRect(x: 100, y: (userImageF?.maxY)! + 10, width: kScreen_width - 120, height: 11)
            
            cellHeight = (timeF?.maxY)! + 10
        }
    }
    
}
