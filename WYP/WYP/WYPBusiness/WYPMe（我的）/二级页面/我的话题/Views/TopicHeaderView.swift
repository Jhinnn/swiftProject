//
//  TopicHeaderView.swift
//  WYP
//
//  Created by Arthur on 2017/12/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class TopicHeaderView: UIView {

    
    @IBOutlet weak var imageVie: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var attentionLabel: UILabel!
    @IBOutlet weak var fansLabel: UILabel!
    
    @IBOutlet weak var addressImage: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        

        load_init()
        
        
    }
    
    override func awakeFromNib() {
        
        addressImage.isHidden = true
        
        self.imageVie?.layer.masksToBounds = true
        self.imageVie?.layer.cornerRadius = self.imageVie.width / 2
    }
    
    
    func load_init(){
        
        
        NetRequest.myNewTopicMsgListNetRequest(page: "1", token: AppInfo.shared.user?.token ?? "",uid: AppInfo.shared.user?.userId ?? "") { (success, info, dic) in
            if success {
                
                self.addressImage.isHidden = false
                
                let imageStr = dic?["avatar"] as! String
                let imageUrl = URL(string: imageStr)
                self.imageVie.kf.setImage(with: imageUrl)
                
                self.titleLabel.text = dic?["nickname"] as? String
                self.addressLabel.text = dic?["address"] as? String
                self.textLabel.text = dic?["signature"] as? String
                
                self.attentionLabel.text = String.init(format: "%@关注", (dic?["follow_num"] as? String)!)
                self.fansLabel.text = String.init(format: "%@粉丝", (dic?["fans_num"] as? String)!)
            }
        }
        
    }
    
}
