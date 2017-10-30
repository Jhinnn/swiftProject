//
//  ButtonGroupView.swift
//  CityListDemo
//
//  Created by ShuYan Feng on 2017/3/29.
//  Copyright © 2017年 ShuYan Feng. All rights reserved.
//

import UIKit

protocol ButtonGroupViewDelegate: NSObjectProtocol {
    func buttonGroupViewDidClickItem(buttonGroup: ButtonGroupView, item: CityButton)
}

class ButtonGroupView: UIView {

    var package: Any?
    var columns: NSInteger?
    var items: [String]? {
        willSet {
            for cityButton in self.subviews {
                cityButton.removeFromSuperview()
            }
            self.buttons?.removeAll()
            
            createButton(items: newValue!)
        }
    }
    var buttons: [CityButton]?
    weak var delegate: ButtonGroupViewDelegate?

    // MARK: - private meyhod
    func createButton(items: [String]) {
        let width = Int(kScreen_width - 70) / columns!
        buttons = [CityButton]()
        
        for i in 0..<items.count {
            let index = i % 3
            let page = i / 3;
            
            let cityButton = CityButton()
            cityButton.tag = i
            cityButton.index = i
            cityButton.setTitle(items[i], for: .normal)
            cityButton.setTitleColor(UIColor.init(hexColor: "333333"), for: .normal)
            cityButton.cityItem = items[i]
            cityButton.frame = CGRect(x: index * (width + 12) + 20, y: page * 62 , width: width, height: 42)
            cityButton.addTarget(self, action: #selector(clickItem(sender:)), for: .touchUpInside)
            buttons?.append(cityButton)
            self.addSubview(cityButton)
        }
    }
    
    // MARK: - event response
    func clickItem(sender: CityButton) {
        delegate?.buttonGroupViewDidClickItem(buttonGroup: self, item: sender)
    }
}
