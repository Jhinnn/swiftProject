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
    
    //阿拉丁ID
    var aldrid: String?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        layoutPageSubviews()
        
        
    }
    // 记录偏移量
    var navOffset: CGFloat = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadGroupMember()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 设置导航条透明度
        DispatchQueue.main.async {
            self.navBarBgAlpha = self.navOffset
            if self.navOffset == 0 {
                self.navigationController?.navigationBar.subviews.first?.alpha = 0
            }
        }
    }
    // MARK: - scrollView代理方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.navOffset = scrollView.contentOffset.y / 200
        self.navBarBgAlpha = self.navOffset
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    // MARK: - private method
    func viewConfig() {
        
        let rightButton = UIBarButtonItem.init(image: UIImage.init(named: "common_share_button_highlight_iPhone"), style: .done, target: self, action: #selector(recommendToFriends(sender:)))
        navigationItem.rightBarButtonItem = rightButton
        
        view.addSubview(memberCollectionView)
        
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    func layoutPageSubviews() {
        memberCollectionView.snp.makeConstraints { (make) in
            if kScreen_height == 812 {
                make.top.equalTo(view.snp.top).offset(-88)
            }else{
                make.top.equalTo(view.snp.top).offset(-64)
            }
           
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    func loadGroupMember() {
        NetRequest.groupInfoNetRequest(uid: AppInfo.shared.user?.userId ?? "", groupId: groupId ?? "") { (success, info, result) in
            if success {
                self.groupDetail = ApplyGroupModel.deserialize(from: result)
                self.memberCollectionView.reloadData()
                
                
            } else {
                print(info!)
            }
        }
    }
    
    // MARK: - event response
    func recommendToFriends(sender: UIBarButtonItem) {
        shareBarButtonItemAction()
    }
    
    // 分享
    func shareBarButtonItemAction() {
        
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        
        let messageObject = UMSocialMessageObject()
        // 分享链接
        let urlString = kApi_baseUrl(path: "mob/Fenxiang/index.html?id=") + self.groupId!
//        let url = String.init(format: urlString + "&uid=" + (AppInfo.shared.user?.userId)! + "&name=" + self.title!)
//        let shareLink = URL.init(string: urlString)
        // 设置文本
        //        messageObject.text = newsTitle! + shareLink
        // 分享对象
        let shareObject: UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: self.title ?? "", descr: "快加入我们的讨论吧！", thumImage: nil)
        // 网址
        shareObject.webpageUrl = urlString
        messageObject.shareObject = shareObject
        
        // 传相关参数
        ShareManager.shared.loadShareAdv()
        ShareManager.shared.complaintId = self.groupId ?? ""
        ShareManager.shared.type = "1"
        
        ShareManager.shared.messageObject = messageObject
        ShareManager.shared.viewController = self
        ShareManager.shared.show()
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
    
    lazy var codeView: UIView = {
       let blackView = UIView.init(frame: UIScreen.main.bounds)
        blackView.backgroundColor = UIColor.init(white: 0, alpha: 0.1)
        blackView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapCodeImageView(sender:))))
        let whiteView = UIView()
        whiteView.backgroundColor = UIColor.white
        whiteView.layer.cornerRadius = 27
        whiteView.layer.masksToBounds = true
        blackView.addSubview(whiteView)
        whiteView.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize.init(width: 297, height: 322))
            make.center.equalTo(blackView.snp.center)
        })
        let headimageView = UIImageView()
        headimageView.layer.cornerRadius = 23.5
        headimageView.layer.masksToBounds = true
        headimageView.sd_setImage(with: URL.init(string: (self.groupDetail?.group_avatar)!))
        whiteView.addSubview(headimageView)
        headimageView.snp.makeConstraints({ (make) in
            make.top.equalTo(19)
            make.left.equalTo(24)
            make.size.equalTo(47)
        })
        let groupName = UILabel()
        groupName.text = self.title
        groupName.font = UIFont.systemFont(ofSize: 15)
        groupName.textColor = UIColor.init(hexColor: "333333")
        groupName.lineBreakMode = .byTruncatingMiddle
        whiteView.addSubview(groupName)
        groupName.snp.makeConstraints({ (make) in
            make.left.equalTo(headimageView.snp.right).offset(16)
            make.top.equalTo(27)
            make.right.equalTo(24)
        })
        let groupNum = UILabel()
        groupNum.text = self.groupId
        groupNum.textColor = UIColor.init(hexColor: "333333")
        groupNum.alpha = 0.7
        groupNum.font = UIFont.systemFont(ofSize: 12)
        whiteView.addSubview(groupNum)
        groupNum.snp.makeConstraints({ (make) in
            make.left.equalTo(groupName)
            make.top.equalTo(groupName.snp.bottom).offset(13)
        })
        let codeImageView = UIImageView()
        codeImageView.backgroundColor = UIColor.clear
        codeImageView.image = SGQRCodeGenerateManager.generate(withDefaultQRCodeData: "group," + (self.groupDetail?.aldrid)!, imageViewWidth: CGFloat(196))
        whiteView.addSubview(codeImageView)
        codeImageView.snp.makeConstraints({ (make) in
            make.size.equalTo(196)
            make.centerX.equalTo(whiteView.snp.centerX)
            make.top.equalTo(groupNum.snp.bottom).offset(15)
        })
        let label = UILabel()
        label.text = "扫码加群"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.init(hexColor: "999999")
        whiteView.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.centerX.equalTo(whiteView.snp.centerX)
            make.top.equalTo(codeImageView.snp.bottom).offset(10)
        })
        return blackView
    }()
    
    func tapCodeImageView(sender : UITapGestureRecognizer) {
        self.codeView.removeFromSuperview()
    }
}

