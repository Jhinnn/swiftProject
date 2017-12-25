//
//  GroupMemberListViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/11.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class GroupMemberListViewController: BaseViewController {

    // 群组名称
    var groupName: String?
    // 展厅名称
    var roomName: String?
    // 群组人数
    var groupNumber: Int?
    
    // 群Id
    var groupId: String?
    // 群资料
    var groupDetail: ApplyGroupModel?
    
    // 申请入群成功的标志
    var isAdd: Bool = false
    
    // 从消息页面进来 flag = 2
    var flag = 1
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        layoutPageSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadGroupMember()
    }

    // MARK: - private method
    func setTitle() {
        
        if flag == 10 { // 从展厅详情页面进入
            self.title = String.init(format: "%@(%d)", groupName ?? "", groupNumber ?? 0)
        } else {
            if (roomName?.characters.count)! > 5 {
                let subName = (roomName! as NSString).substring(to: 5)
                self.title = String.init(format: "%@... - %@(%d)", subName, groupName ?? "", groupNumber ?? 0)
            } else {
                self.title = String.init(format: "%@ - %@(%d)", roomName ?? "", groupName ?? "", groupNumber ?? 0)
            }
        }
    }
    func viewConfig() {
        
        view.addSubview(memberCollectionView)
        view.addSubview(self.noMemberLabel)
        
        noMemberLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(20)
            make.left.right.equalTo(self.view)
            make.height.equalTo(20)
        })
        
        noMemberLabel.isHidden = true
    }
    
    func layoutPageSubviews() {
        memberCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    func loadGroupMember() {
        NetRequest.groupInfoNetRequest(uid: AppInfo.shared.user?.userId ?? "", groupId: groupId ?? "") { (success, info, result) in
            if success {
                self.groupDetail = ApplyGroupModel.deserialize(from: result)
                self.groupNumber = self.groupDetail?.groupMember?.count ?? 0
                self.setTitle()
                self.memberCollectionView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
    
    // MARK: - setter and getter
    lazy var memberCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kScreen_width / 5 - 10, height: 75)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let memberCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        memberCollectionView.backgroundColor = UIColor.white
        memberCollectionView.delegate = self
        memberCollectionView.dataSource = self
        memberCollectionView.register(GroupMemberCollectionViewCell.self, forCellWithReuseIdentifier: "groupMemberCell")
        memberCollectionView.register(MemberCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "groupMemberFooter")
        return memberCollectionView
    }()
    
    lazy var noMemberLabel: UILabel = {
        let noMemberLabel = UILabel()
        noMemberLabel.textAlignment = .center
        noMemberLabel.font = UIFont.systemFont(ofSize: 18)
        noMemberLabel.textColor = UIColor.init(hexColor: "a1a1a1")
        noMemberLabel.text = "暂无群成员"
        return noMemberLabel
    }()
}

extension GroupMemberListViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if groupDetail?.groupMember?.count == 0 {
            noMemberLabel.isHidden = false
        }
        return groupDetail?.groupMember?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupMemberCell", for: indexPath) as! GroupMemberCollectionViewCell
        cell.groupModel = groupDetail?.groupMember?[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(25, 17, 25, 17)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "groupMemberFooter", for: indexPath) as! MemberCollectionReusableView
            if flag == 2 {
                footerView.agreeButton.isHidden = false
                footerView.ignoreButton.isHidden = false
                footerView.applyToGroupButton.isHidden = true
            } else {
                footerView.agreeButton.isHidden = true
                footerView.ignoreButton.isHidden = true
                footerView.applyToGroupButton.isHidden = false
                footerView.applyToGroupButton.setTitle("申请入群", for: .normal)
            }
            
            footerView.groupIntroduceLabel.text = groupDetail?.groupDetail ?? "暂无介绍"
            footerView.delegate = self
            return footerView
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: kScreen_width, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let community = MyCommunityViewController()
        community.title = "个人主页"
        community.userId = groupDetail?.groupMember?[indexPath.item].peopleId ?? ""
        community.headImageUrl = groupDetail?.groupMember?[indexPath.item].userImage ?? ""
        community.nickName = groupDetail?.groupMember?[indexPath.item].name
        let fans = groupDetail?.groupMember?[indexPath.item].peopleFans ?? "0"
        let friends = groupDetail?.groupMember?[indexPath.item].peopleFriends ?? "0"
        community.fansCount = String.init(format: "粉丝:%@人", fans)
        community.friendsCountLabel.text = String.init(format: "好友:%@人", friends)
        community.type = "2"
        if groupDetail?.groupMember?[indexPath.item].peopleId == AppInfo.shared.user?.userId {
            community.userType = "200"
        }
        // 判断是否关注
        if groupDetail?.groupMember?[indexPath.item].isFollow == "0" {
            community.isFollowed = false
        } else {
            community.isFollowed = true
        }
        navigationController?.pushViewController(community, animated: true)
    }
}

extension GroupMemberListViewController: MemberCollectionReusableViewDelegate {
    func applyToEnterGroup(sender: UIButton) {
        // 未登录时弹框
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        
        if flag == 2 { // 同意的情况
            NetRequest.enterGroupNetRequest(type: "1", openId: token, groupId: groupId ?? "", comment: "", complete: { (success, info) in
                if success {
                    // 已加入
                    let conversationVC = ChatDeatilViewController()
                    conversationVC.conversationType = RCConversationType.ConversationType_GROUP
                    conversationVC.targetId = self.groupId ?? "0"
                    let arr = self.title?.components(separatedBy: " - ")
                    conversationVC.roomName = arr?[0] ?? ""
                    conversationVC.groupName = arr?[1] ?? ""
                    conversationVC.flag = 2
                    self.navigationController?.pushViewController(conversationVC, animated: true)
                    
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            })
        } else {
            
            let verity = VerifyApplicationViewController()
            verity.groupId = groupId
            verity.flag = 2
            navigationController?.pushViewController(verity, animated: true)
        }
        
    }
    
}
