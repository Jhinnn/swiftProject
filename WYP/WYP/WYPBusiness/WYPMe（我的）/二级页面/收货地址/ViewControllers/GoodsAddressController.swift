//
//  GoodsAddressController.swift
//  WYP
//
//  Created by 你个LB on 2017/4/1.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class GoodsAddressController: UITableViewController {

    var typeId: String?
    
    var walletId: String!
    
    var invitationId: String!
    // 从哪个页面进来的标识
    var flag: Int?
    
    
    // 票务时间Id
    var ticketTimeId: String?
    // 票务名称
    var ticketName: String?
    
    //提示语
    @IBOutlet weak var warningLabel: UILabel!
    // 收货人
    @IBOutlet weak var userName: LBTextField!
    // 手机号
    @IBOutlet weak var userMobile: LBTextField!
    // 邮编
    @IBOutlet weak var postCode: UITextField!
    
    // 详细地址
    @IBOutlet weak var detailAddress: UITextField!
    
    // 所在区域
    @IBOutlet weak var addressBtn: UIButton!
    
    // 保存按钮
    @IBOutlet weak var savaAddressBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if flag == 2 {
            // 是下单
            savaAddressBtn.setTitle("下单", for: .normal)
        } else {
            // 是保存地址
            savaAddressBtn.setTitle("保存", for: .normal)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadNetData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func selectCityBtnAction() {
        
        userName.resignFirstResponder()
        
        userMobile.resignFirstResponder()
        
        postCode.resignFirstResponder()
        
        detailAddress.resignFirstResponder()
        
        FYLCityPickView.show { (arr) in
            let address = String.init(format: "%@-%@-%@", arr?[0] as! String ,arr?[1]  as! String ,arr?[2]  as! String)
            self.addressBtn.setTitle(address, for: .normal)
        }
    }
    
    func loadNetData() {
        NetRequest.getGoodsAddressNetRequest(openId: AppInfo.shared.user?.token ?? "") { (success, info, dic) in
            if success {
                self.userName.text = dic?.object(forKey: "name") as? String
                self.userMobile.text = dic?.object(forKey: "phone_number") as? String
                self.postCode.text = dic?.object(forKey: "postcode") as? String
                self.addressBtn.setTitle(dic?.object(forKey: "region") as? String, for: .normal)
                self.detailAddress.text = dic?.object(forKey: "address") as? String
                
                if self.addressBtn.title(for: .normal)?.characters.count ?? 0 > 0 {
                        self.addressBtn.isSelected = true
                }
            }
        }
    }
    // 延时1s才能点击
    func delayToEnable(sender: UIButton) {
        savaAddressBtn.isEnabled = true
    }
    
    @IBAction func saveGoodsInfo(_ sender: UIButton) {
        if !(userMobile.text?.isMobileTelephoneNumber())! {
            SVProgressHUD.showError(withStatus: "手机号格式有误")
            return
        }
        if flag == 2 { // 首页的兑换，钱包的兑换和邀请好友的兑换

            NetRequest.goodsInfoNetRequest(uid: AppInfo.shared.user?.userId ?? "", ticketTimeId: ticketTimeId ?? "", type: typeId ?? "", walletId: walletId, invitationId: invitationId, name: userName.text ?? "", phone: userMobile.text ?? "", postcode: postCode.text ?? "", region: addressBtn.title(for: .normal) ?? "", address: detailAddress.text ?? "", ticketName: ticketName ?? "") { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info!)
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            }
        } else {
            NetRequest.saveMyAddressNetRequest(openId: AppInfo.shared.user?.token ?? "", name: userName.text ?? "", phone: userMobile.text ?? "", postcode: postCode.text ?? "", region: addressBtn.title(for: .normal) ?? "", address: detailAddress.text ?? "", complete: { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info!)
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            })
        }
        
        sender.isEnabled = false
        self.perform(#selector(delayToEnable(sender:)), with: nil, afterDelay: 0.3)
    }
}
