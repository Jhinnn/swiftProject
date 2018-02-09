//
//  ChatViewController.swift
//  WYP
//
//  Created by ShuYan    on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
class ChatViewController: RCConversationListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        
        if conversationListTableView.visibleCells.count == 0 {
            conversationListTableView.separatorStyle = .none
        }
        // 设置头像为圆角
        RCIM.shared().globalConversationAvatarStyle = RCUserAvatarStyle.USER_AVATAR_CYCLE
        //设置需要显示哪些类型的会话
        self.setDisplayConversationTypes([RCConversationType.ConversationType_PRIVATE.rawValue, RCConversationType.ConversationType_DISCUSSION.rawValue, RCConversationType.ConversationType_CHATROOM.rawValue, RCConversationType.ConversationType_GROUP.rawValue, RCConversationType.ConversationType_APPSERVICE.rawValue, RCConversationType.ConversationType_SYSTEM.rawValue])
        //设置需要将哪些类型的会话在会话列表中聚合显示
        self.setCollectionConversationType([RCConversationType.ConversationType_DISCUSSION.rawValue])
        
        
        conversationListTableView.snp.remakeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 108, 0))
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshConversationTableViewIfNeeded()
    }
    
    //重写RCConversationListViewController的onSelectedTableRow事件
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        let conversationVC = ChatDeatilViewController(conversationType: model.conversationType, targetId: model.targetId)
        if model.conversationType == .ConversationType_GROUP {
            if model.conversationTitle != nil {
                let arr = model.conversationTitle.components(separatedBy: " - ")
                conversationVC?.roomName = arr[0]
                conversationVC?.groupName = arr[1]
                navigationController?.pushViewController(conversationVC!, animated: true)
            } else {
                let alert = UIAlertController(title: "温馨提示", message: "该群组已不存在，请手动从列表删除", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "确定", style: .default, handler: nil)
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
            }
        } else if model.conversationType == .ConversationType_PRIVATE {
            conversationVC?.title = model.conversationTitle
            conversationVC?.flag = 11
            navigationController?.pushViewController(conversationVC!, animated: true)
        }
        
    }
    
    // MARK: - private method
    func viewConfig() {
        emptyConversationView = UIView()
        // 列表为空时添加
        if conversationListTableView.numberOfRows(inSection: 0) == 0 {
            emptyConversationView.addSubview(noDataImageView)
            emptyConversationView.addSubview(noDataLabel)
            
            noDataImageView.snp.makeConstraints { (make) in
                if deviceTypeIphone5() || deviceTypeIPhone4() {
                    make.top.equalTo(self.view).offset(130)
                }
                make.top.equalTo(self.view).offset(180)
                make.centerX.equalTo(self.view)
                make.size.equalTo(CGSize(width: 100, height: 147))
            }
            noDataLabel.snp.makeConstraints { (make) in
                make.top.equalTo(noDataImageView.snp.bottom).offset(10)
                make.centerX.equalTo(self.view)
                make.height.equalTo(11)
            }
        }
        
    }
    
    // MARK: - setter and getter
    // 没有数据时的图片
    lazy var noDataImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "common_noData_icon_normal_iPhone")
        return imageView
    }()
    // 没有数据时的提示文字
    lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "暂无聊天"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
    
}
