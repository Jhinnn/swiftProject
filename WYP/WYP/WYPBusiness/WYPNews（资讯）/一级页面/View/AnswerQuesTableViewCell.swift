//
//  AnswerQuesTableViewCell.swift
//  WYP
//
//  Created by aLaDing on 2018/4/2.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

protocol AnswerQuesTableViewCellDelegate {
    func answerActionCell(_ answerQuesTableViewCell: AnswerQuesTableViewCell, infoModel model: MineTopicsModel)
    func ingoreActionCell(_ answerQuesTableViewCell: AnswerQuesTableViewCell, infoModel model: MineTopicsModel)
}


class AnswerQuesTableViewCell: UITableViewCell {
    
    var delegate: AnswerQuesTableViewCellDelegate?
    
    @IBOutlet weak var ingoreBton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //数据模型
    var infoModel: MineTopicsModel? {
        willSet {
            titleLabel.text = newValue?.title ?? ""
            countLabel.text = String.init(format: "%@人回答 · %@人收藏", newValue?.commentCount ?? "0", newValue?.follow_num ?? "0")
        }
    }
    
    
    @IBAction func ingroeAction(_ sender: Any) {
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self.viewController!)
            return
        } else {
            delegate?.ingoreActionCell(self, infoModel: infoModel!)
        }
    }
    @IBAction func anwerAction(_ sender: Any) {
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self.viewController!)
            return
        } else {
            delegate?.answerActionCell(self, infoModel: infoModel!)
        }
    }
}
