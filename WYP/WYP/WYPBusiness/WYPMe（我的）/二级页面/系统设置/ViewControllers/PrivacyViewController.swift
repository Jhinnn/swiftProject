//
//  PrivacyViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/5/9.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class PrivacyViewController: BaseViewController {
    
    // 是否允许观看朋友圈
    var isAllowCommunity: String?
    // 是否允许添加好友
    var isAllowAdd: String?
    
    fileprivate let titleArray = ["不允许别人看我的社区动态", "不允许别人加我好友"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "隐私"
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadCurrentPrivacy()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Public Methods
    func loadCurrentPrivacy() {
        NetRequest.currentPrivacyInfoNetRequest(openId: AppInfo.shared.user?.token ?? "") { (success, info, result) in
            if success {
                self.isAllowCommunity = result?.value(forKey: "community") as? String
                self.isAllowAdd = result?.value(forKey: "friend") as? String
                self.tableView.reloadData()
            } else {
                print(info!)
            }
        }
    }
    
    // MARK: - Private Methods
    
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
    
    // 设置tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = 55
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SetSystemCellIdentifier")
        
        return tableView
    }()
    
    // MARK: - IBActions
    func settingMyPrivacy(sender: UISwitch) {
        switch sender.tag {
        case 0:
           print(AppInfo.shared.user?.userId ?? "")
           NetRequest.unallowLookMyCommunityNetRequest(uid: AppInfo.shared.user?.userId ?? "", complete: { (success, info) in
               if success {
                  SVProgressHUD.showSuccess(withStatus: info!)
                  self.loadCurrentPrivacy()
               } else {
                  SVProgressHUD.showError(withStatus: info!)
            }
           })
            
        case 1:
            NetRequest.unallowAddMeNetRequest(openId: AppInfo.shared.user?.token ?? "", complete: { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info!)
                    self.loadCurrentPrivacy()
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            })
            
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

extension PrivacyViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "SetSystemCellIdentifier")
        // 设置标题
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.textColor = UIColor.init(hexColor: "#333333")
        
        let `switch` = UISwitch(frame: CGRect(x: kScreen_width - 51 - 15, y: 15, width: 51, height: 31))
        `switch`.onTintColor = UIColor.themeColor
        `switch`.center.y = cell.contentView.center.y
        `switch`.addTarget(self, action: #selector(settingMyPrivacy(sender:)), for: .valueChanged)
        `switch`.tag = indexPath.row
        // 设置当前状态
        if isAllowCommunity == "0" && indexPath.row == 0 { // 1：允许所有人看 # 0：禁止别人看
            `switch`.isOn = true
        }
        if isAllowAdd == "1" && indexPath.row == 1 { // 0:允许   1: 不允许
            `switch`.isOn = true
        }
        cell.contentView.addSubview(`switch`)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12.5
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.vcBgColor
        return headerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath {
        case [0, 0]:
            // 禁止推送
            print("不允许别人看我的社区动态")
        case [0, 1]:
            // 清除缓存
            print("不允许别人加我好友")
        default:
            print("")
        }
    }
}
