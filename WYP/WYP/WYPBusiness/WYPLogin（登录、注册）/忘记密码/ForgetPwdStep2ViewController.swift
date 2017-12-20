//
//  ForgetPwdStep2ViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/3/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ForgetPwdStep2ViewController: BaseViewController {
    
    // 手机号码
    var phoneNumber: String? = nil
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "忘记密码"
        
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Public Methods
    
    
    // MARK: - Private Methods
    
    fileprivate func setupUI() {
        
        view.addSubview(verificationCodeTextField)
        
        view.addSubview(sendVerificationCodeButton)
        
        view.addSubview(nextButton)
        
        setupUIFrmae()
    }
    
    fileprivate func setupUIFrmae() {
        
        verificationCodeTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(25)
            make.height.equalTo(60)
        }
        
        sendVerificationCodeButton.snp.makeConstraints { (make) in
            make.right.equalTo(verificationCodeTextField).offset(-14)
            make.centerY.equalTo(verificationCodeTextField)
            make.size.equalTo(CGSize(width: 78, height: 25))
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(verificationCodeTextField.snp.bottom).offset(18)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 276, height: 47))
        }
    }
    
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
    
    // 下一步按钮
    lazy var nextButton: UIButton = {
        let nextButton = UIButton(type: .custom)
        nextButton.setTitle("下一步", for: .normal)
        nextButton.titleLabel?.textColor = UIColor.white
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        nextButton.backgroundColor = UIColor.themeColor
        nextButton.layer.cornerRadius = 2.5
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        
        return nextButton
    }()
    
    // MARK: - IBActions
    
    // 发送验证码按钮点击事件
    func sendVerificationCodeButtonAction(button: LBCodeButton) {
        // 调用发送验证码接口
        NetRequest.sendVerificationCodeNetRequest(phoneNumber: phoneNumber!, action: "member") { (success, info) in
            if success {
                // 发送成功
                SVProgressHUD.showSuccess(withStatus: info)
                button.startTime()
            } else {
                // 发送失败
                SVProgressHUD.showError(withStatus: info)
            }
        }
    }
    
    // 下一步按钮点击事件
    func nextButtonAction(button: UIButton) {
        // 验证  验证码是否正确
        NetRequest.verifyCodeNetRequest(phoneNumber: phoneNumber!, verifyCode: verificationCodeTextField.text!) { (success, info) in
            if success {
                // 验证成功
                let forgetPwdStep3VC = ForgetPwdStep3ViewController()
                forgetPwdStep3VC.phoneNumber = self.phoneNumber
                self.navigationController?.pushViewController(forgetPwdStep3VC, animated: true)
            } else {
                // 验证失败
                SVProgressHUD.showError(withStatus: info)
            }
        }
    }
}

extension ForgetPwdStep2ViewController: UITextFieldDelegate {
    
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
        // 验证码
        return content.characters.count < 7
    }
}
