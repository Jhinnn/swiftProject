//
//  CardButton.swift
//  Travel
//
//  Created by Arthur on 2017/7/18.
//  Copyright © 2017年 Arthur. All rights reserved.
//

import UIKit

class TalkButton: UIButton {

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: self.width / 3 + 18, width: self.width, height: self.height/4)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: self.width/3, y: 12, width: self.width/3, height: self.width/3)
    }

}
