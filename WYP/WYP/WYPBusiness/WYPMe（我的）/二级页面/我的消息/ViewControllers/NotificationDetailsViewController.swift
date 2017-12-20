//
//  NotificationDetailsViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/4/7.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class NotificationDetailsViewController: BaseViewController {

    // 添加好友请求的昵称 | 群组名称
    var nickname: String?
    // 展厅名称
    var roomName: String?
    
    // 添加好友请求的头像
    var headerImage: String?
    
    // 添加好友请求的id
    var friendId: String?
    // 是否是好友
    var isFriend: String?
    
    // 是否进群
    var isGroup: String?
    
    // 区分是群组邀请还是好友邀请
    var flag = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
    }
    
    // MARK: - private method
    func viewConfig() {
        view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    // MARK: - setter and getter
    lazy var resultTableView: UITableView = {
        let resultTableView = UITableView()
        resultTableView.rowHeight = 60
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.tableFooterView = UIView()
        
        resultTableView.register(AddFriendsTableViewCell.self, forCellReuseIdentifier: "searchCell")
        return resultTableView
    }()
}

extension NotificationDetailsViewController: UITableViewDelegate, UITableViewDataSource, AddFriendsTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! AddFriendsTableViewCell
        let imageUrl = URL(string: headerImage ?? "")
        cell.friendsImageView.kf.setImage(with: imageUrl)
        if flag == 1 {
            cell.friendsTitleLabel.text = nickname ?? ""
        } else if flag == 2 {
            cell.friendsTitleLabel.text = String.init(format: "%@ - %@", roomName ?? "", nickname ?? "")
        }
        
        cell.addAttentionButton.setImage(UIImage(named: "mine_allow_button_normal_iPhone"), for: .normal)
        cell.addAttentionButton.setImage(UIImage(named: "mine_allow_button_selected_iPhone"), for: .selected)
        if isFriend == "1" || isGroup == "1" {
            cell.addAttentionButton.isHidden = true
        } else {
            cell.addAttentionButton.isHidden = false
        }
        cell.addAttentionButton.tag = 160 + indexPath.row
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if flag == 2 && isGroup == "1" {
            let conversationVC = ChatDeatilViewController()
            conversationVC.conversationType = RCConversationType.ConversationType_GROUP
            conversationVC.targetId = friendId
            conversationVC.roomName = roomName ?? ""
            conversationVC.groupName = nickname ?? ""
            navigationController?.pushViewController(conversationVC, animated: true)
        }
    }
    
    func applyAddFriends(sender: UIButton) {
        if flag == 1 {
            // 添加关注，互相关注即为好友
            NetRequest.addOrCancelAttentionNetRequest(method: "POST", mid: AppInfo.shared.user?.userId ?? "", follow_who: friendId ?? "") { (success, info) in
                
                if success {
                    self.applyPush()
                    SVProgressHUD.showSuccess(withStatus: info)
                    sender.isSelected = true
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
        }
        if flag == 2 {  // 推荐进入群组
            let groupMember = GroupMemberListViewController()
            groupMember.flag = 2
            groupMember.groupId = friendId ?? ""
            groupMember.roomName = roomName ?? ""
            groupMember.groupName = nickname ?? ""
            navigationController?.pushViewController(groupMember, animated: true)
        }
    }
    
    func applyPush() {
        let content = String.init(format: "%@已通过你的好友请求", AppInfo.shared.user?.nickName ?? "")
        NetRequest.notificationPush(uid: friendId ?? "", content: content) { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info!)
            }
        }
    }
}
