//
//  SettingManagerViewController.swift
//  WYP
//
//  Created by aLaDing on 2017/12/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class SettingManagerViewController: UIViewController {
    
    var members : [PersonModel]?
    
    var groupId : String?
    
    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: kScreen_height), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "normalCell")
        tableView.register(SettingManagerTableViewCell.self, forCellReuseIdentifier: "settingManagerCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置管理员"
        self.view.addSubview(tableView)
    }
    

}

extension SettingManagerViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "normalCell")
            cell.textLabel?.text = "设置管理员"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.textLabel?.textColor = UIColor.init(hexColor: "333333")
            cell.detailTextLabel?.textColor = UIColor.init(hexColor: "cccccc")
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingManagerCell", for: indexPath) as! SettingManagerTableViewCell
        cell.members = self.members
        cell.memberInfoBack = { (model) in
            let sheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction.init(title: "设置为管理员", style: .default, handler: { (action) in
                NetRequest.setGroupManagerNetRequest(id: self.groupId, uid: AppInfo.shared.user?.userId, open_id: AppInfo.shared.user?.userId, complete: { (success, info) in
                    if success {
                        SVProgressHUD.showSuccess(withStatus: info!)
                    }else {
                        SVProgressHUD.showError(withStatus: info!)
                    }
                })
            }))
            sheet.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
            self.present(sheet, animated: true, completion: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 47
        }
        return 220
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
}
