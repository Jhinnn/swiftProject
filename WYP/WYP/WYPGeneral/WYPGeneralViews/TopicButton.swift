//
//  CardButton.swift
//  Travel
//
//  Created by Arthur on 2017/7/18.
//  Copyright © 2017年 Arthur. All rights reserved.
//

import UIKit

class TopicButton: UIButton {
    

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: self.width/2, y: self.height/4, width: self.width / 2, height: self.height/2)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: self.width/2 - 24, y: (self.height - 20) / 2, width: 24, height: 20)
    }

}
