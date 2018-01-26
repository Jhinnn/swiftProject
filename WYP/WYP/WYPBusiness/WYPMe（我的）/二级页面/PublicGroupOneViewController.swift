//
//  PublicGroupOneViewController.swift
//  WYP
//
//  Created by Arthur on 2018/1/17.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class PublicGroupOneViewController: BaseViewController {

    
    //选中的button
    var selectedBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "选择话题分类"
        view.backgroundColor = UIColor.white
        
        setupView()
        
  
        
        
    }
    
    func setupView() {
//        view.addSubview(titleLabel)
//        view.addSubview(lineLabel)
        
        let buttonWidth = (kScreen_width - 26 * 2 - 20 * 2) / 3;
        let buttonHeight = buttonWidth / 2 - 8
        
        
        let titleArray: [String] = ["演出文化","旅游文化","体育文化","电影文化","会展文化","饮食文化"]
        for i in 0..<6 {
            let button: UIButton = UIButton(type: .custom)
            
        
            if i <= 2 {
                 button.frame = CGRect(x: 20 + CGFloat(i) * (buttonWidth + 26), y: 30 , width: buttonWidth, height: buttonHeight)
            }else {
                 button.frame = CGRect(x: 20 + CGFloat(i - 3) * (buttonWidth + 26), y: 30 + buttonHeight + 24 , width: buttonWidth, height: buttonHeight)
            }
           
//            if i == 0{
//
//                button.setTitleColor(UIColor.white, for: .normal)
//                button.backgroundColor = UIColor.themeColor
//                self.selectedBtn = button
//            }else{
                button.setTitleColor(UIColor.gray, for: .normal)
                button.backgroundColor = UIColor.init(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
//            }
            button.addTarget(self, action: #selector(clickAction(button:)), for: .touchUpInside)
            button.setTitle(titleArray[i], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            
            button.layer.masksToBounds = true
            button.layer.cornerRadius = buttonHeight / 2
            button.titleLabel?.textAlignment = NSTextAlignment.center
            button.tag = 100 + i
            view.addSubview(button)
        }
    }
    
    //MARK: -Button 点击事件
    func clickAction(button : UIButton) {
        
        for i in 0..<6 {
            let tag = i + 100
            let button = view.viewWithTag(tag) as! UIButton
            button.setTitleColor(UIColor.gray, for: .normal)
            button.backgroundColor = UIColor.init(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
            button.isSelected = false
        }

        let btn = view.viewWithTag(button.tag) as! UIButton
        btn.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.themeColor

        
//        //获得选中的按钮
//        self.selectedBtn = btn
        
        var type = ""
        switch button.tag {
        case 100:
            type = "13"
        case 101:
            type = "14"
        case 102:
            type = "15"
        case 103:
            type = "16"
        case 104:
            type = "17"
        case 105:
            type = "18"
        default:
            type = "13"
        }
        
        let vc = PublicGroupViewController()
        vc.typeid = type
        navigationController?.pushViewController(vc, animated: true)
    }

    
    
//    lazy var titleLabel: UILabel = {
//        let label = UILabel.init(frame: CGRect(x: 18, y: 40, width: 100, height: 28))
//        label.textColor = UIColor.gray
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.text = "选择发布类型"
//        return label
//    }()
//
//    lazy var lineLabel: UILabel = {
//        let label = UILabel(frame: CGRect(x: 18, y: 80, width: kScreen_width - 10, height: 1))
//        label.backgroundColor = UIColor.init(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1)
//        return label
//    }()

}
