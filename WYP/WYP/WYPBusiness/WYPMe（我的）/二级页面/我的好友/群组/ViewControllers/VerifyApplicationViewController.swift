//
//  VerifyApplicationViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class VerifyApplicationViewController: BaseViewController {

    // 好友Id
    var applyMobile: String?
    // 群组Id
    var groupId: String?
    // 群组跳过来的为2
    var flag: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfig()
        layoutPageSubviews()

    }

    // MARK: - private method
    func viewConfig() {
        
        self.title = "验证申请"
        let rightBarButton = UIBarButtonItem(title: "发送", style: .done, target: self, action: #selector(clickSendButton(sender:)))
        navigationItem.rightBarButtonItem = rightBarButton
        
        view.addSubview(backView)
        backView.addSubview(verifyinfoLabel)
        backView.addSubview(verifyTextField)
        backView.addSubview(redLine)
    }
    func layoutPageSubviews() {
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(0)
            make.left.equalTo(view)
            make.size.equalTo(CGSize(width: kScreen_width, height: 101))
        }
        verifyinfoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backView).offset(18)
            make.left.equalTo(backView).offset(13)
            make.right.equalTo(backView).offset(-13)
            make.height.equalTo(15)
        }
        verifyTextField.snp.makeConstraints { (make) in
            make.top.equalTo(verifyinfoLabel.snp.bottom).offset(15)
            make.left.equalTo(backView).offset(13)
            make.right.equalTo(backView).offset(-13)
            make.height.equalTo(30)
        }
        redLine.snp.makeConstraints { (make) in
            make.top.equalTo(verifyTextField.snp.bottom).offset(2)
            make.left.equalTo(backView).offset(13)
            make.right.equalTo(backView).offset(-13)
            make.height.equalTo(1)
        }
    }

    // MARK: - event response
    func clickSendButton(sender: UIBarButtonItem) {

        if flag == 2 {  //群组
            NetRequest.enterGroupNetRequest(type: "", openId: AppInfo.shared.user?.token ?? "", groupId: groupId ?? "", comment: verifyTextField.text ?? "", complete: { (success, info) in
                if success {
                    
                    //发送通知刷新首页群组信息
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshQunzhuNotification"), object: self, userInfo: nil)
                    
                    SVProgressHUD.showSuccess(withStatus: "申请信息已提交，等待群主审核中！")
                    let viewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
                    self.navigationController?.popToViewController(viewController!, animated: true)
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            })
        } else { // 添加好友
            NetRequest.verifyApplicationNetRequest(openId: AppInfo.shared.user?.token ?? "", mobile: applyMobile ?? "", info: verifyTextField.text ?? "") { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info!)
                    let groupList = GroupMemberListViewController()
                    groupList.isAdd = true
                    SVProgressHUD.showSuccess(withStatus: "申请信息已提交，等待对方通过审核！")
                    let viewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 1]
                    self.navigationController?.popToViewController(viewController!, animated: true)
                   
                
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                     print(self.applyMobile)
                }
            }
        }
        
    }
    
    // MARK: - setter and getter
    lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = UIColor.white
        return backView
    }()
    lazy var verifyinfoLabel: UILabel = {
        let verifyinfoLabel = UILabel()
        verifyinfoLabel.font = UIFont.boldSystemFont(ofSize: 16)
        verifyinfoLabel.textColor = UIColor.init(hexColor: "999999")
        verifyinfoLabel.text = "你需要发送验证申请，等待对方通过"
        return verifyinfoLabel
    }()
    
    lazy var verifyTextField: UITextField = {
        let verifyTextField = UITextField()
        verifyTextField.borderStyle = .none
        verifyTextField.placeholder = "请输入验证内容"
        verifyTextField.font = UIFont.boldSystemFont(ofSize: 16)
        return verifyTextField
    }()
    
    lazy var redLine: UIView = {
        let redLine = UIView()
        redLine.backgroundColor = UIColor.themeColor
        return redLine
    }()
    
    deinit{
        
        //注意由于通知是单例的，所以用了之后需要析构，
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "RefreshQunzhuNotification"), object: nil)
    }
}


