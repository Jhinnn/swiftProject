//
//  TicketTimeCell.swift
//  WYP
//
//  Created by 你个LB on 2017/4/27.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class TicketTimeCell: UICollectionViewCell {
    // 时间
    @IBOutlet weak var timeButton: UIButton!
    // 票数
    @IBOutlet weak var ticketCount: UILabel!
    // 抢票数
    @IBOutlet weak var lotteryCount: UILabel!
    
    var timeModel: TicketTimeModel? {
        willSet {
            
            let time = Int(newValue?.ticketTime ?? "")?.getTimeString()
            
            let date: Date = Date(timeIntervalSince1970: TimeInterval(newValue?.ticketTime ?? "")!)
            
//            String.init(format: "%@\n%@", time!, date.weekDay())
            timeButton.setTitle("\(time!)\n    \(date.weekDay())", for: .normal)
            timeButton.titleLabel?.numberOfLines = 0
            ticketCount.text = String.init(format: "共有%@张票", newValue?.ticketNumber ?? "0")
            lotteryCount.text = String.init(format: "%@人参与抢票", newValue?.ticketPeople ?? "0")
            
            timeButton.layer.borderWidth = 1
            timeButton.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                timeButton.backgroundColor = UIColor.themeColor
                timeButton.setTitleColor(UIColor.white, for: .normal)
            } else {
                timeButton.backgroundColor = UIColor.white
                timeButton.setTitleColor(UIColor.black, for: .normal)
            }
        }
    }
}

extension Date {
    
    func weekDay() ->String {
        let weekDays = [NSNull.init(),"星期日","星期一","星期二","星期三","星期四","星期五","星期六"] as [Any]
        
        let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
        let timeZone = NSTimeZone.init(name:"Asia/Shanghai")
        
        calendar?.timeZone = timeZone! as TimeZone
        
        let calendarUnit = NSCalendar.Unit.weekday
        
        let theComponents = calendar?.components(calendarUnit, from:self)
        
        let weekday = weekDays[(theComponents?.weekday)!]as! String
        
        return weekday
    }
}
