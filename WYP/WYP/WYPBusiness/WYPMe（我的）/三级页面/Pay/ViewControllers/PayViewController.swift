//
//  PayViewController.swift
//  PayUI
//
//  Created by 杨 on 2017/6/21.
//  Copyright © 2017年 杨. All rights reserved.
//

import UIKit

class PayViewController: UIViewController {

    // 快递
    @IBOutlet weak var expressBut: UIButton!
    // 联系人
    @IBOutlet weak var userNameTF: UITextField!
    // 手机号
    @IBOutlet weak var phoneNumberTF: UITextField!
    // 收货地址
    @IBOutlet weak var siteTF: UITextField!
    // 修改
    @IBOutlet weak var alterBut: UIButton!
    // 微信
    @IBOutlet weak var wxSelectBut: UIButton!
    // 支付宝
    @IBOutlet weak var zfbSelectBut: UIButton!
    // 支付
    @IBOutlet weak var payBut: UIButton!
    
    // 微信支付数据
    var wxPayModel: WeChatPayModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.title = "订单快递费支付"
        
        // 选择
        wxSelectBut.tag = 1001
        wxSelectBut.addTarget(self, action: #selector(wxAndzfbSelect(selectBut:)), for: .touchUpInside)
        wxSelectBut.isSelected = true
        zfbSelectBut.addTarget(self, action: #selector(wxAndzfbSelect(selectBut:)), for: .touchUpInside)
        
        // 支付
        payBut.addTarget(self, action: #selector(clickPayAction), for: .touchUpInside)
        
    }
    
    // MARK: 选择
    func wxAndzfbSelect(selectBut: UIButton) {
        if selectBut.tag == 1001 {
            guard selectBut.isSelected else {
                selectBut.isSelected = true
                selectBut.setBackgroundImage(UIImage.init(named: "mine_pay_button_selected_iPhone"), for: .selected)
                zfbSelectBut.isSelected = false
                zfbSelectBut.setBackgroundImage(UIImage.init(named: "mine_pay_button_normal_iPhone"), for: .normal)
                return
            }
            print("已选择微信")

        } else {
            guard selectBut.isSelected else {
                selectBut.isSelected = true
                selectBut.setBackgroundImage(UIImage.init(named: "mine_pay_button_selected_iPhone"), for: .selected)
                wxSelectBut.isSelected = false
                wxSelectBut.setBackgroundImage(UIImage.init(named: "mine_pay_button_normal_iPhone"), for: .normal)
                
                return
            }
            print("已选择支付宝")
        }
    }
    
    // MARK: 支付
    func clickPayAction() {
        updateOrderInfoToWeChat()
        if wxSelectBut.isSelected {
            print("微信支付")
        } else {
            print("支付宝支付")
        }
    }
    

    // 判断是否安装微信
    func isInstallWXAPP() -> Bool {
        if WXApi.isWXAppInstalled() {
            SVProgressHUD.showError(withStatus: "您尚未安装\"微信App\",请先安装后再返回支付")
            return false
        }
        if WXApi.isWXAppSupport() {
            SVProgressHUD.showError(withStatus: "您微信当前版本不支持此功能,请先升级微信应用")
            return false
        }
        return true
    }

    // 获取微信支付信息
    func updateOrderInfoToWeChat() {
        let device = UIDevice.current.identifierForVendor?.uuidString
        print(device)
        // 调用后台接口
        NetRequest.weChatPayNetRequest(uid: AppInfo.shared.user?.userId ?? "", orderName: "兑换券", spbillIp: device ?? "", totalFee: "20") { (success, info, result) in
            if success {
                
            }
        }
        // 返回自己的prepayid
        // wxPayModel 为自定义模型 存储微信支付所需参数
        if wxPayModel?.prepayId != nil {
            print(wxPayModel?.prepayId ?? "")
            
            let req = PayReq()
            req.openID = WeChatAppKey
            req.partnerId = ""
            req.prepayId = ""
            req.nonceStr = ""
            req.timeStamp = 0
            req.package = ""
            req.sign = ""
            WXApi.send(req)
        }
    }
}
