//
//  ManagerGroupViewController.swift
//  WYP
//
//  Created by aLaDing on 2017/12/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ManagerGroupViewController: UIViewController {
    
    var groupId : String?
    
    var managerGroupInfo : ManagerGroupInfoModel?
    
    var members: [PersonModel]?
    
    lazy var tableView : UITableView = {
       let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: kScreen_height), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "normalCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "管理群"
        self.view.addSubview(tableView)
        sendNetRequest()
    }
    
    func sendNetRequest() {
        NetRequest.managerGroupNetRequest(id: self.groupId!, open_id: AppInfo.shared.user?.token) { (success, info, result) in
            if success {
                self.managerGroupInfo = ManagerGroupInfoModel.deserialize(from: result)
                print(self.managerGroupInfo!.current!)
                self.tableView.reloadData()
            }else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeJoinGroupWay(check: String?) {
        NetRequest.changeJoinGroupWayNetRequest(open_id: AppInfo.shared.user?.token, id: self.groupId, check: check) { (success, info, result) in
            if success {
                self.managerGroupInfo?.check = check
                self.tableView.reloadData()
                SVProgressHUD.showSuccess(withStatus: info!)
            }else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
}

extension ManagerGroupViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "normalCell")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.textLabel?.textColor = UIColor.init(hexColor: "333333")
        cell.detailTextLabel?.textColor = UIColor.init(hexColor: "cccccc")
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        if self.managerGroupInfo != nil {
            if indexPath.row == 0 {
                cell.textLabel?.text = "设置管理员"
                cell.detailTextLabel?.text = (self.managerGroupInfo?.current ?? "") + "/" + (self.managerGroupInfo?.people ?? "")
            }else if indexPath.row == 1 {
                cell.textLabel?.text = "设置加群方式"
                if Int((self.managerGroupInfo?.check)!)! == 0 {
                    cell.detailTextLabel?.text = "允许任何人加入该群"
                }else {
                    cell.detailTextLabel?.text = "需管理员验证"
                }
            }else {
                cell.textLabel?.text = "编辑群资料"
                cell.detailTextLabel?.text = ""
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 47
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let settingManagerVC = SettingManagerViewController()
            settingManagerVC.groupId = self.groupId
            
            self.navigationController?.pushViewController(settingManagerVC, animated: true)
        }else if indexPath.row == 1 {
            let sheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction.init(title: "允许任何人加入该群", style: .default, handler: { (action) in
                self.changeJoinGroupWay(check: "0")
            }))
            sheet.addAction(UIAlertAction.init(title: "需管理员验证", style: .default, handler: { (action) in
                self.changeJoinGroupWay(check: "1")
            }))
            sheet.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            self.present(sheet, animated: true, completion: nil)
        }else {
            
        }
    }
}
