//
//  WalletCell.swift
//  WYP
//
//  Created by 你个LB on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class CouponCell: UITableViewCell {
    
    public var coupon: CouponModel? {
        willSet {
            
            switch newValue?.type ?? "" {
            case "1":
                // 代金券
                circleTypeLabel.text = "代金券"
            case "2":
                // 兑换券
                circleTypeLabel.text = "兑换券"
            default:
                // 优惠券
                circleTypeLabel.text = "优惠券"
            }
            
            moneyLabel.text = "￥\(newValue?.money ?? "")"
            
            validityTimeLabel.text = "有效期:\(newValue?.startTime ?? "")-\(newValue?.endTime ?? "")"
            print(newValue?.useStatus ?? "123")
            switch newValue?.useStatus ?? "" {
            case "0":
                // 未使用
                useStatusIcon.image = UIImage(named: "")
                themeBgView.backgroundColor = UIColor.init(hexColor: "#149a4f")
                promotionCodeLabel.textColor = UIColor.init(hexColor: "#149a4f")
                ticketNameLabel.textColor = UIColor.init(hexColor: "#149a4f")
                
            case "1":
                // 已使用
                useStatusIcon.image = UIImage(named: "mine_walletUsed_icon_normal_iPhone")
                themeBgView.backgroundColor = UIColor.init(hexColor: "#623494")
                promotionCodeLabel.textColor = UIColor.init(hexColor: "#623494")
                ticketNameLabel.textColor = UIColor.init(hexColor: "#623494")
                
            default:
                // 已过期
                useStatusIcon.image = UIImage(named: "invalidation")
                themeBgView.backgroundColor = UIColor.themeColor
                promotionCodeLabel.textColor = UIColor.themeColor
                ticketNameLabel.textColor = UIColor.themeColor
            }
            
            ticketNameLabel.text = "【抽奖】\(newValue?.ticketName ?? "")"
            
            promotionCodeLabel.text = "优惠编码：\(newValue?.promotionCode ?? "")"
        }
    }
    
    // MARK: - Lifecycle
    
    // 指定初始化方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    
    
    // MARK: - Private Methods
    
    // 设置视图
    func setupUI() {
        contentView.addSubview(bgView)
        
        bgView.addSubview(themeBgView)
        
        themeBgView.addSubview(circleTypeLabel)
        
        themeBgView.addSubview(moneyLabel)
        
        themeBgView.addSubview(validityTimeLabel)
        
        bgView.addSubview(ticketNameLabel)
        
        bgView.addSubview(promotionCodeLabel)

        bgView.addSubview(useStatusIcon)
        
        setupUIFrame()
    }
    
    func setupUIFrame() {
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 27, left: 17.5, bottom: 16, right: 17.5))
        }
        
        themeBgView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(bgView)
            make.bottom.equalTo(bgView.snp.centerY)
        }
        
        circleTypeLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(20)
            make.size.equalTo(55)
        }
        
        moneyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(themeBgView).offset(20)
            make.right.equalTo(themeBgView).offset(-20)
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
        
        validityTimeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(themeBgView).offset(-10)
            make.right.equalTo(themeBgView).offset(-20)
            make.size.equalTo(CGSize(width: 150, height: 30))
        }

        promotionCodeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgView).offset(-20)
            make.left.equalTo(bgView).offset(20)
            make.height.equalTo(20)
        }
        
        ticketNameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(promotionCodeLabel.snp.top).offset(-10)
            make.left.equalTo(promotionCodeLabel).offset(-7)
            make.height.equalTo(promotionCodeLabel)
        }
        
        useStatusIcon.snp.makeConstraints { (make) in
            make.center.equalTo(bgView)
            make.size.equalTo(80)
        }
    }
    
    // 背景视图
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 6
        bgView.layer.borderWidth = 1.0
        bgView.layer.borderColor = UIColor.init(hexColor: "#d6d6d6").cgColor
        bgView.layer.masksToBounds = true
        
        return bgView
    }()
    
    // 主题色背景视图
    lazy var themeBgView: UIView = {
        let themeBgView = UIView()
        
        return themeBgView
    }()
    
    // 白色圆类型
    lazy var circleTypeLabel: UILabel = {
        let circleTypeLabel = UILabel()
        circleTypeLabel.backgroundColor = UIColor.white
        circleTypeLabel.font = UIFont.systemFont(ofSize: 15)
        circleTypeLabel.textAlignment = .center
        circleTypeLabel.layer.cornerRadius = 27.5
        circleTypeLabel.layer.masksToBounds = true
        circleTypeLabel.text = "优惠券"
        
        return circleTypeLabel
    }()
    
    // 钱数
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.font = UIFont.systemFont(ofSize: 20)
        moneyLabel.textColor = UIColor.white
        moneyLabel.textAlignment = .right
        moneyLabel.text = "￥100"
        
        return moneyLabel
    }()
    
    // 有效期
    lazy var validityTimeLabel: UILabel = {
        let validityTimeLabel = UILabel()
        validityTimeLabel.font = UIFont.systemFont(ofSize: 13)
        validityTimeLabel.textColor = UIColor.white
        validityTimeLabel.textAlignment = .right
        validityTimeLabel.text = "有效期：03.09-04.10"
        
        return validityTimeLabel
    }()
    
    // 票名
    lazy var ticketNameLabel: UILabel = {
        let ticketNameLabel = UILabel()
        ticketNameLabel.font = UIFont.systemFont(ofSize: 12)
        ticketNameLabel.text = "【抽奖】北京曲剧龙须沟兑换票"
        
        return ticketNameLabel
    }()
    
    // 优惠编码
    lazy var promotionCodeLabel: UILabel = {
        let promotionCodeLabel = UILabel()
        promotionCodeLabel.font = UIFont.systemFont(ofSize: 12)
        promotionCodeLabel.text = "优惠编码：2635203497164"
        
        return promotionCodeLabel
    }()
    
    // 图标
    lazy var useStatusIcon: UIImageView = {
        let useStatusIcon = UIImageView()
        useStatusIcon.contentMode = .scaleAspectFit
        
        return useStatusIcon
    }()
    
    // MARK: - IBActions
    
    
    // MARK: - Getter
    
    
    // MARK: - Setter
}
