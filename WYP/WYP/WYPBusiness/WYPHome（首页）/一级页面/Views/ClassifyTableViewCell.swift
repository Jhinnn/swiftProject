//
//  ClassifyTableViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/9/7.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol ClassifyTableViewCellDelegate: NSObjectProtocol {
    func clickToClassifyVC(sender: ClassButton)
    func clickCCPScrollView(index: Int)
}

class ClassifyTableViewCell: UITableViewCell {

    weak var delegate: ClassifyTableViewCellDelegate?
    
    var titleArray: [String]? {
        willSet {
            ccpView.titleArray = newValue
            ccpView.titleFont = 11
        }
    }
    
    let buttonTitle = ["演出","电影","旅游","赛事","抢票"]
    let buttonImage = ["home_show_button_normal_iPhone1","home_moive_button_normal_iPhone1","home_travel_button_normal_iPhone1","home_game_button_normal_iPhone1","home_lottery_button_normal_iPhone1"]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewConfig()
        createButton()
        contentView.backgroundColor = UIColor.vcBgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private method
    func createButton() {
        
        for i in 0..<5 {
            let button = ClassButton(frame: CGRect(x: (kScreen_width / 5) * CGFloat(i), y: 0, width: kScreen_width / 5, height: 60))
            button.tag = 1001 + i
            button.setImage(UIImage(named: buttonImage[i]), for: .normal)
            button.setTitle(buttonTitle[i], for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            button.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
            contentView.addSubview(button)
        }
    }
    
    func viewConfig() {
        contentView.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-15)
            make.bottom.equalTo(contentView).offset(-3)
            make.height.equalTo(30)
            
        }
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 65, height: 30))
        label.text = "1001阿拉丁"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 12)
        backView.addSubview(label)
        
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "home_icon_normal_iPhone")
        backView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(label.snp.right)
            make.centerY.equalTo(backView)
            make.size.equalTo(CGSize(width: 24, height: 14))
        }

        backView.addSubview(ccpView)
    }
    
    func clickButton(sender: ClassButton) {
        delegate?.clickToClassifyVC(sender: sender)
    }
    
    
    lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = UIColor.white
        backView.layer.cornerRadius = 15.0
        backView.layer.masksToBounds = true
        return backView
    }()
    
    lazy var ccpView: CCPScrollView = {
        let ccpView = CCPScrollView(frame: CGRect(x: kScreen_width - 255 * width_height_ratio, y: 0, width: 220 * width_height_ratio, height: 30))
        ccpView.titleColor = UIColor.gray
        ccpView.bgColor = UIColor.white
        ccpView.clickTitleLabel({ (index, titleSrting) in
            self.delegate?.clickCCPScrollView(index: index)
        })
        
        return ccpView
    }()
    

}

class ClassButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.titleLabel?.textAlignment = .center
        self.imageView?.contentMode = .scaleAspectFit
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageW = contentRect.size.width
        let imageH = contentRect.size.height * 0.4
        
        return CGRect(x: 0, y: 15, width: imageW, height: imageH)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleX: CGFloat = 5
        let titleY: CGFloat = contentRect.size.height * 0.4
        let titleW: CGFloat = contentRect.size.width - 10
        let titleH: CGFloat = contentRect.size.height
        
        return CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
    }
}
