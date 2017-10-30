//
//  SetSystemViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/3/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class SetSystemViewController: BaseViewController {

    fileprivate let titleArray = ["账号安全", "关于阿拉丁", "隐私", "通用"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "系统设置"
        
        setupUI()
    }
    
    // MARK: - Private Methods
    // 设置所有控件
    fileprivate func setupUI() {
        view.addSubview(tableView)
        
        tableView.tableFooterView = footView
        
        footView.addSubview(logoutButton)
        
        setupUIFrame()
    }
    // 设置控件frame
    fileprivate func setupUIFrame() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        logoutButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(footView)
            make.left.equalTo(footView).offset(40)
            make.right.equalTo(footView).offset(-40)
            make.height.equalTo(50)
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
    
    // tableView底部视图
    lazy var footView: UIView = {
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 100))
        footView.backgroundColor = UIColor.white
        
        return footView
    }()
    
    lazy var logoutButton: UIButton = {
        let logoutButton = UIButton(type: .custom)
        logoutButton.setTitle("退出", for: .normal)
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        logoutButton.backgroundColor = UIColor.themeColor
        logoutButton.layer.cornerRadius = 5
        logoutButton.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        
        return logoutButton
    }()
    // MARK: - IBActions
    
    func logoutButtonAction(button: UIButton) {
        AppInfo.shared.user = nil
        SVProgressHUD.showSuccess(withStatus: "退出成功")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? MainTabBarController
        appDelegate.window?.rootViewController = mainVC
        
        RCIM.shared().logout()
    }
}

extension SetSystemViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        cell.accessoryType = .disclosureIndicator
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
            // 账号安全
            navigationController?.pushViewController(ThirdAccountViewController(), animated: true)
        case [0, 1]:
            // 关于阿拉丁
            navigationController?.pushViewController(AboutViewController(), animated: true)
        case [0, 2]:
            // 隐私
            navigationController?.pushViewController(PrivacyViewController(), animated: true)
        case [0, 3]:
            // 通用
            navigationController?.pushViewController(GeneralViewController(), animated: true)
        default:
            break
        }
    }
}
