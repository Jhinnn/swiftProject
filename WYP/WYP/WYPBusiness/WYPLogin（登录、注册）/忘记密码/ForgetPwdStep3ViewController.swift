//
//  ForgetPwdStep3ViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/3/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ForgetPwdStep3ViewController: BaseViewController {
    
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
        
        view.addSubview(passwordTextField)
        
        view.addSubview(confirmPwdTextField)
        
        view.addSubview(finishButton)
        
        setupUIFrame()
    }
    
    fileprivate func setupUIFrame() {
        
        passwordTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(25)
            make.height.equalTo(60)
        }
        
        confirmPwdTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(passwordTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(1)
            make.height.equalTo(passwordTextField)
        }
        
        finishButton.snp.makeConstraints { (make) in
            make.top.equalTo(confirmPwdTextField.snp.bottom).offset(18)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 276, height: 47))
        }
    }
    
    // 密码文本输入框
    lazy var passwordTextField: LBTextField = {
        let passwordTextField = LBTextField()
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
    
    // 完成按钮
    lazy var finishButton: UIButton = {
        let finishButton = UIButton(type: .custom)
        finishButton.setTitle("完成", for: .normal)
        finishButton.titleLabel?.textColor = UIColor.white
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        finishButton.backgroundColor = UIColor.themeColor
        finishButton.layer.cornerRadius = 2.5
        finishButton.addTarget(self, action: #selector(finishButtonAction), for: .touchUpInside)
        
        return finishButton
    }()
    
    // MARK: - IBActions
    
    func finishButtonAction(button: UIButton) {
        if !((passwordTextField.text?.isPasswordValid())! || (confirmPwdTextField.text?.isPasswordValid())!) {
            // 密码格式不正确
            SVProgressHUD.showError(withStatus: "密码需8-16位，至少含数字/字母2种组合")
            return
        }
        if passwordTextField.text! != confirmPwdTextField.text! {
            // 两次密码不匹配
            SVProgressHUD.showError(withStatus: "两次密码不匹配")
            return 
        }
        // 请求忘记密码接口
        NetRequest.forgetPasswordNetRequest(phoneNumber: phoneNumber!, password: passwordTextField.text!) { (success, info) in
            if success {
                // 修改成功
                SVProgressHUD.showSuccess(withStatus: info)
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                // 修改失败
                SVProgressHUD.showError(withStatus: info)
            }
        }
        
    }
    
    // MARK: - Getter
    
    
    
    // MARK: - Setter
    
    
    
    // MARK: - UITableViewDataSource
    
    
    // MARK: - UITableViewDelegate
    
    
    // MARK: - Other Delegate
    
    
    // MARK: - NSCopying
    
}
