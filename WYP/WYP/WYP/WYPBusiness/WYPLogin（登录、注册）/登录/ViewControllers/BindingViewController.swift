//
//  BindingViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class BindingViewController: BaseViewController {

    // 用户昵称
    var nickname: String?
    // 用户头像
    var headerImage: String?
    // 用户的性别
    var sex: String?
    // 第三方登录的唯一标识
    var openId: String?
    // 用户的登录方式
    var type: String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "绑定手机号"
        
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
        view.addSubview(pointTextLabel)
        view.addSubview(registerButton)
        
        setupUIFrmae()
    }
    
    fileprivate func setupUIFrmae() {
        
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
        
        pointTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(18)
            make.left.equalTo(self.view).offset(13)
            make.right.equalTo(self.view).offset(-13)
        }
        
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(pointTextLabel.snp.bottom).offset(18)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 276, height: 47))
        }
    }
    
    private func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
        phoneNumberTextField.resignFirstResponder()
        verificationCodeTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
    
    // 提示文字
    lazy var pointTextLabel: UILabel = {
        let pointTextLabel = UILabel()
        pointTextLabel.text = "手机号是阿拉丁平台的唯一身份认证方式，如果您是第一次用第三方平台登录，请进行手机绑定后使用，绑定后再次登陆时将可以直接使用第三方平台登录"
        pointTextLabel.font = UIFont.systemFont(ofSize: 12)
        pointTextLabel.numberOfLines = 0
        pointTextLabel.textColor = UIColor.init(hexColor: "a1a1a1")
        return pointTextLabel
    }()
    
    // 完成按钮
    lazy var registerButton: UIButton = {
        let registerButton = UIButton(type: .custom)
        registerButton.setTitle("完成", for: .normal)
        registerButton.titleLabel?.textColor = UIColor.white
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        registerButton.backgroundColor = UIColor.themeColor
        registerButton.layer.cornerRadius = 2.5
        registerButton.addTarget(self, action: #selector(bindingButtonAction), for: .touchUpInside)
        
        return registerButton
    }()
    
    // MARK: - IBActions
    
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
                SVProgressHUD.showError(withStatus: info!)
                // 发送失败
            }
        }
    }
    
    func bindingButtonAction(button: UIButton) {

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
        }
        
        // 调用绑定手机号接口
        NetRequest.bindingMobileNetRequest(nickname: nickname ?? "", path: headerImage ?? "", sex: sex ?? "", mobile: self.phoneNumberTextField.text ?? "", verify: self.verificationCodeTextField.text ?? "", password: passwordTextField.text ?? "", token: openId ?? "", type: type ?? "") { (success, info, dic) in
            if success {
                // 储存用户信息
                let user = UserModel.deserialize(from: dic)
                user?.userInfo = dic
                AppInfo.shared.user = user
                
                // 关闭当前视图
                self.dismissSelf()
                SVProgressHUD.showSuccess(withStatus: info)
            } else {
                SVProgressHUD.showError(withStatus: info)
            }
        }
    }

}

extension BindingViewController: UITextFieldDelegate {
    
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
