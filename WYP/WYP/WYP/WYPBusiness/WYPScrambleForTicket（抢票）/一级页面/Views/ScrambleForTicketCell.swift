//
//  ScrambleForTicketCell.swift
//  WYP
//
//  Created by 你个LB on 2017/3/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol ScrambleForTicketCellDelegate: NSObjectProtocol {
    func clickGrabTicket(sender: UIButton)
}

class ScrambleForTicketCell: UITableViewCell {
    
    weak var delegate: ScrambleForTicketCellDelegate?
    //MARK: - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewConfig()
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - event response
    func clickGradTicket(sender: UIButton) {
        delegate?.clickGrabTicket(sender: sender)
    }
    
    //MARK: - private method
    private func viewConfig() {
        self.contentView.addSubview(ticketImageView)
        self.contentView.addSubview(ticketTitleLabel)
        self.contentView.addSubview(ticketTheatreLabel)
        self.contentView.addSubview(ticketDistanceLabel)
        self.contentView.addSubview(ticketTimeLabel)
        self.contentView.addSubview(ticketNumberlabel)
        self.contentView.addSubview(ticketPriceLabel)
        self.contentView.addSubview(ticketButton)
        self.contentView.addSubview(topImageView)
        self.addSubview(ticketMarkLabel)
    }
    private func layoutPageSubviews() {
        ticketImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(13)
            make.bottom.equalTo(contentView).offset(-10)
            make.size.equalTo(CGSize(width: 100, height: 134))
        }
        ticketTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(18)
            make.left.equalTo(ticketImageView.snp.right).offset(18)
            make.right.equalTo(contentView).offset(-13)
            make.height.equalTo(15)
        }
        ticketTheatreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ticketTitleLabel.snp.bottom).offset(20)
            make.left.equalTo(ticketImageView.snp.right).offset(18)
            make.width.equalTo(100)
            make.height.equalTo(10)
        }
        ticketDistanceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ticketTitleLabel.snp.bottom).offset(20)
            make.right.equalTo(contentView).offset(-13)
            make.width.equalTo(100)
            make.height.equalTo(10)
        }
        ticketTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ticketTheatreLabel.snp.bottom).offset(20)
            make.left.equalTo(ticketImageView.snp.right).offset(18)
            make.width.equalTo(150)
            make.height.equalTo(10)
        }
        ticketNumberlabel.snp.makeConstraints { (make) in
            make.top.equalTo(ticketTheatreLabel.snp.bottom).offset(20)
            make.right.equalTo(contentView).offset(-13)
            make.width.equalTo(100)
            make.height.equalTo(10)
        }
        ticketMarkLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ticketTimeLabel.snp.bottom).offset(30.5)
            make.left.equalTo(ticketImageView.snp.right).offset(14.5)
            make.height.equalTo(12)
        }
        ticketPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ticketTimeLabel.snp.bottom).offset(30.5)
            make.left.equalTo(ticketMarkLabel.snp.right)
            make.height.equalTo(12)
        }
        ticketButton.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15)
            make.bottom.equalTo(contentView).offset(-10)
            make.size.equalTo(CGSize(width: 62, height: 22))
        }
        topImageView.snp.makeConstraints { (make) in
            make.left.equalTo(ticketImageView.snp.right).offset(18)
            make.bottom.equalTo(contentView).offset(-10)
            make.size.equalTo(CGSize(width: 20, height: 10))
        }
    }

    //MARK: - setter and getter
    lazy var ticketImageView: UIImageView = {
        let ticketImageView = UIImageView()
        ticketImageView.contentMode = .scaleAspectFill
        ticketImageView.layer.masksToBounds = true
        return ticketImageView
    }()
    lazy var ticketTitleLabel: UILabel = {
        let ticketTitleLabel = UILabel()
        ticketTitleLabel.text = "2017张惠妹”乌托邦.庆典“巡回演唱会北京站"
        ticketTitleLabel.font = UIFont.systemFont(ofSize: 15)
        ticketTitleLabel.textColor = UIColor.init(hexColor: "333333")
        return ticketTitleLabel
    }()
    lazy var ticketTheatreLabel: UILabel = {
        let ticketTheatreLabel = UILabel()
        ticketTheatreLabel.text = "隆福剧场"
        ticketTheatreLabel.font = grayTextFont
        return ticketTheatreLabel
    }()
    lazy var ticketDistanceLabel: UILabel = {
        let ticketDistanceLabel = UILabel()
        ticketDistanceLabel.text = "距离：3.5km"
        ticketDistanceLabel.textAlignment = .right
        ticketDistanceLabel.font = grayTextFont
        ticketDistanceLabel.textColor = UIColor.init(hexColor: "333333")
        return ticketDistanceLabel
    }()
    lazy var ticketTimeLabel: UILabel = {
        let ticketTimeLabel = UILabel()
        ticketTimeLabel.font = grayTextFont
        ticketTimeLabel.textColor = UIColor.init(hexColor: "333333")
        return ticketTimeLabel
    }()
    lazy var ticketNumberlabel: UILabel = {
        let ticketNumberLabel = UILabel()
        ticketNumberLabel.text = "8888 人参与抢票"
        ticketNumberLabel.textAlignment = .right
        ticketNumberLabel.font = grayTextFont
        ticketNumberLabel.textColor = UIColor.init(hexColor: "333333")
        return ticketNumberLabel
    }()
    lazy var ticketMarkLabel: UILabel = {
        let orderMarkLabel = UILabel()
        orderMarkLabel.text = "票价：￥"
        orderMarkLabel.textColor = UIColor.themeColor
        orderMarkLabel.font = UIFont.systemFont(ofSize: 12)
        return orderMarkLabel
    }()
    lazy var ticketPriceLabel: UILabel = {
        let ticketPriceLabel = UILabel()
        ticketPriceLabel.text = "800"
        ticketPriceLabel.font = UIFont.systemFont(ofSize: 12)
        ticketPriceLabel.textColor = UIColor.themeColor
        return ticketPriceLabel
    }()
    lazy var ticketButton: UIButton = {
        let ticketButton = UIButton(type: .custom)
        ticketButton.setTitle("立即抢票", for: .normal)
        ticketButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        var image = UIImage(named: "common_backgroundColor_button_normal_iPhone")
        image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode: .tile)
        ticketButton.setBackgroundImage(image, for: .normal)

        ticketButton.setTitleColor(UIColor.init(hexColor: "fffefe"), for: .normal)
        ticketButton.layer.cornerRadius = 6.0
        ticketButton.layer.masksToBounds = true
        ticketButton.addTarget(self, action: #selector(clickGradTicket(sender:)), for: .touchUpInside)
        return ticketButton
    }()
    lazy var topImageView: UIImageView = {
        let topImageView = UIImageView()
        topImageView.image = UIImage(named: "common_top_icon_normal_iPhone")
        return topImageView
    }()
    
    // 数据源
    var ticketModel: TicketModel? {
        willSet {
    
            let imageUrl = URL(string: newValue?.ticketPic ?? "")
            ticketImageView.kf.setImage(with: imageUrl)
            ticketTitleLabel.text = newValue?.ticketTitle
            ticketDistanceLabel.text = String.init(format: "距离：%@km", newValue?.ticketDistance ?? "")
            ticketTheatreLabel.text = newValue?.ticketVernve
            // 开始时间
            ticketTimeLabel.text = String.init(format: "%@", String().timeStampToString(timeStamp: newValue?.ticketStartTime ?? "0"))
            
            ticketPriceLabel.text = newValue?.ticketPirce ?? ""
            // 中划线
            let attributedStr = NSMutableAttributedString(string: ticketPriceLabel.text!)
            attributedStr.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: 1), range: NSMakeRange(0, ticketPriceLabel.text!.characters.count))
            ticketPriceLabel.attributedText = attributedStr
            
            ticketNumberlabel.text = String.init(format: "%@ 人参与抢票", newValue?.ticketPeople ?? "0")
            // 是否过期
            let currentStemp = Double(String().getCurrentDate())
            if newValue?.ticketEndTime != nil {
                if currentStemp > Double(newValue?.ticketEndTime ?? "0")! {
                    var image = UIImage(named: "common_grayBack_icon_normal_iPhone")
                    image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode: .tile)
                    ticketButton.setBackgroundImage(image, for: .normal)
                    ticketButton.setTitle("抢票截止", for: .normal)
                    ticketButton.isUserInteractionEnabled = false
                }
            }
            
            // 是否置顶
            if newValue?.isTop == "0" {
                topImageView.isHidden = true
            }
        }
    }
}

