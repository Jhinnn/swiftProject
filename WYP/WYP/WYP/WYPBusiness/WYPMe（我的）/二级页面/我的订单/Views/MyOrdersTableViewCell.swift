//
//  MyOrdersTableViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/21.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol OrdersTableViewCellDelegate: NSObjectProtocol {
    func checkTheLogistics()
}

class MyOrdersTableViewCell: UITableViewCell {
    
    weak var delegate: OrdersTableViewCellDelegate?
    //MARK: - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewConfig()
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MAKE: - event response
    func clickCheckTheLogistics(sender: UIButton) {
        delegate?.checkTheLogistics()
    }
    
    //MARK: - private method
    private func viewConfig() {
        contentView.addSubview(ordersImageView)
        contentView.addSubview(ordersTitleLabel)
        contentView.addSubview(ordersTheatreLabel)
        contentView.addSubview(ordersTimeLabel)
        contentView.addSubview(orderMarkLabel)
        contentView.addSubview(ordersPriceLabel)
        contentView.addSubview(orderInfoLabel)
    }
    private func layoutPageSubviews() {
        ordersImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(17.5)
            make.left.equalTo(contentView).offset(10)
            make.size.equalTo(CGSize(width: 103, height: 136.5))
        }
        ordersTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(17.5)
            make.left.equalTo(ordersImageView.snp.right).offset(14.5)
            make.right.equalTo(contentView).offset(-10)
            make.height.equalTo(20)
        }
        ordersTheatreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ordersTitleLabel.snp.bottom).offset(24.5)
            make.left.equalTo(ordersImageView.snp.right).offset(14.5)
            make.width.equalTo(100)
            make.height.equalTo(10)
        }
        ordersTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ordersTheatreLabel.snp.bottom).offset(31.5)
            make.left.equalTo(ordersImageView.snp.right).offset(14.5)
            make.width.equalTo(150)
            make.height.equalTo(10)
        }
        orderMarkLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ordersTimeLabel.snp.bottom).offset(30.5)
            make.left.equalTo(ordersImageView.snp.right).offset(14.5)
            make.height.equalTo(12)
        }
        ordersPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ordersTimeLabel.snp.bottom).offset(30.5)
            make.left.equalTo(orderMarkLabel.snp.right)
            make.height.equalTo(12)
        }
        orderInfoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ordersTimeLabel.snp.bottom).offset(30.5)
            make.right.equalTo(contentView).offset(-10)
            make.height.equalTo(15)
        }
    }
    
    //MARK: - setter and getter
    lazy var ordersImageView: UIImageView = {
        let ordersImageView = UIImageView()
        ordersImageView.image = UIImage(named: "lottery_cellIcon_icon_normal_iPhone")
        return ordersImageView
    }()
    lazy var ordersTitleLabel: UILabel = {
        let ordersTitleLabel = UILabel()
        ordersTitleLabel.text = "2017张惠妹”乌托邦.庆典“巡回演唱会北京站"
        ordersTitleLabel.font = UIFont.systemFont(ofSize: 15)
        return ordersTitleLabel
    }()
    lazy var ordersTheatreLabel: UILabel = {
        let ordersTheatreLabel = UILabel()
        ordersTheatreLabel.text = "隆福剧场"
        ordersTheatreLabel.font = grayTextFont
        return ordersTheatreLabel
    }()
    lazy var ordersTimeLabel: UILabel = {
        let ordersTimeLabel = UILabel()
        ordersTimeLabel.font = grayTextFont
        return ordersTimeLabel
    }()
    lazy var orderMarkLabel: UILabel = {
        let orderMarkLabel = UILabel()
        orderMarkLabel.text = "票价：￥"
        orderMarkLabel.textColor = UIColor.themeColor
        orderMarkLabel.font = UIFont.systemFont(ofSize: 12)
        return orderMarkLabel
    }()
    lazy var ordersPriceLabel: UILabel = {
        let ordersPriceLabel = UILabel()
        ordersPriceLabel.text = "800"
        ordersPriceLabel.textColor = UIColor.themeColor
        ordersPriceLabel.font = UIFont.systemFont(ofSize: 12)
        
        return ordersPriceLabel
    }()
    lazy var orderInfoLabel: UILabel = {
        let orderInfoLabel = UILabel()
        orderInfoLabel.textColor = UIColor.themeColor
        orderInfoLabel.font = UIFont.systemFont(ofSize: 15)
        orderInfoLabel.text = "出票中"
        return orderInfoLabel
    }()
    
    
    var orders: OrdersModel? {
        willSet {
            
            let imageUrl = URL(string: newValue?.activityImage ?? "")
            ordersImageView.kf.setImage(with: imageUrl)
            ordersTitleLabel.text = newValue?.activityTitle ?? ""
            ordersTheatreLabel.text = newValue?.travelName ?? ""
            ordersTimeLabel.text = String().timeStampToString(timeStamp: newValue?.activitySTime ?? "")
            ordersPriceLabel.text = newValue?.orderPrice ?? ""
            // 中划线
            // string 是需要设置中划线的字符串
            let attributedStr = NSMutableAttributedString(string: ordersPriceLabel.text!)
            // range 是设置中划线的范围   其他参数不必管
            attributedStr.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: 1), range: NSMakeRange(0, ordersPriceLabel.text!.characters.count))
            // 赋值
            ordersPriceLabel.attributedText = attributedStr
            
            switch newValue?.currentStatus ?? 0 {
            case 1:
                orderInfoLabel.text = "未出票"
                break
            case 2:
                orderInfoLabel.text = "出票中"
                break
            case 3:
                orderInfoLabel.text = "已完成"
                break
            default:
                break
            }
        }
    }
}
