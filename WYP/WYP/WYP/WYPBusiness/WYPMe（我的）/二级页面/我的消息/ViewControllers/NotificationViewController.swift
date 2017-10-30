//
//  NotificationViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/3/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController {

    var dataList = [NotificationModel]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的消息"
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadNetData(requestType: .update)
        UIApplication.shared.applicationIconBadgeNumber = 0
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationMessage"), object: nil)
    }

    // MARK: - Private Methods
    // 设置所有控件
    fileprivate func setupUI() {
        view.addSubview(tableView)
        
        setupUIFrame()
    }
    
    // 设置控件frame
    fileprivate func setupUIFrame() {
        // 设置tableView的布局
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    // 设置tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadNetData(requestType: .loadMore)
        })
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadNetData(requestType: .update)
        })
        tableView.rowHeight = 80
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NotificationCellIdentifier")
        
        return tableView
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
        label.text = "暂无消息"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
    
    func loadNetData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.myNotificationListNetRequest(page: "\(pageNumber)", token: AppInfo.shared.user?.token ?? "") { (success, info, dataArr) in
            if success {
                var models = [NotificationModel]()
                for dic in dataArr! {
                    let notification = NotificationModel.deserialize(from: dic)
                    models.append(notification!)
                }
                if requestType == .update {
                    self.dataList = models
                } else {
                    // 把新数据添加进去
                    self.dataList = self.dataList + models
                }
                
                // 先移除再添加
                self.noDataImageView.removeFromSuperview()
                self.noDataLabel.removeFromSuperview()
                // 没有数据的情况
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
                
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
            } else {
                SVProgressHUD.showError(withStatus: info!)
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
            }
        }
    }
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataList.count == 0 {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
        
        }
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = NotificationCell(style: .default, reuseIdentifier: "NotificationCellIdentifier")
        cell.notification = dataList[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let message = dataList[indexPath.row]
        //1.添加好友 2.推荐好友入群 3.抢票活动/兑换票务 4.订单消息 5.通过群组审核 6.通过好友审核 7.被踢出群组
        if message.type == "1" || message.type == "2" {
            let detail = NotificationDetailsViewController()
            detail.isFriend = message.isFriend ?? ""
            detail.isGroup = message.isGroup ?? ""
            detail.flag = Int(message.type!)!
            detail.friendId = message.friendId ?? ""
            detail.headerImage = message.headerImage ?? ""
            detail.nickname = message.nickname ?? ""
            detail.roomName = message.roomName ?? ""
            navigationController?.pushViewController(detail, animated: true) 
        }
        if dataList[indexPath.row].type == "5" {
            if message.isGroup == "1" {
                let conversationVC = ChatDeatilViewController()
                conversationVC.conversationType = RCConversationType.ConversationType_GROUP
                conversationVC.targetId = message.friendId ?? ""
                conversationVC.roomName = message.roomName ?? ""
                conversationVC.groupName = message.nickname ?? ""
                navigationController?.pushViewController(conversationVC, animated: true)

            } else {
                // 未加入
                let group = GroupMemberListViewController()
                group.groupId = message.friendId ?? ""
                group.roomName = message.roomName ?? ""
                group.groupName = message.nickname ?? ""
                navigationController?.pushViewController(group, animated: false)
            }
        }
    }
    
    // 设置侧滑删除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    // 修改删除按钮的文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    // 删除cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            //1.从本地数据库将数据移除
            NetRequest.deleteNotificationNetRequest(openId: AppInfo.shared.user?.token ?? "", id: dataList[indexPath.row].id ?? "", complete: { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    
                    self.dataList.remove(at: indexPath.row)
                    tableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            })
        }
    }

}


