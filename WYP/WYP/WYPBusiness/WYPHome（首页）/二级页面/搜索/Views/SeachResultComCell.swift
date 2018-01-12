//
//  SeachResultComCell.swift
//  WYP
//
//  Created by Arthur on 2018/1/11.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class SeachResultComCell: UITableViewCell {
    
    
    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var imageView3: UIImageView!
    
    @IBOutlet weak var imageView1: UIImageView!
    
    @IBOutlet weak var imageView2: UIImageView!
    
    //数据模型
    var newValue: CommunityModel? {
        willSet {

            headImageView.layer.masksToBounds = true
            headImageView.layer.cornerRadius = 20
            
            var imageUrl: URL?
            imageUrl = URL(string: newValue?.path ?? "")
            headImageView.kf.setImage(with: imageUrl)
            
            
            nameLabel.text = newValue?.nickname ?? ""
            timeLabel.text = newValue?.create_time ?? ""
            contentLabel.text = newValue?.content ?? ""
            
        
            if (newValue?.dynamic_path?.count)! >= 3 {
                imageView1.kf.setImage(with: URL(string: newValue?.dynamic_path?[0] ?? ""))
                imageView2.kf.setImage(with: URL(string: newValue?.dynamic_path?[1] ?? ""))
                imageView3.kf.setImage(with: URL(string: newValue?.dynamic_path?[2] ?? ""))
            }else if (newValue?.dynamic_path?.count)! == 2 {
                imageView1.kf.setImage(with: URL(string: newValue?.dynamic_path?[0] ?? ""))
                imageView2.kf.setImage(with: URL(string: newValue?.dynamic_path?[1] ?? ""))
            }else if (newValue?.dynamic_path?.count)! == 1 {
                imageView1.kf.setImage(with: URL(string: newValue?.dynamic_path?[0] ?? ""))
            }
               
            
            
       
            
        }
    }
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
        
     
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
