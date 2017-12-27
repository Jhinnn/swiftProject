//
//  TopicHeaderView.swift
//  WYP
//
//  Created by Arthur on 2017/12/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class TopicHeaderView: UIView {
    
    var targetId: String?

    
    @IBOutlet weak var imageVie: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var attentionLabel: UILabel!
    @IBOutlet weak var fansLabel: UILabel!
    
    @IBOutlet weak var addressImage: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
    
        addressImage.isHidden = true
        self.imageVie?.layer.masksToBounds = true
        self.imageVie?.layer.cornerRadius = self.imageVie.width / 2
        
    }
    
    
 
    
}
