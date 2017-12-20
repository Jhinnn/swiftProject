//
//  ChangePwdViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/4/4.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ChangePwdViewController: BaseViewController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "修改密码"
        
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Public Methods
    
    
    // MARK: - Private Methods
    
    // 设置UI样式
    fileprivate func setupUI() {
        
        view.addSubview(oldPassWordTextField)
        
        view.addSubview(newPasswordTextField)
        
        view.addSubview(confirmPwdTextField)
        
        view.addSubview(finishButton)
        
        setupUIFrame()
    }
    
    // 设置UIframe
    fileprivate func setupUIFrame() {
        
        oldPassWordTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(25)
            make.height.equalTo(60)
        }
        
        newPasswordTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(oldPassWordTextField)
            make.top.equalTo(oldPassWordTextField.snp.bottom).offset(1)
            make.height.equalTo(oldPassWordTextField)
        }
        
        confirmPwdTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(newPasswordTextField)
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(1)
            make.height.equalTo(newPasswordTextField)
        }
        
        finishButton.snp.makeConstraints { (make) in
            make.top.equalTo(confirmPwdTextField.snp.bottom).offset(18)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 276, height: 47))
        }
    }
    
    // 旧密码
    lazy var oldPassWordTextField: LBTextField = {
        let oldPassWordTextField = LBTextField()
        oldPassWordTextField.placeholder = "请输入旧密码"
        oldPassWordTextField.backgroundColor = UIColor.white
        oldPassWordTextField.keyboardType = .asciiCapable
        oldPassWordTextField.returnKeyType = .done
        oldPassWordTextField.isSecureTextEntry = true
        
        return oldPassWordTextField
    }()
    
    // 密码文本输入框
    lazy var newPasswordTextField: LBTextField = {
        let newPasswordTextField = LBTextField()
        newPasswordTextField.placeholder = "密码需8-16位，至少含数字/字母2种组合"
        newPasswordTextField.backgroundColor = UIColor.white
        newPasswordTextField.keyboardType = .asciiCapable
        newPasswordTextField.returnKeyType = .done
        newPasswordTextField.isSecureTextEntry = true
        
        return newPasswordTextField
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
    
    // 登录按钮
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
    
    // 完成按钮点击事件
    func finishButtonAction(button: UIButton) {
        
        if !(newPasswordTextField.text!.isPasswordValid() || confirmPwdTextField.text!.isPasswordValid()) {
            SVProgressHUD.showError(withStatus: "密码需8-16位，至少含数字/字母2种组合")
            return
        }
        if newPasswordTextField.text != confirmPwdTextField.text {
            SVProgressHUD.showError(withStatus: "两次密码不匹配")
            return 
        }
        
        NetRequest.modifyPasswordNetRequest(oldPassword: oldPassWordTextField.text ?? "", newPassword: newPasswordTextField.text ?? "", token: AppInfo.shared.user?.token ?? "") { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info!)
                self.navigationController?.popViewController(animated: true)
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
}

extension ChangePwdViewController: UITextFieldDelegate {
    
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
        return content.characters.count < 17
    }
}
