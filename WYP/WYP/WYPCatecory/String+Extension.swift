//
//  String+Extension.swift
//  WYP
//
//  Created by 你个LB on 2017/3/7.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 正则表达式
extension String {
    
    /// 判断是否是手机号码
    ///
    /// - Returns: 是否是手机号码
    public func isMobileTelephoneNumber() -> Bool {
        //
        let regexp = "^1[3,5,7,8]([0-9]{9})$"
        //
        return isMatches(regexp: regexp)
    }
    
    /*
     * 判断用户输入的密码是否符合规范，符合规范的密码要求：
       1. 长度大于8位
       2. 密码中必须同时包含数字和字母
     */
    public func isPasswordValid() -> Bool {
        var result = false
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        if characters.count > 7 && characters.count < 17 {
            let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
            result = isMatches(regexp: regex)
        }
        return result
    }
    
    
    // 判断是否是密码
    public func isPassword() -> Bool {
        // 
        if characters.count > 6 && characters.count < 17 {
            return true
        }
        return false
    }
    
    /// 判断是否是邮箱
    ///
    /// - Returns: 是否是手机号码
    public func isEmailAddress() -> Bool {
        //
        let regexp = "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$"
        //
        return isMatches(regexp: regexp)
    }
    
    /// 判断是否是身份证号码
    ///
    /// - Returns: 是否是身份证号码
    public func IDCardNumber() -> Bool {
        //
        let regexp = "(^\\d{18}$)|(^\\d{15}$)"
        //
        return isMatches(regexp: regexp)
    }
    
    /// 判断是否匹配
    ///
    /// - Parameter regexp: 正则表达式字符串
    /// - Returns: 是否匹配
    private func isMatches(regexp: String) -> Bool {
        //
        let predicate = NSPredicate(format: "SELF MATCHES %@", regexp)
        //
        return predicate.evaluate(with: self)
    }
    
    
    /*
     *  时间戳转时间
     */
    func timeStampToString(timeStamp: String) -> String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date as Date)
    }
    
    /*
     *  时间戳转时间
     */
    func timeStampToString2(timeStamp: String) -> String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date as Date)
    }
    
    
    /*
     *  比较是否已过期
     */
    func getCurrentDate() -> Double {
        let date = Date(timeIntervalSinceNow: 0)
        let timeInterval = date.timeIntervalSince1970
        
        return timeInterval
    }
    
    /// 计算文字尺寸
    ///
    /// - Parameters:
    ///   - text: 需要计算尺寸的文字
    ///   - font: 文字的字体
    ///   - maxSize: 文字的最大尺寸
    /// - Returns: 文字尺寸
    func stringSize(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 5 //设置行间距
        let attrs = [NSParagraphStyleAttributeName: paraStyle,
                     NSKernAttributeName: 1.5,
                     NSFontAttributeName: font] as [String : Any]
        
        return text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attrs, context: nil).size
    }
}
