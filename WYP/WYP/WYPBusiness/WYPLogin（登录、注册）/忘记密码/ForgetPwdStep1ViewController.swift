//
//  ForgetPwdStep1ViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/3/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ForgetPwdStep1ViewController: BaseViewController {
    
    // MARK: - Lifecyclevar  
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
        view.addSubview(phoneNumberTextField)
        
        view.addSubview(backView)
        
        backView.addSubview(verificationCodeButton)
        backView.addSubview(verificationCodeTextField)
        
        view.addSubview(nextButton)
        
        setupUIFrame()
    }
    
    fileprivate func setupUIFrame() {
        
        phoneNumberTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(25)
            make.height.equalTo(60)
        }
        
        backView.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneNumberTextField)
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(1)
            make.height.equalTo(phoneNumberTextField)
        }
        
        verificationCodeButton.snp.makeConstraints { (make) in
            make.right.equalTo(backView).offset(-14)
            make.centerY.equalTo(backView)
            make.size.equalTo(CGSize(width: 78, height: 25))
        }
        
        verificationCodeTextField.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(backView)
            make.right.equalTo(verificationCodeButton.snp.left).offset(-10)
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(verificationCodeTextField.snp.bottom).offset(18)
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
    
    // 背景
    lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = UIColor.white
        return backView
    }()
    
    // 验证码文本输入框
    lazy var verificationCodeTextField: LBTextField = {
        let verificationCodeTextField = LBTextField()
        verificationCodeTextField.delegate = self
        verificationCodeTextField.placeholder = "验证码"
        verificationCodeTextField.backgroundColor = UIColor.white
        verificationCodeTextField.returnKeyType = .done
        
        return verificationCodeTextField
    }()
    
    // 切换验证码按钮
    lazy var verificationCodeButton: PooCodeView = {
        let verificationCodeButton = PooCodeView()
        verificationCodeButton.backgroundColor = UIColor.white
        verificationCodeButton.layer.cornerRadius = 5
        verificationCodeButton.layer.borderWidth = 1
        verificationCodeButton.layer.borderColor = UIColor.themeColor.cgColor
        
        return verificationCodeButton
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
    
    func nextButtonAction(button: UIButton) {
        // 验证码不区分大小写
        let verificationCodeNSString = verificationCodeTextField.text! as NSString
        let verificationCodeBool = verificationCodeNSString.compare(verificationCodeButton.changeString as String, options: NSString.CompareOptions.caseInsensitive) == ComparisonResult.orderedSame
        
        
        if !(phoneNumberTextField.text?.isMobileTelephoneNumber())! {
            SVProgressHUD.showError(withStatus: "手机号格式有误")
            return
        } else if !(verificationCodeBool) {
            SVProgressHUD.showError(withStatus: "验证码有误")
            return
        }
        let forgetPwdStep2VC = ForgetPwdStep2ViewController()
        forgetPwdStep2VC.phoneNumber = phoneNumberTextField.text!
        navigationController?.pushViewController(forgetPwdStep2VC, animated: true)
    }
    
    // MARK: - Getter
    
    
    // MARK: - Setter
    
    
    // MARK: - UITableViewDataSource
    
    
    // MARK: - UITableViewDelegate
    
    
    // MARK: - Other Delegate
    
    
    // MARK: - NSCopying

}

extension ForgetPwdStep1ViewController: UITextFieldDelegate {
    
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
            // 验证码
//            return content.characters.count < 5
        }
        return true
    }
}
