//
//  HotShowRoomCell.swift
//  WYP
//
//  Created by 你个LB on 2017/3/30.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class HotShowRoomCell: UICollectionViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var ShowTimeLabel: UILabel!
    
    @IBOutlet weak var starIconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.addSubview(themeView)
        themeView.snp.makeConstraints { (make) in
            make.top.left.equalTo(contentView)
            make.size.equalTo(CGSize(width: 52, height: 18))
        }
        
        imageView.addSubview(typeLabel)
    }
    
    
    lazy var themeView: UIView = {
        let themeView = UIView()
        themeView.backgroundColor = UIColor.themeColor
        themeView.alpha = 0.8
        return themeView
    }()
    
    var showRoomModel: ShowroomModel? {
        willSet {
            let imageUrl = URL(string: newValue?.logo ?? "")
            imageView.kf.setImage(with: imageUrl)
            typeLabel.text = newValue?.groupTypeName
            titleLabel.text = newValue?.title
            addressLabel.text = "北京"
            if newValue?.showStatus == "0" {
                ShowTimeLabel.text = "即将上演"
            } else {
                ShowTimeLabel.text = "已经上演"
            }
            
            if newValue?.isTop == "1" {
                starIconImage.isHidden = false
            } else {
                starIconImage.isHidden = true
            }
        }
    }
}
