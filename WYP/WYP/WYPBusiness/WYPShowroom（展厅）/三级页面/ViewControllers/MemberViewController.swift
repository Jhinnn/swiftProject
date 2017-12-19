//
//  MemberViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/6.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import Alamofire

class MemberViewController: BaseViewController {

    // 数据源
    var actorMemberData: [MemberModel]?
    // 成员Id
    var roomId: String?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        layoutPageSubviews()
        
        // 获取数据
        loadMemberData()
    }
    
    // MARK: - private method
    private func viewConfig() {
        self.title = "项目成员"
        view.addSubview(memberTableView)
        
        actorMemberData = [MemberModel]()
    }
    
    private func layoutPageSubviews() {
        memberTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    func loadMemberData() {

        NetRequest.actorMemberNetRequest(uid: AppInfo.shared.user?.userId ?? "", id: roomId ?? "") { (success, info, result) in
            if success {
                
                let array = result!.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                self.actorMemberData = [MemberModel].deserialize(from: jsonString) as? [MemberModel]
                self.memberTableView.reloadData()
            } else {
                print(info!)
            }
        }
    }
    
    // MARK: - Setter
    lazy var memberTableView: UITableView = {
        let memberTableView = UITableView()
        memberTableView.rowHeight = 105
        memberTableView.delegate = self
        memberTableView.dataSource = self
        //注册
        memberTableView.register(AddAttentionTableViewCell.self, forCellReuseIdentifier: "memberCell")
        
        return memberTableView
    }()
}

extension MemberViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if actorMemberData != nil {
            print(actorMemberData!.count)
            return actorMemberData!.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "memberCell") as! AddAttentionTableViewCell
        cell.memberModel = actorMemberData?[indexPath.row]
        cell.addAttentionButton.tag = indexPath.row + 510
        cell.delegate = self
        return cell
    }

}
extension MemberViewController: AddAttentionTableViewCellDelegate {
    func addAttention(sender: UIButton) {
        if sender.isSelected == false {
            print(actorMemberData?[sender.tag - 510].memberId ?? "")
            NetRequest.addOrCancelAttentionNetRequest(method: "POST", mid: AppInfo.shared.user?.userId ?? "", follow_who: actorMemberData?[sender.tag - 510].memberId ?? "") { (success, info) in
                
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    sender.isSelected = true
                
                    self.loadMemberData()
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
        } else {
            NetRequest.addOrCancelAttentionNetRequest(method: "DELETE", mid: AppInfo.shared.user?.userId ?? "", follow_who: actorMemberData?[sender.tag - 510].memberId ?? "") { (success, info) in
                
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    sender.isSelected = false
                    sender.setImage(UIImage(named: "showRoom_addAttention_button_normal_iPhone"), for: .normal)
                    
                    self.loadMemberData()
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
        }
    }
}
