//
//  LogInViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/3/21.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class LogInViewController: BaseViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "登录"
        
        // 创建注册Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: .done, target: self, action: #selector(registerButtonItemAction))
        
        // 返回按钮图片
        let backButtonImage = UIImage(named: "common_navback_button_normal_iPhone")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImage, style: .done, target: self, action: #selector(backButtonItemAction))
        
        setupUI()
        
        if !UMSocialManager.default().isInstall(UMSocialPlatformType.QQ) {
            QQLogInButton.isHidden = true 
        }
    }
    
    // MARK: - Private Methods
    // 设置UI样式
    fileprivate func setupUI() {
        
        view.addSubview(phoneNumberTextField)
        view.addSubview(passwordTextField)
        view.addSubview(ciphertextButton)
        view.addSubview(logInButton)
        view.addSubview(forgetPassworldButton)
        view.addSubview(thirdLogInLabel)
        view.addSubview(wechatLogInButton)
        view.addSubview(QQLogInButton)
        view.addSubview(microblogLogInButton)
        
        setupUIFrame()
    }
    
    // 设置UIFrame
    fileprivate func setupUIFrame() {
        
        phoneNumberTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(25)
            make.height.equalTo(60)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.left.equalTo(phoneNumberTextField)
            make.right.equalTo(phoneNumberTextField).offset(-80)
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(1)
            make.height.equalTo(phoneNumberTextField)
        }
        
        ciphertextButton.snp.makeConstraints { (make) in
            make.left.equalTo(passwordTextField.snp.right)
            make.right.equalTo(view)
            make.top.height.equalTo(passwordTextField)
            
        }
        
        logInButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(18)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 276, height: 47))
        }
        
        forgetPassworldButton.snp.makeConstraints { (make) in
            make.top.equalTo(logInButton.snp.bottom).offset(23)
            make.right.equalTo(view).offset(-23)
            make.height.equalTo(18)
            make.width.equalTo(60)
        }
        
        thirdLogInLabel.snp.makeConstraints { (make) in
            make.top.equalTo(forgetPassworldButton.snp.top).offset(30)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 120, height: 16))
        }

        wechatLogInButton.snp.makeConstraints { (make) in
            make.top.equalTo(thirdLogInLabel.snp.bottom).offset(20)
            make.left.equalTo(logInButton).offset(15)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        
        QQLogInButton.snp.makeConstraints { (make) in
            make.top.equalTo(thirdLogInLabel.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.size.equalTo(wechatLogInButton)
        }
        
        microblogLogInButton.snp.makeConstraints { (make) in
            make.top.equalTo(thirdLogInLabel.snp.bottom).offset(20)
            make.right.equalTo(logInButton).offset(-15)
            make.size.equalTo(wechatLogInButton)
        }
        
        
    }
    
    // 手机号码文本输入框
    lazy var phoneNumberTextField: LBTextField = {
        let phoneNumberTextField = LBTextField()
        phoneNumberTextField.delegate = self
        phoneNumberTextField.placeholder = "请输入手机号"
        phoneNumberTextField.backgroundColor = UIColor.white
        phoneNumberTextField.keyboardType = .numberPad
        phoneNumberTextField.clearButtonMode = UITextFieldViewMode.always
        return phoneNumberTextField
    }()
    
    // 密码文本输入框
    lazy var passwordTextField: LBTextField = {
        let passwordTextField = LBTextField()
        passwordTextField.delegate = self
        passwordTextField.placeholder = "请输入密码"
        passwordTextField.backgroundColor = UIColor.white
        passwordTextField.keyboardType = .asciiCapable
        passwordTextField.returnKeyType = .done
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clearButtonMode = UITextFieldViewMode.always
        return passwordTextField
    }()
    
    // 密码明文密文按钮
    lazy var ciphertextButton: UIButton = {
        let ciphertextButton = UIButton(type: .custom)
        ciphertextButton.backgroundColor = UIColor.white
        let ciphertextNormalIcon = UIImage(named: "info_noLook_icon_normal_iPhone")
        ciphertextButton.setImage(ciphertextNormalIcon, for: .normal)
        let ciphertextSelectedIcon = UIImage(named: "info_look_icon_normal_iPhone")
        ciphertextButton.setImage(ciphertextSelectedIcon, for: .selected)
        ciphertextButton.contentMode = .scaleAspectFill
        ciphertextButton.addTarget(self, action: #selector(ciphertextButtonAction), for: .touchUpInside)
        
        return ciphertextButton
    }()
    
    // 登录按钮
    lazy var logInButton: UIButton = {
        let logInButton = UIButton(type: .custom)
        logInButton.setTitle("登录", for: .normal)
        logInButton.titleLabel?.textColor = UIColor.white
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        logInButton.backgroundColor = UIColor.themeColor
        logInButton.layer.cornerRadius = 2.5
        logInButton.addTarget(self, action: #selector(logInButtonAction), for: .touchUpInside)
        
        return logInButton
    }()
    
    // 忘记密码按钮
    lazy var forgetPassworldButton: UIButton = {
        let forgetPassworldButton = UIButton(type: .custom)
        forgetPassworldButton.setTitle("忘记密码", for: .normal)
        forgetPassworldButton.setTitleColor(UIColor.themeColor, for: .normal)
        forgetPassworldButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        forgetPassworldButton.addTarget(self, action: #selector(forgetPassworldButtonAction), for: .touchUpInside)
        
        return forgetPassworldButton
    }()
    
    // 其他登录方式文本
    lazy var thirdLogInLabel: UILabel = {
        let thirdLogInLabel = UILabel()
        thirdLogInLabel.text = "-其他登录方式-"
        thirdLogInLabel.font = UIFont.systemFont(ofSize: 13)
        thirdLogInLabel.textAlignment = .center
        thirdLogInLabel.textColor = UIColor.init(hexColor: "#aeaeae")
        
        return thirdLogInLabel
    }()
    
    // 微信登录按钮
    lazy var wechatLogInButton: UIButton = {
        let wechatLogInButton = UIButton(type: .custom)
        let wechatIcon = UIImage(named: "mine_wechet_icon_normal_iPhone")
        wechatLogInButton.setImage(wechatIcon, for: .normal)
        wechatLogInButton.tag = 100
        wechatLogInButton.addTarget(self, action: #selector(thirdLogInButtonAction), for: .touchUpInside)
        
        return wechatLogInButton
    }()
    
    // QQ登录按钮
    lazy var QQLogInButton: UIButton = {
        let QQLogInButton = UIButton(type: .custom)
        let QQIcon = UIImage(named: "mine_qq_icon_normal_iPhone")
        QQLogInButton.setImage(QQIcon, for: .normal)
        QQLogInButton.tag = 101
        QQLogInButton.addTarget(self, action: #selector(thirdLogInButtonAction), for: .touchUpInside)
        
        return QQLogInButton
    }()
    
    // 微博登录按钮
    lazy var microblogLogInButton: UIButton = {
        let microblogLogInButton = UIButton(type: .custom)
        let microblogIcon = UIImage(named: "mine_weibo_icon_normal_iPhone")
        microblogLogInButton.setImage(microblogIcon, for: .normal)
        microblogLogInButton.tag = 102
        microblogLogInButton.addTarget(self, action: #selector(thirdLogInButtonAction), for: .touchUpInside)
        
        return microblogLogInButton
    }()
    
    private func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
        phoneNumberTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // MARK: - IBActions
    
    // 注册ButtonItem点击事件
    func registerButtonItemAction() {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    // 登录按钮点击事件
    func logInButtonAction(button: UIButton) {
        if !(phoneNumberTextField.text?.isMobileTelephoneNumber())! {
            SVProgressHUD.showError(withStatus: "账号格式有误")
            return
        }
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        NetRequest.loginNetRequest(uuid: uuid ?? "", phoneNumber: phoneNumberTextField.text ?? "", password: passwordTextField.text ?? "") { (success, info, dic) in
            if success {
                // 储存用户信息
                let user = UserModel.deserialize(from: dic)
                user?.userInfo = dic
                AppInfo.shared.user = user
                
                RCIM.shared().connect(withToken: AppInfo.shared.user?.rcToken ?? "", success: { (userId) in
                    print("RCIM.userId:\(userId!)")
                }, error: { (status) in
                    print("------------")
                    print(status)
                    print("------------")
                }) {
                    //token过期或者不正确。
                    //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                    //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                    print("token错误")
                }
                
                // 关闭当前视图
                self.dismissSelf()
                SVProgressHUD.showSuccess(withStatus: info)
            } else {
                print(uuid!)
                SVProgressHUD.showError(withStatus: info)
            }
        }
    }
    
    // 忘记密码点击事件
    func forgetPassworldButtonAction(button: UIButton) {
        navigationController?.pushViewController(ForgetPwdStep1ViewController(), animated: true)
    }
    
    // 明文、密文按钮点击事件
    func ciphertextButtonAction(button: UIButton) {
        if button.isSelected {
            button.isSelected = false
            passwordTextField.isSecureTextEntry = true
        } else {
            button.isSelected = true
            passwordTextField.isSecureTextEntry = false
        }
    }
    
    // 第三方登录
    func thirdLogInButtonAction(button: UIButton) {
        switch button.tag {
        case 100:
            getUserInfoForPlatform(platformType: .wechatSession, type: "5")
        case 101:
            getUserInfoForPlatform(platformType: .QQ, type: "4")
        case 102:
            getUserInfoForPlatform(platformType: .sina, type: "6")
        default:
            break
        }
    }
    
    
    
    func getUserInfoForPlatform(platformType: UMSocialPlatformType, type: String) {
        UMSocialManager.default().getUserInfo(with: platformType, currentViewController: self) { (result, error) in
            // 设备id
            let uuid = UIDevice.current.identifierForVendor?.uuidString
            if error != nil {
                
            } else {
                let resp: UMSocialUserInfoResponse = result as! UMSocialUserInfoResponse
                if platformType == .sina {
                    NetRequest.thirdPartyLoginNetRequest(uuid: uuid ?? "", token: resp.uid, type: type, complete: { (success, info, dic) in
                        if success {
                            if info == "登录成功" {
                                // 储存用户信息
                                let user = UserModel.deserialize(from: dic)
                                user?.userInfo = dic
                                AppInfo.shared.user = user
                                
                                RCIM.shared().connect(withToken: AppInfo.shared.user?.rcToken ?? "", success: { (userId) in
                                    print("RCIM.userId:\(userId!)")
                                }, error: { (status) in
                                    print("------------")
                                    print(status)
                                    print("------------")
                                }) {
                                    //token过期或者不正确。
                                    //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                                    //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                                    print("token错误")
                                }
                                
                                self.dismissSelf()
                            } else {
                                // 跳转到绑定手机号页面
                                let binding = BindingViewController()
                                binding.nickname = resp.name
                                binding.headerImage = resp.iconurl
                                binding.sex = resp.gender
                                binding.openId = resp.accessToken
                                binding.type = type
                                self.navigationController?.pushViewController(binding, animated: true)
                            }
                            
                            SVProgressHUD.showSuccess(withStatus: info)
                        } else {
                            SVProgressHUD.showError(withStatus: info)
                        }
                    })
                }
                
                if resp.openid != nil {
                    NetRequest.thirdPartyLoginNetRequest(uuid: uuid ?? "", token: resp.openid, type: type, complete: { (success, info, dic) in
                        if success {
                            if info == "登录成功" {
                                // 储存用户信息
                                let user = UserModel.deserialize(from: dic)
                                user?.userInfo = dic
                                AppInfo.shared.user = user
                                
                                RCIM.shared().connect(withToken: AppInfo.shared.user?.rcToken ?? "", success: { (userId) in
                                    print("RCIM.userId:\(userId!)")
                                }, error: { (status) in
                                    print("------------")
                                    print(status)
                                    print("------------")
                                }) {
                                    //token过期或者不正确。
                                    //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                                    //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                                    print("token错误")
                                }
                                
                                self.dismissSelf()
                            } else {
                                // 跳转到绑定手机号页面
                                let binding = BindingViewController()
                                binding.nickname = resp.name
                                binding.headerImage = resp.iconurl
                                binding.sex = resp.gender
                                binding.openId = resp.openid
                                binding.type = type
                                self.navigationController?.pushViewController(binding, animated: true)
                            }
                            
                            SVProgressHUD.showSuccess(withStatus: info)
                        } else {
                            SVProgressHUD.showError(withStatus: info)
                        }
                    })
                }
                
                
//                // 第三方登录数据(为空表示平台未提供)
//                // 授权数据
                print("uid:\(resp.uid)")
                print("openid:\(resp.openid)")
                print("accessToken:\(resp.accessToken)")
                print("refreshToken:\(resp.refreshToken)")
                print("expiration:\(resp.expiration)")
//
//                // 用户数据
//                print("name:\(resp.name)")
//                print("iconurl:\(resp.iconurl)")
//                print("gender:\(resp.gender)")
//                
//                // 第三方平台SDK原始数据
//                print("originalResponse:\(resp.originalResponse)")
            }
        }
    }
    
    // 返回按钮点击事件
    func backButtonItemAction() {
        dismissSelf()
    }
}

extension LogInViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 当前完整的内容
        var content = textField.text!
        
        if range.length == 0 {
            // 当前是添加内容
            content = content.appending(string)
        } else {
            let index = content.index(before: content.endIndex)
            
            content = content.substring(to: index)
        }
        // 判断字符串长度
        if textField == phoneNumberTextField {
            // 手机号
            return content.characters.count < 12
        } else {
            // 密码
            return content.characters.count < 17
        }
    }
}
