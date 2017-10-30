//
//  Int+Extension.swift
//  WYP
//
//  Created by 你个LB on 2017/3/7.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 时间戳转自定义时间
public extension Int {
    
    var currentTimeInterval : TimeInterval {
        return NSDate().timeIntervalSince1970
    }
    
    //MARK: 根据规则返回对应的字符串
    public func getTimeString() -> String {
        if isToday {
            if minute < 5 {
                return "刚刚"
            } else if hour < 1 {
                return "\(minute)分钟之前"
            } else {
                return "\(hour)小时之前"
            }
        } else if isYesterday {
            return "昨天 \(self.yesterdayTimeStr())"
        } else if isYear {
            return noYesterdayTimeStr()
        } else {
            return yearTimeStr()
        }
    }
    
    fileprivate var selfDate : Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
    
    /// 距当前有几分钟
    var minute : Int {
        let dateComponent = Calendar.current.dateComponents([.minute], from: selfDate, to: Date())
        return dateComponent.minute!
    }
    
    /// 距当前有几小时
    var hour : Int {
        let dateComponent = Calendar.current.dateComponents([.hour], from: selfDate, to: Date())
        return dateComponent.hour!
    }
    
    /// 是否是今天
    var isToday : Bool {
        return Calendar.current.isDateInToday(selfDate)
    }
    
    /// 是否是昨天
    var isYesterday : Bool {
        return Calendar.current.isDateInYesterday(selfDate)
    }
    
    /// 是否是今年
    var isYear: Bool {
        let nowComponent = Calendar.current.dateComponents([.year], from: Date())
        let component = Calendar.current.dateComponents([.year], from: selfDate)
        return (nowComponent.year == component.year)
    }
    
    fileprivate func yesterdayTimeStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        return format.string(from: selfDate)
    }
    
    fileprivate func noYesterdayTimeStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "MM-dd HH:mm"
        return format.string(from: selfDate)
    }
    
    fileprivate func yearTimeStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        return format.string(from: selfDate)
    }
}
