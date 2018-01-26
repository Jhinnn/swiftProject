//
//  ShareManager.swift
//  WYP
//
//  Created by 你个LB on 2017/5/24.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ShareManager: NSObject {
    
    // 投诉对象的Id
    var complaintId: String?
    // 投诉的类型 1.资讯 2.展厅 3.票务 4.活动 5.话题 6.社区
    var type: String?

    var messageObject: UMSocialMessageObject!
    
    var viewController: UIViewController!
    
    // 分享类型
    var platformType: UMSocialPlatformType?
    
    /// 初始化方法
    static let shared = ShareManager()
    
    /// 私有化inti方法
    private override init() {
    }
    
    lazy var adView: UIImageView = {
        let adView = UIImageView()
        adView.backgroundColor = UIColor.clear
        adView.image = UIImage(named: "mine_ad_icon_normal_iPhone")
        
        return adView
    }()
    
    func loadShareAdv() {
        NetRequest.shareAdvNetRequest { (success, info, result) in
            if success {
                let array = result!.value(forKey: "banner")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                let bannerData = [BannerModel].deserialize(from: jsonString) as? [BannerModel]
                self.adView.kf.setImage(with: URL(string: bannerData?[0].bannerImage ?? ""), placeholder: UIImage(named: "mine_ad_icon_normal_iPhone"), options: nil, progressBlock: nil, completionHandler: nil)
            }
        }
    }
    
    func show() {
        UMSocialUIManager.addCustomPlatformWithoutFilted(.youDaoNote, withPlatformIcon: UIImage(named: "common_complaint_button_normal_iPhone"), withPlatformName: "投诉")
        
        UMSocialUIManager.setShareMenuViewDelegate(self as UMSocialShareMenuViewDelegate)
        
        UMSocialUIManager.showShareMenuViewInWindow { (platformType, result) in
            
            self.platformType = platformType
            
            if platformType == .youDaoNote {
                let complaint = ComplaintViewController()
                complaint.complaintId = self.complaintId ?? ""
                complaint.type = self.type ?? ""
                self.viewController.navigationController?.pushViewController(complaint, animated: true)
            }
            
            UMSocialManager.default().share(to: platformType, messageObject: self.messageObject, currentViewController: self.viewController, completion: { (result, error) in
                if error == nil {
//                    let resp: UMSocialShareResponse = result as! UMSocialShareResponse
                    
                    //分享成功，发送通知
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "shareSuccessNotification"), object: nil)
                }
            })
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}


extension ShareManager: UMSocialShareMenuViewDelegate {
    
    func umSocialShareMenuViewDidDisappear() {
        adView.removeFromSuperview()
    }
    
    func umSocialParentView(_ defaultSuperView: UIView!) -> UIView! {
        
        defaultSuperView.addSubview(adView)
        
        adView.snp.makeConstraints { (make) in
            make.bottom.equalTo(defaultSuperView).offset(-259.5)
            make.left.right.equalTo(defaultSuperView)
            make.height.equalTo(78.5)
        }
        return defaultSuperView
    }
}
