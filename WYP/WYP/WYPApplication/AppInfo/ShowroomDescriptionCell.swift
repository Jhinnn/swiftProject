//
//  ShowroomDescriptionCell.swift
//  WYP
//
//  Created by 你个LB on 2017/4/21.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol ShowroomDescriptionCellDelegate {
    
    func showroomDescriptionCell(_ showroomDescriptionCell: ShowroomDescriptionCell, moreBtnAction moreBtn: UIButton)
}

class ShowroomDescriptionCell: UITableViewCell {
    
    var delegate: ShowroomDescriptionCellDelegate?
    // 描述
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // 展开按钮
    @IBOutlet weak var spreadButton: UIButton!
    
    // 更多按钮点击事件
    @IBAction func moreBtnAction(_ sender: UIButton) {
        delegate?.showroomDescriptionCell(self, moreBtnAction: sender)
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let paraStyle = NSMutableParagraphStyle()
        
        paraStyle.lineSpacing = 5 //设置行间距
        //设置字间距 NSKernAttributeName:@1.5f
        let dic = [NSParagraphStyleAttributeName: paraStyle,
                   NSKernAttributeName: 1.5] as [String : Any]
        
        let attributeStr = NSAttributedString(string: descriptionLabel.text ?? "", attributes: dic)
        descriptionLabel.attributedText = attributeStr;
        descriptionLabel.sizeToFit()
        descriptionLabel.lineBreakMode = .byClipping
        
        
        descriptionLabel.snp.updateConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 40, right: 10))
        }
    }
}
