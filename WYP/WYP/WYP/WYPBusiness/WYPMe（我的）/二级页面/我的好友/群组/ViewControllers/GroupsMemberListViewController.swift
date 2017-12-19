//
//  GroupsMemberListViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/6/1.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class GroupsMemberListViewController: BaseViewController {

    // 群Id
    var groupId: String?
    // 群资料
    var groupDetail: ApplyGroupModel?
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 设置导航条透明度
        DispatchQueue.main.async {
            self.navBarBgAlpha = 0
            
            
        }
        
        
    }

    
    
    // MARK: - private method
    func viewConfig() {
        
        let rightButton = UIBarButtonItem(title: "推荐", style: .done, target: self, action: #selector(recommendToFriends(sender:)))
        navigationItem.rightBarButtonItem = rightButton
        
     
        view.addSubview(memberCollectionView)
      
       
        
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    func layoutPageSubviews() {
        
       
   
        memberCollectionView.snp.makeConstraints { (make) in
            
            make.top.equalTo(view.snp.top).offset(-64)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
            
        }
       
        
    }
    
    func loadGroupMember() {
        NetRequest.groupInfoNetRequest(uid: AppInfo.shared.user?.userId ?? "", groupId: groupId ?? "") { (success, info, result) in
            if success {
//                print(success)
//                print(info!)
//                print(result!)
                self.groupDetail = ApplyGroupModel.deserialize(from: result)
                self.memberCollectionView.reloadData()
            } else {
                print(info!)
            }
        }
    }
    
    // MARK: - event response
    func recommendToFriends(sender: UIBarButtonItem) {
        let recommend = RecommendFriendsViewController()
        recommend.groupId = self.groupId
        navigationController?.pushViewController(recommend, animated: true)
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
        memberCollectionView.register(GroupsMemberListCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "groupMemberFooter")
        memberCollectionView.register(GroupMemberListHeadCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "groupMemberhead")
        
        
     
        return memberCollectionView
    }()
}

extension GroupsMemberListViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if groupDetail?.groupMember != nil {
            return groupDetail?.groupMember?.count ?? 0
        }
        return 0
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
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "groupMemberFooter", for: indexPath) as! GroupsMemberListCollectionReusableView
            let notification = UserDefaults.standard.value(forKey: "groupNotification") as? String
            if notification == "0" {
                footerView.switchBtn.isOn = false
            } else if notification == "1" {
                footerView.switchBtn.isOn = true
            }
            footerView.groupNoteConten.text = self.groupDetail?.board
            footerView.groupDetalConten.text = self.groupDetail?.groupDetail
            footerView.delegate = self
            return footerView
        }else{
             let headView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "groupMemberhead", for: indexPath) as! GroupMemberListHeadCollectionReusableView
            headView.delegate = self
            let imgURL = URL.init(string: (self.groupDetail?.cover_url ?? "")!)
            headView.headerImgView.sd_setImage(with: imgURL)
            headView.groupNumb.text = "群编号:" + self.groupId!
            return headView
        }
    
        return UICollectionReusableView()
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: kScreen_width, height: 800)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kScreen_width, height: 220)
    }
    
   
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let community = MyCommunityViewController()
//        community.title = "个人主页"
//        community.userId = groupDetail?.groupMember?[indexPath.item].peopleId ?? ""
//        community.headImageUrl = groupDetail?.groupMember?[indexPath.item].userImage ?? ""
//        community.nickName = groupDetail?.groupMember?[indexPath.item].name
//        let fans = groupDetail?.groupMember?[indexPath.item].peopleFans ?? "0"
//        let friends = groupDetail?.groupMember?[indexPath.item].peopleFriends ?? "0"
//        community.fansCount = String.init(format: "粉丝:%@人", fans)
//        community.friendsCountLabel.text = String.init(format: "好友:%@人", friends)
//        community.type = "2"
//        if groupDetail?.groupMember?[indexPath.item].peopleId == AppInfo.shared.user?.userId {
//            community.userType = "200"
//        }
//        // 判断是否关注
//        if groupDetail?.groupMember?[indexPath.item].isFollow == "0" {
//            community.isFollowed = false
//        } else {
//            community.isFollowed = true
//        }
//        navigationController?.pushViewController(community, animated: true)
        
          let personalInformationVC = PersonalInformationViewController()
        personalInformationVC.name = groupDetail?.groupMember?[indexPath.item].name
        personalInformationVC.conversationType = Int(RCConversationType.ConversationType_PRIVATE.rawValue)
        personalInformationVC.targetId = groupDetail?.groupMember?[indexPath.item].peopleId ?? ""
        
         navigationController?.pushViewController(personalInformationVC, animated: true)
     
        
        
        
    }
}

extension GroupsMemberListViewController: GroupsMemberListCollectionDelegate {
    func quiteGroup() {
        NetRequest.quiteGroupNetRequest(openId: AppInfo.shared.user?.token ?? "", groupId: groupId ?? "") { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info!)
                RCIMClient.shared().remove(.ConversationType_GROUP, targetId: self.groupId ?? "")
                let viewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
                self.navigationController?.popToViewController(viewController!, animated: true)
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
    
    func putGroupNote() {
        let groupNoteVc = GroupNoteViewController()
        groupNoteVc.groupId = self.groupId
        self.navigationController?.pushViewController(groupNoteVc, animated: true)
    }
    
    func noDisturbing(sender: UISwitch) {
        if sender.isOn {
            sender.isOn = false
            
            RCIMClient.shared().setConversationNotificationStatus(.ConversationType_GROUP, targetId: groupId, isBlocked: false, success: { (status) in
                print(status)
                // 允许通知
                let userDefault = UserDefaults.standard
                userDefault.set("0", forKey: "groupNotification")
            }) { (error) in
                print(error)
            }
            
        } else {
            sender.isOn = true
            
            RCIMClient.shared().setConversationNotificationStatus(.ConversationType_GROUP, targetId: groupId, isBlocked: true, success: { (status) in
                print(status)
                // 禁止通知
                let userDefault = UserDefaults.standard
                userDefault.set("1", forKey: "groupNotification")
            }) { (error) in
                print(error)
            }
        }
    }
}
