//
//  Module1ViewController.swift
//  Mould
//
//  Created by 你个LB on 2017/5/2.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class MyCommunityViewController: BaseViewController {
    
    
    var userId: String!
    var nickName: String!
    var friendsCount: String!
    var addFriendsPhoneNumber: String!
    

    var headImageUrl: String? {
        willSet {
            let url = URL(string: newValue ?? "")
            headerImgView.kf.setImage(with: url, placeholder: UIImage(named: "mine_header_icon_normal_iPhone"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    var fansCount: String! {
        willSet {
            if AppInfo.shared.user?.userId ?? "" == newValue {
                followBtn.isHidden = true
            }
        }
    }
    var isFollowed: Bool! {
        willSet {
            if newValue {
                followBtn.setTitle("已关注", for: .normal)
                followBtn.isSelected = true
            } else {
                followBtn.setTitle("关注", for: .normal)
                followBtn.isSelected = false
            }
        }
    }
    
    // 记录偏移量
    var navOffset: CGFloat = 0
    // 区分朋友圈和个人主页 1：朋友圈 2：个人主页
    var type: String! = "2"
    // 用于权限设置
    var userType: String! = ""
    
    var currentStatement: StatementModel!
    fileprivate var dataId = ""
    var dataList = [StatementFrameModel]()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBarBgAlpha = 0
        
        navigationController?.navigationBar.isTranslucent = false
        
        if userId == AppInfo.shared.user?.userId ?? "" {
            
            // 是自己的朋友圈
            let releaseBtn = UIBarButtonItem(title: "发布", style: .done, target: self, action: #selector(releaseDynamic))
            navigationItem.rightBarButtonItem = releaseBtn
            followBtn.isHidden = true
        } else {
            // 不是自己的朋友圈
            followBtn.isHidden = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        loadNetData(requestType: .update)
        
        loadPersonData()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared().isEnabled = false
        
        // 是否发布
        let userDefault = UserDefaults.standard
        if userDefault.bool(forKey: "isPublic") {
            loadNetData(requestType: .update)
        }
        
        // 置为false
        userDefault.set(false, forKey: "isPublic")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 设置导航条透明度
        DispatchQueue.main.async {
            self.navBarBgAlpha = 0
            self.navigationController?.navigationBar.subviews.first?.alpha = 0
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navBarBgAlpha = 1
        IQKeyboardManager.shared().isEnabled = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setupUI() {
        view.addSubview(tableView)
    
        
        tableView.tableHeaderView = tableViewHeaderView
        tableViewHeaderView.addSubview(headerImgView)
        tableViewHeaderView.addSubview(nickNameLabel)
        tableViewHeaderView.addSubview(friendsCountLabel)
        tableViewHeaderView.addSubview(fansCountLabel)
//        tableView.addSubview(followBtn)
        tableViewHeaderView.addSubview(followBtn)
//        view.addSubview(commentInputView)
        
//        //添加 查找聊天记录View
        view.addSubview(findChatHistory)
//        //添加 消息免打扰View
        view.addSubview(essageDoNotDisturb)
//        //添加 发送消息按钮
        view.addSubview(sendMessageButton)
        setupUIFrame()
    }
    
    func setupUIFrame() {
//        tableView.snp.makeConstraints { (make) in
//            make.edges.equalTo(UIEdgeInsetsMake(-64, 0, 0, 0))
//        }
        sendMessageButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-33)
            make.left.equalTo(view.snp.left).offset(42)
            make.right.equalTo(view.snp.right).offset(-42)
            make.height.equalTo(44)
        }

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(-64)
            make.left.right.equalTo(view)
            make.height.equalTo(kScreen_height)
        }
        
        headerImgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(tableViewHeaderView).offset(-20)
            make.left.equalTo(tableViewHeaderView).offset(20)
            make.size.equalTo(75)
        }
        
        nickNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headerImgView.snp.right).offset(20)
            make.top.equalTo(headerImgView).offset(10)
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
        
        friendsCountLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(headerImgView)
            make.left.equalTo(nickNameLabel)
            make.height.equalTo(35)
        }
        
        fansCountLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(headerImgView)
            make.left.equalTo(friendsCountLabel.snp.right).offset(10)
            make.height.equalTo(35)
        }
        
        followBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(fansCountLabel)
            make.left.equalTo(fansCountLabel.snp.right).offset(15)
            make.size.equalTo(CGSize(width: 60, height: 30))
        }
        /* 原来代码
        commentInputView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(0)
        }
        */
        /* 原来代码
        findChatHistory.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.left.right.equalTo(view)
        }
        essageDoNotDisturb.snp.makeConstraints { (make) in
            make.top.equalTo(findChatHistory.snp.bottom)
            make.left.right.equalTo(view)
        }
        */
        
        

        
    }
    
    //发送消息按钮
    lazy var sendMessageButton: UIButton = {
        let sendMessageButton:UIButton = UIButton()
        sendMessageButton.addTarget(self, action: #selector(clickAddFriendsButton), for: UIControlEvents.touchUpInside)
        sendMessageButton.layer.cornerRadius = 5
        sendMessageButton.setTitle("添加朋友", for: .normal)
        sendMessageButton.backgroundColor = UIColor(red: 221/250, green: 78/250, blue: 60/250, alpha: 1)
        return sendMessageButton
    }()
    //消息免打扰View
    lazy var essageDoNotDisturb: UIView = {
        let essageDoNotDisturb:UIView = UIView()
        essageDoNotDisturb.backgroundColor = UIColor.yellow
        return essageDoNotDisturb
    }()
    //查找聊天记录
    lazy var findChatHistory: UIView = {
        let findChatHistory = UIView()
        findChatHistory.backgroundColor = UIColor.red
        return findChatHistory
    }()
    
    // 表视图
    lazy var tableView: WYPTableView = {
        let tableView = WYPTableView(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadNetData(requestType: .loadMore)
        })
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadNetData(requestType: .update)
        })
        
        tableView.tableFooterView = UIView()
        tableView.register(StatementCell.self, forCellReuseIdentifier: "StatementCellIdentifier")
        
        tableView.backgroundColor = UIColor.white
        
        return tableView
    }()
    
    // 表视图的头视图
    lazy var tableViewHeaderView: UIImageView = {
        let tableViewHeaderView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 180))
        tableViewHeaderView.backgroundColor = UIColor.yellow
        tableViewHeaderView.image = UIImage(named: "grzy_porfile_bg")
        tableViewHeaderView.isUserInteractionEnabled = true
        return tableViewHeaderView
    }()
    
    // 头像
    lazy var headerImgView: UIImageView = {
        let headerImgView = UIImageView()
        headerImgView.layer.cornerRadius = 37.5
        headerImgView.layer.masksToBounds = true
        headerImgView.backgroundColor = UIColor.init(hexColor: "a1a1a1")
        
        return headerImgView
    }()
    
    // 昵称
    lazy var nickNameLabel: UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.textColor = UIColor.white
        nickNameLabel.font = UIFont.systemFont(ofSize: 15)
        nickNameLabel.text = self.nickName
        
        return nickNameLabel
    }()
    
    // 好友
    lazy var friendsCountLabel: UILabel = {
        let friendsCountLabel = UILabel()
        friendsCountLabel.textColor = UIColor.white
        friendsCountLabel.numberOfLines = 2
        friendsCountLabel.font = UIFont.systemFont(ofSize: 11)
        friendsCountLabel.text = self.friendsCount
        
        return friendsCountLabel
    }()
    
    // 粉丝
    lazy var fansCountLabel: UILabel = {
        let fansCountLabel = UILabel()
        fansCountLabel.textColor = UIColor.white
        fansCountLabel.numberOfLines = 2
        fansCountLabel.font = UIFont.systemFont(ofSize: 11)
        fansCountLabel.text = self.fansCount
        
        return fansCountLabel
    }()
    
    // 关注
    lazy var followBtn: UIButton = {
        let followBtn = UIButton(type: .custom)
        followBtn.addTarget(self, action: #selector(founcDynamic(sender:)), for: .touchUpInside)
        followBtn.setTitleColor(UIColor.white, for: .normal)
        followBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        followBtn.layer.cornerRadius = 3
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor.white.cgColor
        return followBtn
    }()
    
    // 评论文本输入框
    lazy var commentInputView: CMInputView = {
        let commentInputView = CMInputView()
        commentInputView.delegate = self
        commentInputView.placeholderColor = UIColor.gray
        commentInputView.placeholderFont = UIFont.systemFont(ofSize: 14)
        commentInputView.isHidden = true
        commentInputView.returnKeyType = .send
        commentInputView.font = UIFont.systemFont(ofSize: 14)
        commentInputView.backgroundColor = UIColor.white
        
        return commentInputView
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        
        return bgView
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
        label.text = "暂无动态"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
    // 没有数据时跳转到抽奖模块
    lazy var noDataButton: UIButton = {
        let noDataButton = UIButton()
        noDataButton.setTitle("马上秀一下", for: .normal)
        noDataButton.setTitleColor(UIColor.themeColor, for: .normal)
        noDataButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        noDataButton.layer.masksToBounds = true
        noDataButton.layer.cornerRadius = 5.0
        noDataButton.layer.borderWidth = 1
        noDataButton.layer.borderColor = UIColor.themeColor.cgColor
        noDataButton.addTarget(self, action: #selector(releaseDynamic), for: .touchUpInside)
        return noDataButton
    }()
    
  
    
    func keyboardWillShow(note: NSNotification) {
        let userInfo = note.userInfo!
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {
            //键盘的偏移量
            self.commentInputView.isHidden = false
            self.commentInputView.transform = CGAffineTransform(translationX: 0 , y: -deltaY)
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else{
            animations()
        }
    }
    
    
    func keyboardWillHidden(note: NSNotification) {
        
        commentInputView.isHidden = true
    }
    
    //加载个人信息
    func loadPersonData() {
        
        NetRequest.getPersonCommunityNetRequest(uid: userId, mid: AppInfo.shared.user?.userId ?? "") { (success, info, dic) in
            self.fansCountLabel.text = String.init(format: "粉丝:%@人", (dic?["fans_num"] as? String)!)
            self.friendsCountLabel.text = String.init(format: "好友:%@人", (dic?["friend_num"] as? String)!)
            
            
            self.addFriendsPhoneNumber = (dic?["mobile"] as? String)!
            
            if (dic?["is_follow"] as? String)! == "0" {
                
                self.followBtn.setTitle("关注", for: .normal)
                self.followBtn.isSelected = false
            }else {
                self.followBtn.setTitle("已关注", for: .normal)
                self.followBtn.isSelected = true
            }
            
        }
    }
    
    // 添加取消关注
    func founcDynamic(sender: UIButton) {
        
        if sender.isSelected == false {
            NetRequest.addOrCancelAttentionNetRequest(method: "POST", mid: AppInfo.shared.user?.userId ?? "", follow_who: userId) { (success, info) in
                
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    self.isFollowed = true
                    self .loadPersonData()
                    self.tableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
        } else {
            NetRequest.addOrCancelAttentionNetRequest(method: "DELETE", mid: AppInfo.shared.user?.userId ?? "", follow_who: userId) { (success, info) in
                
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    self.isFollowed = false
                    self.loadPersonData()
                    self.tableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
        }
    }
    
    func loadNetData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        print(userId)
        let parameters: Parameters = ["access_token": "4170fa02947baeed645293310f478bb4",
                                      "method": "POST",
                                      "type": type,
                                      "uid": userId,
                                      "is_login_uid": AppInfo.shared.user?.userId ?? "",
                                      "page": "\(pageNumber)",
            "usertype": userType]
        let url = kApi_baseUrl(path: "api/Community")
        print(parameters)
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                print(json)
                // 获取code码
                let code = json["code"].intValue
                if code == 400 {
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                } else {
                    // 获取数据
                    let arr = json.dictionary?["data"]?.rawValue as! [NSDictionary]
                    
                    var models = [StatementFrameModel]()
                    for optDic in arr {
                        let statement = StatementModel(contentDic: optDic as! [AnyHashable : Any])
                        let statementFrame = StatementFrameModel()
                        
                        statementFrame.statement = statement
                        models.append(statementFrame)
                        self.dataList.append(statementFrame)
                    }
                    
                    if requestType == .update {
                        self.dataList = models
                    } else {
                        // 把新数据添加进去
                        self.dataList = self.dataList + models
                    }
                    print(self.dataList.count)
                    // 没有数据时
                    self.view.addSubview(self.noDataImageView)
                    self.view.addSubview(self.noDataLabel)
                    // 当进入自己的社区时
                    if self.userId == AppInfo.shared.user?.userId {
                        self.sendMessageButton.isHidden = true
                        self.view.addSubview(self.noDataButton)
                        self.noDataButton.snp.makeConstraints({ (make) in
                            make.centerX.equalTo(self.view)
                            make.top.equalTo(self.noDataLabel.snp.bottom).offset(10)
                            make.size.equalTo(CGSize(width: 100, height: 20))
                        })
                    }
                    self.noDataImageView.snp.makeConstraints { (make) in
                        if deviceTypeIphone5() || deviceTypeIPhone4() {
                            make.top.equalTo(self.view).offset(130)
                        }
                        make.top.equalTo(self.view).offset(180)
                        make.centerX.equalTo(self.view)
                        make.size.equalTo(CGSize(width: 100, height: 147))
                    }
                    self.noDataLabel.snp.makeConstraints { (make) in
                        make.centerX.equalTo(self.view)
                        make.top.equalTo(self.noDataImageView.snp.bottom).offset(10)
                        make.height.equalTo(11)
                    }
                    
                    
                    self.tableView.reloadData()
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func releaseDynamic() {
        UserDefaults.standard.set(AppInfo.shared.user?.token ?? "", forKey: "token")
        let releaseVC = PublicCommunViewController()
        releaseVC.userToken = AppInfo.shared.user?.token ?? ""
        releaseVC.uid = AppInfo.shared.user?.userId ?? ""
        navigationController?.pushViewController(releaseVC, animated: true)
    }
    
    //点击添加好友按钮
    func clickAddFriendsButton(){
        
        let vc = VerifyApplicationViewController()
        vc.applyMobile = self.addFriendsPhoneNumber
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension MyCommunityViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataList.count == 0 {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
            noDataButton.isHidden = false
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
            noDataButton.isHidden = true
        }
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StatementCell(style: .default, reuseIdentifier: "StatementCellIdentifier")
        cell.statementFrame = dataList[indexPath.row]
        cell.selectionStyle = .none;
        cell.delegate = self
        if userId != AppInfo.shared.user?.userId {
            cell.deleteButton.isHidden = true
        }
        cell.selectImgBlock = {(index, imageUrlArray) in
            let albumVC = AlbumViewController()
            albumVC.dataList = imageUrlArray
            albumVC.selectedIndex = index
            self.navigationController?.pushViewController(albumVC, animated: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let statementFrame = dataList[indexPath.row]
        return statementFrame.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.navOffset = scrollView.contentOffset.y / (tableView.tableHeaderView?.frame.size.height)!
        self.navBarBgAlpha = self.navOffset
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension MyCommunityViewController: StatementCellDelegate {
    // 点赞按钮点击事件
    func statementCell(_ statementCell: StatementCell!, starButtonAction button: UIButton!, statement: StatementModel!) {
        
        currentStatement = statement
        let parameters: Parameters = ["access_token": "4170fa02947baeed645293310f478bb4",
                                      "method": "POST",
                                      "dynamic_id": statement._id,
                                      "uid": AppInfo.shared.user?.userId ?? ""]
        let url = kApi_baseUrl(path: "api/community_fabulous")
        buttonActionRequestNetData(URLString: url, parameters: parameters)
    }
    
    func statementCell(_ statementCell: StatementCell!, deleteButtonAction button: UIButton!, statement: StatementModel!) {
        if userId == AppInfo.shared.user?.userId {
            let alertController = UIAlertController(title: "", message: "您确定要删除吗", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "删除", style: .destructive) { (alert) in
                //1.从数据库将数据移除
                NetRequest.deleteCommunityNetRequest(openId: AppInfo.shared.user?.token ?? "", cid: statement._id, complete: { (success, info) in
                    if success {
                        
                        // 刷新单元格
                        self.loadNetData(requestType: .update)
                        self.tableView.reloadData()
                        SVProgressHUD.showSuccess(withStatus: info!)
                    } else {
                        SVProgressHUD.showError(withStatus: info!)
                    }
                })
            }
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    // 分享按钮点击事件
    func statementCell(_ statementCell: StatementCell!, shareButtonAction button: UIButton!, statement: StatementModel!) {
        
        let messageObject = UMSocialMessageObject()
        
        // 缩略图
        let thumbURL = ""
        // 分享对象
        let shareObject: UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: statement.message ?? "", descr: "在这里，总会找到你喜欢的话题，点进来看看吧", thumImage: thumbURL)
        // 网址
        let str = String.init(format: "Mob/SheQu/index.html?dynamic_id=%@", statement._id)
        shareObject.webpageUrl = kApi_baseUrl(path: str)
        messageObject.shareObject = shareObject
        
        // 传相关参数
        ShareManager.shared.loadShareAdv()
        ShareManager.shared.complaintId = statement._id ?? ""
        ShareManager.shared.type = "6"
        
        ShareManager.shared.messageObject = messageObject
        ShareManager.shared.viewController = self
        ShareManager.shared.show()
    }
    // 更多按钮点击事件
    func statementCell(_ statementCell: StatementCell!, moreButtonAction button: UIButton!, statement: StatementModel!) {
        currentStatement = statement
        dataId = statement._id
        
        let statementFrame = StatementFrameModel()
        statementFrame.isShowAllMessage = true
        statementFrame.statement = statement
        
        let moreCommenityVC = MoreCommunityViewController()
        moreCommenityVC.statementFrame = statementFrame
        //        moreCommenityVC.delegate
        moreCommenityVC.delegate = self
        navigationController?.pushViewController(moreCommenityVC, animated: true)
    }
    // 评论按钮点击事件
    func statementCell(_ statementCell: StatementCell!, commentButtonAction button: UIButton!, statement: StatementModel!) {
        
        currentStatement = statement
        dataId = statement._id
        
        commentInputView.becomeFirstResponder()
        commentInputView.isHidden = false
    }
    
    func buttonActionRequestNetData(URLString: String, parameters: [String: Any]) {
        Alamofire.request(URLString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                let info = json["info"].stringValue
                if code == 200 {
                    SVProgressHUD.showSuccess(withStatus: info)
                    self.commentInputView.resignFirstResponder()
                    
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    
                    let statement = StatementModel(contentDic: dic as! [AnyHashable : Any])
                    let frameModel = StatementFrameModel()
                    frameModel.statement = statement
                    
                    for statementFrame in self.dataList {
                        if statementFrame.statement == self.currentStatement {
                            statementFrame.statement = statement
                        }
                    }
                    self.commentInputView.resignFirstResponder()
                    self.tableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MyCommunityViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if WYPContain.stringContainsEmoji(text) {
            if WYPContain.isNineKeyBoard(text) {
                return true
            }
            SVProgressHUD.showError(withStatus: "暂不支持特殊字符")
            return false
        }
        
        //在这里做你响应return键的代码
        if text == "\n" {
            //判断输入的字是否是回车，即按下return
            // 获取用户token
            let userId = AppInfo.shared.user?.userId ?? "1"
            let parameters: Parameters = ["access_token": "4170fa02947baeed645293310f478bb4",
                                          "method": "POST",
                                          "uid": userId,
                                          "dynamic_id": dataId,
                                          "content": commentInputView.text]
            let url = kApi_baseUrl(path: "api/community_comment")
            buttonActionRequestNetData(URLString: url, parameters: parameters)
            commentInputView.resignFirstResponder
            commentInputView.text = ""
            return false //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        }
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.characters.count >= 150 {
            return false
        }
        return true
    }
}

extension MyCommunityViewController: MoreCommunityViewControllerDelegate {
    func changeStatementFrameModel(statementFrame: StatementFrameModel) {
        for i in 0..<dataList.count {
            let model = dataList[i];
            if model.statement._id == dataId {
                dataList[i] = statementFrame
                tableView.reloadData()
            }
        }
    }
}

