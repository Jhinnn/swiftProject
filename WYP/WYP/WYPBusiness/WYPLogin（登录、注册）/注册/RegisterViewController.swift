//
//  RegisterViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/3/21.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "注册"
        
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Public Methods
    
    
    // MARK: - Private Methods
    
    fileprivate func setupUI() {
        
        view.addSubview(phoneNumberTextField)
        view.addSubview(verificationCodeTextField)
        view.addSubview(sendVerificationCodeButton)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPwdTextField)
        view.addSubview(ciphertextButton)
        view.addSubview(ciphertextButton1)
        view.addSubview(agreeButton)
        view.addSubview(agreeLabel)
        view.addSubview(seriveButton)
        view.addSubview(registerButton)
        setupUIFrame()
    }
    
    fileprivate func setupUIFrame() {
        
        phoneNumberTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(25)
            make.height.equalTo(60)
        }
        
        verificationCodeTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneNumberTextField)
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(1)
            make.height.equalTo(phoneNumberTextField)
        }
        
        sendVerificationCodeButton.snp.makeConstraints { (make) in
            make.right.equalTo(verificationCodeTextField).offset(-14)
            make.centerY.equalTo(verificationCodeTextField)
            make.size.equalTo(CGSize(width: 78, height: 25))
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneNumberTextField)
            make.top.equalTo(verificationCodeTextField.snp.bottom).offset(1)
            make.height.equalTo(phoneNumberTextField)
        }
        
        confirmPwdTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneNumberTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(1)
            make.height.equalTo(phoneNumberTextField)
        }
        
        ciphertextButton.snp.makeConstraints { (make) in
            make.right.equalTo(passwordTextField).offset(-14)
            make.centerY.equalTo(passwordTextField)
            make.size.equalTo(27)
        }
        
        ciphertextButton1.snp.makeConstraints { (make) in
            make.right.equalTo(confirmPwdTextField).offset(-14)
            make.centerY.equalTo(confirmPwdTextField)
            make.size.equalTo(27)
        }
        
        agreeButton.snp.makeConstraints { (make) in
            make.top.equalTo(confirmPwdTextField.snp.bottom).offset(10)
            make.left.equalTo(view).offset(13)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        agreeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(agreeButton)
            make.left.equalTo(agreeButton.snp.right).offset(5)
            make.size.equalTo(CGSize(width: 90, height: 15))
        }
        
        seriveButton.snp.makeConstraints { (make) in
            make.top.equalTo(agreeButton)
            make.left.equalTo(agreeLabel.snp.right)
            make.size.equalTo(CGSize(width: 90, height: 15))
        }
        
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(agreeButton.snp.bottom).offset(18)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 276, height: 47))
        }
    }
    
    // 手机号码文本输入框
    lazy var phoneNumberTextField: LBTextField = {
        let phoneNumberTextField = LBTextField()
        phoneNumberTextField.delegate = self
        phoneNumberTextField.placeholder = "请输入手机号"
        phoneNumberTextField.backgroundColor = UIColor.white
        phoneNumberTextField.keyboardType = .numberPad
        
        return phoneNumberTextField
    }()
    
    // 验证码文本输入框
    lazy var verificationCodeTextField: LBTextField = {
        let verificationCodeTextField = LBTextField()
        verificationCodeTextField.delegate = self
        verificationCodeTextField.placeholder = "请输入验证码"
        verificationCodeTextField.backgroundColor = UIColor.white
        verificationCodeTextField.keyboardType = .numberPad
        
        return verificationCodeTextField
    }()
    
    // 发送验证码按钮
    lazy var sendVerificationCodeButton: LBCodeButton = {
        let sendVerificationCodeButton = LBCodeButton.shared
        sendVerificationCodeButton.setTitle("获取验证码", for: .normal)
        sendVerificationCodeButton.setTitleColor(UIColor.themeColor, for: .normal)
        sendVerificationCodeButton.layer.cornerRadius = 5
        sendVerificationCodeButton.layer.borderWidth = 1
        sendVerificationCodeButton.layer.borderColor = UIColor.themeColor.cgColor
        sendVerificationCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        sendVerificationCodeButton.addTarget(self, action: #selector(sendVerificationCodeButtonAction), for: .touchUpInside)
        
        return sendVerificationCodeButton
    }()
    
    // 密码文本输入框
    lazy var passwordTextField: LBTextField = {
        let passwordTextField = LBTextField()
        passwordTextField.delegate = self
        passwordTextField.placeholder = "密码需8-16位，至少含数字/字母2种组合"
        passwordTextField.backgroundColor = UIColor.white
        passwordTextField.keyboardType = .asciiCapable
        passwordTextField.returnKeyType = .done
        passwordTextField.isSecureTextEntry = true
        
        return passwordTextField
    }()
    
    // 确定密码文本输入框
    lazy var confirmPwdTextField: LBTextField = {
        let confirmPwdTextField = LBTextField()
        confirmPwdTextField.placeholder = "再次输入密码"
        confirmPwdTextField.backgroundColor = UIColor.white
        confirmPwdTextField.keyboardType = .asciiCapable
        confirmPwdTextField.returnKeyType = .done
        confirmPwdTextField.isSecureTextEntry = true
        
        return confirmPwdTextField
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
    
    // 密码明文密文按钮
    lazy var ciphertextButton1: UIButton = {
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

    // 服务条款
    lazy var agreeButton: UIButton = {
        let agreeButton = UIButton()
        agreeButton.setImage(UIImage(named: "mine_choose_button_normal_iPhone"), for: .normal)
        agreeButton.setImage(UIImage(named: "mine_choose_button_selected_iPhone"), for: .selected)
        agreeButton.addTarget(self, action: #selector(agreeServiceTerms(sender:)), for: .touchUpInside)
        return agreeButton
    }()
    
    lazy var agreeLabel: UILabel = {
        let agreeLabel = UILabel()
        agreeLabel.text = "我已阅读并同意"
        agreeLabel.textColor = UIColor.init(hexColor: "a1a1a1")
        agreeLabel.font = UIFont.systemFont(ofSize: 12)
        return agreeLabel
    }()
    
    lazy var seriveButton: UIButton = {
        let seriveButton = UIButton()
        seriveButton.setTitle("阿拉丁的服务条款", for: .normal)
        seriveButton.setTitleColor(UIColor.themeColor, for: .normal)
        seriveButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        seriveButton.addTarget(self, action: #selector(readServiceTerms(sender:)), for: .touchUpInside)
        return seriveButton
    }()
    
    // 注册按钮
    lazy var registerButton: UIButton = {
        let registerButton = UIButton(type: .custom)
        registerButton.setTitle("注册", for: .normal)
        registerButton.titleLabel?.textColor = UIColor.white
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        registerButton.backgroundColor = UIColor.themeColor
        registerButton.layer.cornerRadius = 2.5
        registerButton.addTarget(self, action: #selector(registerButtonAction), for: .touchUpInside)
        
        return registerButton
    }()
    
    // MARK: - IBActions
    // 阅读并同意
    func agreeServiceTerms(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    // 条款内容
    func readServiceTerms(sender: UIButton) {
        let serive = SeriveTermsViewController()
        navigationController?.pushViewController(serive, animated: true)
    }

    
    // 明文、密文按钮点击事件
    func ciphertextButtonAction(button: UIButton) {
        if button.isSelected {
            button.isSelected = false
            if button == ciphertextButton {
                passwordTextField.isSecureTextEntry = true
            } else if button == ciphertextButton1 {
                confirmPwdTextField.isSecureTextEntry = true
            }
            
        } else {
            button.isSelected = true
            if button == ciphertextButton {
                passwordTextField.isSecureTextEntry = false
            } else if button == ciphertextButton1 {
                confirmPwdTextField.isSecureTextEntry = false
            }
        }
    }
    
    func sendVerificationCodeButtonAction(button: LBCodeButton) {
        if !(phoneNumberTextField.text?.isMobileTelephoneNumber())! {
            // 用户输入的不是手机号
            SVProgressHUD.showError(withStatus: "请输入正确手机号")
            return
        }
        // 调用发送验证码接口
        NetRequest.sendVerificationCodeNetRequest(phoneNumber: phoneNumberTextField.text!, action: "config") { (success, info) in
            SVProgressHUD.showSuccess(withStatus: info)
            if success {
                // 发送成功
                button.startTime()
            } else {
                // 发送失败
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
    
    func registerButtonAction(button: UIButton) {
        // 必须阅读并同意才能注册
        if !agreeButton.isSelected {
            SVProgressHUD.showError(withStatus: "请先阅读并同意服务条款")
            return
        }
        
        if !(phoneNumberTextField.text?.isMobileTelephoneNumber())! {
            // 手机号格式有误
            SVProgressHUD.showError(withStatus: "手机号格式有误")
            return
        } else if !(passwordTextField.text?.isPasswordValid())! {
            // 密码格式有误
            SVProgressHUD.showError(withStatus: "密码需8-16位，至少含数字/字母2种组合")
            return
        } else if verificationCodeTextField.text?.characters.count != 6 {
            // 验证码格式有误
            SVProgressHUD.showError(withStatus: "验证码格式有误")
            return
        } else if passwordTextField.text != confirmPwdTextField.text {
            SVProgressHUD.showError(withStatus: "两次密码不匹配")
            return
        }
        // 调用注册接口
        NetRequest.registerNetRequest(phoneNumber: phoneNumberTextField.text!, verifyCode: verificationCodeTextField.text!, password: passwordTextField.text!) { (success, info) in
            // 展示提示文本
            SVProgressHUD.showSuccess(withStatus: info)
            if success {
                let uuid = UIDevice.current.identifierForVendor?.uuidString
                // 注册成功
                NetRequest.loginNetRequest(uuid: uuid ?? "", phoneNumber: self.phoneNumberTextField.text!, password: self.passwordTextField.text!) { (success, info, dic) in
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
                        self.dismissSelf()
                        
                        SVProgressHUD.showSuccess(withStatus: info)
                    } else {
                        SVProgressHUD.showError(withStatus: info)
                    }
                }
            } else {
                // 注册失败
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
    
    // MARK: - Getter
    func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
        phoneNumberTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // MARK: - Setter
    
    
    // MARK: - UITableViewDataSource
    
    
    // MARK: - UITableViewDelegate
    
    
    // MARK: - Other Delegate
    
    
    // MARK: - NSCopying
}

extension RegisterViewController: UITextFieldDelegate {
    
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
        } else if textField == verificationCodeTextField {
            // 验证码
            return content.characters.count < 7
        } else {
            // 密码
            return content.characters.count < 17
        }
    }
}
