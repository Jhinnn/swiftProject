//
//  ChatDeatilViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/6/1.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ChatDeatilViewController: RCConversationViewController {

    // 群组人数
    var groupNumber: Int?
    
    // 展厅名称
    var roomName: String?
    // 群组名称
    var groupName: String?
    
    var userData: PersonModel?
    var flag: Int?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // 不是单聊的情况 添加rightBarButtonItem
        if flag == 11 {
            let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "chat_community_button_normal_iPhone"), landscapeImagePhone: nil, style: .done, target: self, action: #selector(checkFriendCoumity(sender:)))
            navigationItem.rightBarButtonItem = rightBarButtonItem
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
            
        } else {
            let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "chat_groups_button_normal_iPhone"), landscapeImagePhone: nil, style: .done, target: self, action: #selector(checkGroupMember(sender:)))
            navigationItem.rightBarButtonItem = rightBarButtonItem
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }
        
        // 设置头像为圆角
        RCIM.shared().globalMessageAvatarStyle = RCUserAvatarStyle.USER_AVATAR_CYCLE
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let push = UserDefaults.standard.object(forKey: "chatpush") as? String
        if push == "chatpush" {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "common_navback_button_normal_iPhone"), style: .done, target: self, action: #selector(rebackToRootViewAction(sender:)))
        }
        
        // 不是单聊的情况，不加载群成员人数
        if flag != 11 {
            loadGroupMember()
        }
        
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared().isEnabled = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // 发送消息时将消息发送到后台
    override func didSendMessage(_ status: Int, content messageContent: RCMessageContent!) {
        
    }
    
    func loadGroupMember() {
        NetRequest.groupInfoNetRequest(uid: AppInfo.shared.user?.userId ?? "", groupId: self.targetId ?? "") { (success, info, result) in
            if success {
                let groupDetail = ApplyGroupModel.deserialize(from: result)
                self.groupNumber = groupDetail?.groupMember?.count
                self.setTitle()
            } else {
                print(info!)
            }
        }
    }
    
    // MARK: - private method
    func setTitle() {
    
        if flag == 10 { // 从展厅详情页面进入
            self.title = String.init(format: "%@(%d)", groupName ?? "", groupNumber ?? 0)
        } else if flag == 11 {
            // 单聊 不设置title
        } else {
            if (roomName?.characters.count)! > 5 {
                let subName = (roomName! as NSString).substring(to: 5)
                self.title = String.init(format: "%@... - %@(%d)", subName, groupName ?? "", groupNumber ?? 0)
            } else {
                self.title = String.init(format: "%@ - %@(%d)", roomName ?? "", groupName ?? "", groupNumber ?? 0)
            }
        }
    }
    
    // MARK: - setter and getter
    // 返回按钮
    lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 8, height: 13.5)
        backButton.setImage(UIImage(named: "common_navback_button_normal_iPhone"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        return backButton
    }()
    
    // MARK: - event response
    //返回
    func rebackToRootViewAction(sender: UIBarButtonItem) {
        let pushJudge = UserDefaults.standard
        pushJudge.set("", forKey: "chatpush")
        let myFriend = MyFriendsViewController()
        self.navigationController?.popToViewController(myFriend, animated: true)
    }
    // 返回按钮点击事件
    func backButtonAction(button: UIButton) {
        if flag == 2 { // 消息 -> 推荐好友入群 -> 同意
            let viewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 4]
            self.navigationController?.popToViewController(viewController!, animated: true)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // 查看群成员
    func checkGroupMember(sender: UIBarButtonItem) {
//        let groupsMember = GroupsMemberListViewController()
//        groupsMember.groupId = self.targetId
//        groupsMember.title = self.title
//        navigationController?.pushViewController(groupsMember, animated: true)
        
       
        
        let groupdetail = GroupDeailsViewController()
        groupdetail.title = self.title
        groupdetail.groupId = self.targetId
       
        
        navigationController?.pushViewController(groupdetail, animated: true)
        
    }
    
    // 查看好友社区
    func checkFriendCoumity(sender: UIBarButtonItem) {
        goToUserCommunity(userId: self.targetId)
    }
    
    func goToUserCommunity(userId: String) {
        // 获取点击用户的信息
        let mineId = AppInfo.shared.user?.userId ?? ""
        NetRequest.gotoUserCommunityNetRequest(uid: userId, openId: AppInfo.shared.user?.token ?? "") { (success, info, result) in
            if success {
                self.userData = PersonModel()
                self.userData = PersonModel.deserialize(from: result)
                
                if self.userData?.userImage != nil && userId != mineId {
                    let community = MyCommunityViewController()
                    community.title = "个人主页"
                    community.userId = userId
                    community.headImageUrl = self.userData?.userImage ?? ""
                    community.nickName = self.userData?.name ?? ""
                    community.fansCount = String.init(format: "粉丝:%@人", self.userData?.peopleFans ?? "0")
                    community.friendsCountLabel.text = String.init(format: "好友:%@人", self.userData?.peopleFriends ?? "0")
                    community.type = "2"
                    // 判断是否关注
                    if self.userData?.isFollow == "0" {
                        community.isFollowed = false
                    } else {
                        community.isFollowed = true
                    }
                    self.navigationController?.pushViewController(community, animated: true)
                }
            } else {
                print(info!)
            }
        }
    }
    
    // 点击某人的头像
    override func didTapCellPortrait(_ userId: String!) {
        //
        goToUserCommunity(userId: userId)
        let mineId = AppInfo.shared.user?.userId ?? ""
        if userId == mineId {
            NetRequest.friendsListNetRequest(openId: AppInfo.shared.user?.token ?? "", page: "") { (success, info, result) in
                if success {
                    let array = result!.value(forKey: "data")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    let friendsArr = [PersonModel].deserialize(from: jsonString) as! [PersonModel]
                    
                    let community = MyCommunityViewController()
                    community.title = "个人主页"
                    community.headImageUrl = AppInfo.shared.user?.headImgUrl ?? ""
                    community.userId = AppInfo.shared.user?.userId ?? ""
                    community.nickName = AppInfo.shared.user?.nickName ?? ""
                    community.fansCount = String.init(format: "粉丝:%@人", AppInfo.shared.user?.fans ?? "0")
                    community.friendsCountLabel.text = String.init(format: "好友:%d人", friendsArr.count)
                    community.type = "2"
                    community.userType = "200"
                    community.isFollowed = false
                    self.navigationController?.pushViewController(community, animated: true)
                    
                } else {
                    print(info!)
                }
            }
        }
    }
}
