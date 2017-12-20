//
//  LBCodeButton.swift
//  CodeButton
//
//  Created by 你个LB on 2017/3/23.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

public enum SendCodeState {
    case prepareSend  // 准备发送
    case sending  // 正在发送
    case alreadySend  // 已经发送
}

protocol LBCodeButtonDelegate {
    // 按钮状态
    func codeButton(codeButton: LBCodeButton, state: SendCodeState)
}

class LBCodeButton: UIButton {
    
    // 计时总秒数  (默认值是  10)
    public let seconds: UInt = 60
    
    // 代理对象
    public var delegate: LBCodeButtonDelegate? {
        willSet {
            newValue?.codeButton(codeButton: self, state: .prepareSend)
        }
    }
    
    // 开始计时
    public func startTime() {
        // 创建定时器
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownMethod), userInfo: nil, repeats: true)
        // 设置为非激活状态
        isEnabled = false
        remainingSeconds = seconds
    }
    
    // 停止计时
    public func stopTime() {
        countDownTimer?.invalidate()
        // 设置为激活状态
        isEnabled = true
    }
    
    // 单例方法
    static let shared = LBCodeButton(frame: CGRect.zero)
    
    // 重写Frame方法
    private override init(frame: CGRect) {
        
        // 将传进来的总秒数赋值给剩余时间数
        remainingSeconds = seconds
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    //定时器
    var countDownTimer: Timer?
    
    // 剩余的秒数
    var remainingSeconds: UInt = 0 {
        willSet {
            if newValue <= 0 {
                // 计时结束
                setTitle("重新获取", for: .normal)
                stopTime()
                delegate?.codeButton(codeButton: self, state: .alreadySend)
            } else {
                // 正在倒计时
                setTitle("\(newValue)s", for: .normal)
                delegate?.codeButton(codeButton: self, state: .sending)
            }
        }
    }
    
    // 定时器调用的方法
    func countDownMethod() {
        remainingSeconds = remainingSeconds - 1
    }

    // 获取点击事件
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
//        remainingSeconds = seconds
//        starTime()
    }
}
