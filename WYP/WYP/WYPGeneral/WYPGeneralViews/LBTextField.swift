//
//  LBTextField.swift
//  WYP
//
//  Created by 你个LB on 2017/3/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class LBTextField: UITextField {

    // 控制默认文本的位置(placeholder)
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 15, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
    }
    
    // 控制编辑文本的位置
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 15, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
        
    }
    
    // 控制显示文本的位置
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 15, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
    }
    
    override func drawPlaceholder(in rect: CGRect) {
        
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)])
        
        super.drawPlaceholder(in: rect)
    }
}
