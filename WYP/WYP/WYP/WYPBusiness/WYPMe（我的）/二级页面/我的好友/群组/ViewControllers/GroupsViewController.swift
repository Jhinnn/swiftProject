//
//  GroupsViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class GroupsViewController: BaseViewController {
    
    var dataSource: [GroupsModel]?

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfig()
        layoutPageSubviews()
        loadGroupsData(requestType: .update)
    }
    
    // MARK: - private method
    func viewConfig() {
        view.addSubview(groupTableview)
    }
    
    func layoutPageSubviews() {
        groupTableview.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 64, 0))
        }
    }
    
    func loadGroupsData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.myGroupsListNetRequest(openId: AppInfo.shared.user?.token ?? "", page: "\(pageNumber)") { (success, info, result) in
            if success {
               let array = result!.value(forKey: "data")
               let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
               let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
               
                
                if requestType == .update {
                    self.dataSource = [GroupsModel].deserialize(from: jsonString) as? [GroupsModel]
                } else {
                    let group = [GroupsModel].deserialize(from: jsonString) as? [GroupsModel]
                    self.dataSource = self.dataSource! + group!
                }
               
               // 先移除再添加
               self.noDataImageView.removeFromSuperview()
               self.noDataLabel.removeFromSuperview()
               // 没有数据的时候
               self.view.addSubview(self.noDataImageView)
               self.view.addSubview(self.noDataLabel)
               self.noDataImageView.snp.makeConstraints { (make) in
                   if deviceTypeIphone5() || deviceTypeIPhone4() {
                      make.top.equalTo(self.view).offset(130)
                   }
                   make.top.equalTo(self.view).offset(180)
                   make.centerX.equalTo(self.view)
                   make.size.equalTo(CGSize(width: 100, height: 147))
               }
               self.noDataLabel.snp.makeConstraints { (make) in
                   make.top.equalTo(self.noDataImageView.snp.bottom).offset(10)
                   make.centerX.equalTo(self.view)
                   make.height.equalTo(11)
               }
                
               self.groupTableview.reloadData()
            } else {
                print(info!)
            }
            

        }
    }
    
    // MARK: - setter
    lazy var groupTableview: WYPTableView = {
        let groupTableView = WYPTableView(frame: .zero, style: .plain)
        groupTableView.backgroundColor = UIColor.white
        groupTableView.rowHeight = 60
        groupTableView.delegate = self
        groupTableView.dataSource = self
        groupTableView.tableFooterView = UIView()
        
        groupTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadGroupsData(requestType: .loadMore)
        })
        groupTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadGroupsData(requestType: .update)
        })
        
        //注册
        groupTableView.register(GroupsTableViewCell.self, forCellReuseIdentifier: "groupsCell")
        return  groupTableView
    }()
    
    // 没有数据时的图片
    lazy var noDataImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "common_noData_icon_normal_iPhone")
        return imageView
    }()
    // 没有数据时的提示文字
    lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "暂无群组"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
}

extension GroupsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource?.count == 0 {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
            
        }
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupsCell", for: indexPath) as! GroupsTableViewCell
        cell.groupsModel = dataSource?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let groupsModel = dataSource?[indexPath.row]
        
        let conversationVC = ChatDeatilViewController()
        conversationVC.conversationType = RCConversationType.ConversationType_GROUP
        conversationVC.targetId = groupsModel?.groupId
        conversationVC.roomName = groupsModel?.roomName ?? ""
        conversationVC.groupName = groupsModel?.groupTitleName ?? ""
        navigationController?.pushViewController(conversationVC, animated: true)
    }
}
