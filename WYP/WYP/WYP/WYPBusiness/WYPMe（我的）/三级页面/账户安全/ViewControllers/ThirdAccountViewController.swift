//
//  ThirdAccountViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/3/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ThirdAccountViewController: BaseViewController {

    fileprivate let titleArray = ["绑定QQ", "绑定微信", "绑定微博", "绑定手机号", "修改密码"]
    
    // 是否绑定QQ
    var isBindingQQ: String?
    
    // 是否绑定WeChat
    var isBindingWeChat: String?
    
    // 是否绑定Sina
    var isBindingSina: String?
    
    // 是否绑定手机号
    var isBindingMobile: String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "账户安全"
        
        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadUserBindingStatus()
    }

    // MARK: - Private Methods
    // 获取用户绑定状态
    func loadUserBindingStatus() {
        NetRequest.userBindingStatusNetRequest(uid: AppInfo.shared.user?.userId ?? "") { (success, info, result) in
            if success {
                self.isBindingQQ = result?.value(forKey: "qq_token") as? String
                self.isBindingWeChat = result?.value(forKey: "wechat_token") as? String
                self.isBindingSina = result?.value(forKey: "weibo_token") as? String
                self.isBindingMobile = result? .value(forKey: "mobile") as? String
                
                self.tableView.reloadData()
            } else {
                print(info!)
            }
        }
    }
    
    // 设置所有控件
    fileprivate func setupUI() {
        view.addSubview(tableView)
        
        setupUIFrame()
    }
    
    // 设置控件frame
    fileprivate func setupUIFrame() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    // 绑定第三方
    func bindingThirdAccount(platformType: UMSocialPlatformType) {

        UMSocialManager.default().getUserInfo(with: platformType, currentViewController: self) { (result, error) in
            
            if result != nil {
    
                let resp: UMSocialUserInfoResponse = result as! UMSocialUserInfoResponse
                
                if platformType == .QQ {
                    NetRequest.userBindingNetRequest(token: resp.openid, type: "1", uid: AppInfo.shared.user?.userId ?? "", complete: { (success, info) in
                        if success {
                            SVProgressHUD.showSuccess(withStatus: info!)
                        } else {
                            SVProgressHUD.showError(withStatus: info!)
                        }
                        self.loadUserBindingStatus()
                    })
                } else if platformType == .wechatSession {
                    NetRequest.userBindingNetRequest(token: resp.openid, type: "2", uid: AppInfo.shared.user?.userId ?? "", complete: { (success, info) in
                        if success {
                            SVProgressHUD.showSuccess(withStatus: info!)
                        } else {
                            SVProgressHUD.showError(withStatus: info!)
                        }
                        self.loadUserBindingStatus()
                    })
                } else if platformType == .sina {
                    NetRequest.userBindingNetRequest(token: resp.uid, type: "3", uid: AppInfo.shared.user?.userId ?? "", complete: { (success, info) in
                        if success {
                            SVProgressHUD.showSuccess(withStatus: info!)
                        } else {
                            SVProgressHUD.showError(withStatus: info!)
                        }
                        self.loadUserBindingStatus()
                    })
                }
            }
        }
        self.loadUserBindingStatus()
    }
    
    // 解绑第三方
    func unBindingThirdAccount(type: String) {
        NetRequest.unBindingNetRequest(uid: AppInfo.shared.user?.userId ?? "", type: type, complete: { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info!)
                self.loadUserBindingStatus()
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        })
    }
    
    // MARK: - setter and getter
    // 设置tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
//        tableView.isScrollEnabled = false
        tableView.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ThirdAccountCellIdentifier")
        
        return tableView
    }()
    
    // MARK: - IBActions
    func bindingThird(sender: UISwitch) {
        switch sender.tag {
        case 104:
            if isBindingQQ == "0" {
                // 绑定QQ
                bindingThirdAccount(platformType: .QQ)
            } else {
                // 解绑QQ
                unBindingThirdAccount(type: "4")
            }
        case 105:
            if isBindingWeChat == "0" {
                // 绑定微信
                bindingThirdAccount(platformType: .wechatSession)
            } else {
                // 解绑微信
                unBindingThirdAccount(type: "5")
            }
        case 106:
            if isBindingSina == "0" {
                // 绑定微博
                bindingThirdAccount(platformType: .sina)
            } else {
                // 解绑微博
                unBindingThirdAccount(type: "6")
            }
        case 107:
            SVProgressHUD.showError(withStatus: "手机号不能解绑")
            self.loadUserBindingStatus()
        default:
            break
        }
    }
    
    // MARK: - Getter
    
    
    // MARK: - Setter
    
    
    // MARK: - UITableViewDataSource
    
    
    // MARK: - UITableViewDelegate
    
    
    // MARK: - Other Delegate
    
    
    // MARK: - NSCopying
}

extension ThirdAccountViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ThirdAccountCellIdentifier")
        // 设置标题
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        if indexPath.row == 4 {
            cell.accessoryType = .disclosureIndicator
        } else {
            let bindingsSwitch = UISwitch()
            bindingsSwitch.onTintColor = UIColor.themeColor
            bindingsSwitch.tag = 100 + indexPath.row + 4
            bindingsSwitch.addTarget(self, action: #selector(bindingThird(sender:)), for: .valueChanged)
            cell.contentView.addSubview(bindingsSwitch)
            bindingsSwitch.snp.makeConstraints({ (make) in
                make.centerY.equalTo(cell.contentView)
                make.right.equalTo(cell.contentView).offset(-12)
            })
            
            switch indexPath.row {
            case 0:
                if isBindingQQ == "1" {
                    bindingsSwitch.isOn = true
                } else {
                    bindingsSwitch.isOn = false
                }
            case 1:
                if isBindingWeChat == "1" {
                    bindingsSwitch.isOn = true
                } else {
                    bindingsSwitch.isOn = false
                }
            case 2:
                if isBindingSina == "1" {
                    bindingsSwitch.isOn = true
                } else {
                    bindingsSwitch.isOn = false
                }
            case 3:
                if isBindingMobile == "1" {
                    bindingsSwitch.isOn = true
                } else {
                    bindingsSwitch.isOn = false
                }
            default:
                break
            }
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.vcBgColor
        return headerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            navigationController?.pushViewController(ChangePwdViewController(), animated: true)
        }
    }
}
