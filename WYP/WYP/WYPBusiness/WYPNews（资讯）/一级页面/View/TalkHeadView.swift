
//
//  TalkHeadView.swift
//  WYP
//
//  Created by aLaDing on 2018/3/19.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit


class TalkHeadView: UIView {

    @IBOutlet weak var headView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton!
    
    
    @IBOutlet weak var answerBtn: UIButton!
    
    @IBOutlet weak var findBtn: UIButton!
    @IBOutlet weak var questionBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        headView.layer.masksToBounds = true
        headView.layer.cornerRadius = 22
        
        answerButton.layer.masksToBounds = true
        answerButton.layer.cornerRadius = 15
        
        
    }
    
    
    
    
    
    

    
}
