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
    
    // 记录偏移量
    var navOffset: CGFloat = 0
    
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
    func setTitle() {
        
        if flag == 10 { // 从展厅详情页面进入
            self.title = String.init(format: "%@(%d)", groupName ?? "", groupNumber ?? 0)
        } else {
            if (roomName?.count)! > 5 {
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
        layout.itemSize = CGSize(width: kScreen_width / 5 - 10, height: 80)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let memberCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        memberCollectionView.backgroundColor = UIColor.white
        memberCollectionView.delegate = self
        memberCollectionView.dataSource = self
        memberCollectionView.register(GroupMemberCollectionViewCell.self, forCellWithReuseIdentifier: "groupMemberCell")
        memberCollectionView.register(MemberCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "groupMemberFooter")
        memberCollectionView.register(GroupMemberListHeadCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "groupMemberhead")
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
            
            if self.groupDetail?.groupDetail == "" {
                footerView.groupIntroduceLabel.text = "暂无群介绍"
            }else {
                footerView.groupIntroduceLabel.text = groupDetail?.groupDetail
            }
            footerView.delegate = self
            return footerView
        }else {
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
        return CGSize(width: kScreen_width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kScreen_width, height: 287)
    }
    

    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let personalInformationVC = PersonalInformationViewController()
        personalInformationVC.name = groupDetail?.groupMember?[indexPath.item].name
        personalInformationVC.conversationType = Int(RCConversationType.ConversationType_PRIVATE.rawValue)
        personalInformationVC.targetId = groupDetail?.groupMember?[indexPath.item].peopleId ?? ""
        
        navigationController?.pushViewController(personalInformationVC, animated: true)

    }
}
extension GroupMemberListViewController :GroupsMemberListCollectionDelegate {
    func quiteGroup() {
        
    }
    
    func putGroupNote() {
        
    }
    
    func noDisturbing(sender: UISwitch) {
        
    }
    
    func codeImageViewClicked() {
        if self.groupDetail == nil {
            return
        }
        UIApplication.shared.keyWindow?.addSubview(self.codeView)
    }
    
    func chatRecordBtnClicked() {
        
    }
    
    func managerGroupBtnClicked() {
        
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
