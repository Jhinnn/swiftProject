
//
//  TalkHeadView.swift
//  WYP
//
//  Created by aLaDing on 2018/3/19.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TalkHeadView: UIView {

    @IBOutlet weak var headView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        headView.layer.masksToBounds = true
        headView.layer.cornerRadius = 24
        
        answerButton.layer.masksToBounds = true
        answerButton.layer.cornerRadius = 15
        
        loadData()
        
    }
    
    func loadData() {
        let parameters: Parameters = ["access_token": access_token,
                                      "method": "GET",
                                      "uid" : AppInfo.shared.user?.userId ?? ""
                                      ]
        Alamofire.request(kApi_TopicHeadData, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                // 获取info信息
                
                if code == 400 {
                    
                } else {
                    // 获取数据
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    self.nameLabel.text = dic?["nickname"] as? String
                  
                    self.readLabel.text = String.init(format: "%@个阅读", dic?["view_num"] as! String)
                    let url = dic?["avatar128"] as? String
                    self.headView.kf.setImage(with: URL.init(string: url!), placeholder: UIImage.init(color: UIColor.gray), options: nil, progressBlock: nil, completionHandler: nil)
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    

    
}
