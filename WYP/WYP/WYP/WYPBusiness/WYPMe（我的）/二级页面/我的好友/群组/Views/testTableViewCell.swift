//
//  testTableViewCell.swift
//  groupListDemo1
//
//  Created by 赵玉忠 on 2017/11/1.
//  Copyright © 2017年 赵玉忠. All rights reserved.
//

import UIKit

class testTableViewCell: UITableViewCell {
    
    // MARK: - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