extension GroupsMemberListViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if groupDetail?.groupMember != nil {
            if Int((self.groupDetail?.rank)!) != 1 {
                return ((groupDetail?.groupMember?.count)! + 2)
            }
            return groupDetail?.groupMember?.count ?? 0
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupMemberCell", for: indexPath) as! GroupMemberCollectionViewCell
        if Int((self.groupDetail?.rank)!) != 1 {  // 0未进入 1 群组成员 2.群主  3、管理员
            if indexPath.row == (groupDetail?.groupMember?.count)! {
                cell.memberImageView.image = UIImage.init(named: "cluster_icon_invite_normal")
                cell.memberImageView.backgroundColor = UIColor.white
                cell.memberNameLabel.text = "邀请好友"
            }else if indexPath.row == (groupDetail?.groupMember?.count)! + 1 {
                cell.memberImageView.image = UIImage.init(named: "cluster_icon_delete_normalmore")
                cell.memberImageView.backgroundColor = UIColor.white
                cell.memberNameLabel.text = "删除好友"
            }else {
                cell.groupModel = groupDetail?.groupMember?[indexPath.row]
            }
        }else {
            cell.groupModel = groupDetail?.groupMember?[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(25, 17, 25, 17)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "groupMemberFooter", for: indexPath) as! GroupsMemberListCollectionReusableView
//            let notification = UserDefaults.standard.value(forKey: "groupNotification") as? String
//            if notification == "0" {
//                footerView.switchBtn.isOn = false
//            } else if notification == "1" {
//                footerView.switchBtn.isOn = true
//            }
            footerView.groupNoteConten.text = self.groupDetail?.board
            footerView.groupDetalConten.text = self.groupDetail?.groupDetail
            footerView.delegate = self
            return footerView
        }else{
            let headView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "groupMemberhead", for: indexPath) as! GroupMemberListHeadCollectionReusableView
            headView.delegate = self
            let imgURL = URL.init(string: (self.groupDetail?.group_avatar ?? "")!)
            headView.headerImgView.sd_setImage(with: imgURL)
            headView.groupNumb.text = "群编号:" + (self.groupDetail?.aldrid ?? "")
            headView.memberNumLabel.text = "群成员 " + "(\(self.groupDetail?.groupMember?.count ?? 0)人)"
            return headView
        }
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: kScreen_width, height: 480)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kScreen_width, height: 287)
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
        if Int((self.groupDetail?.rank)!) != 1 {
            if indexPath.row == (groupDetail?.groupMember?.count)! {
                let recommend = RecommendFriendsViewController()
                recommend.groupId = self.groupId
                navigationController?.pushViewController(recommend, animated: true)
            }else if indexPath.row == (groupDetail?.groupMember?.count)! + 1 {
                let deleteGroupMemberVC = DeleteGroupMemberViewController()
                deleteGroupMemberVC.members = self.groupDetail?.groupMember
                deleteGroupMemberVC.groupId = self.groupId;
                self.navigationController?.pushViewController(deleteGroupMemberVC, animated: true)
            }else {
                let personalInformationVC = PersonalInformationViewController()
                personalInformationVC.name = groupDetail?.groupMember?[indexPath.item].name
                personalInformationVC.conversationType = Int(RCConversationType.ConversationType_PRIVATE.rawValue)
                personalInformationVC.targetId = groupDetail?.groupMember?[indexPath.item].peopleId ?? ""
                
                navigationController?.pushViewController(personalInformationVC, animated: true)
            }
            
            
        }else {
            let personalInformationVC = PersonalInformationViewController()
            personalInformationVC.name = groupDetail?.groupMember?[indexPath.item].name
            personalInformationVC.conversationType = Int(RCConversationType.ConversationType_PRIVATE.rawValue)
            personalInformationVC.targetId = groupDetail?.groupMember?[indexPath.item].peopleId ?? ""
            
            navigationController?.pushViewController(personalInformationVC, animated: true)
        }
    }
}
extension GroupsMemberListViewController: GroupsMemberListCollectionDelegate {
    func managerGroupBtnClicked() {
        if Int((self.groupDetail?.rank)!) != 1 {
            let managerGroupVC = ManagerGroupViewController()
            managerGroupVC.groupId = self.groupId
            managerGroupVC.members = self.groupDetail?.groupMember
            self.navigationController?.pushViewController(managerGroupVC, animated: true)
        }else {
            SVProgressHUD.showError(withStatus: "您没有该权限")
        }
    }
    
    func chatRecordBtnClicked() {
        let chatRecordVC = ChatRecordViewController()
        chatRecordVC.groupId = self.groupId
        self.navigationController?.pushViewController(chatRecordVC, animated: true)
    }
    
    func codeImageViewClicked() {
        if self.groupDetail == nil {
            return
        }
        UIApplication.shared.keyWindow?.addSubview(self.codeView)
    }
    
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
        groupNoteVc.rank = self.groupDetail?.rank
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
