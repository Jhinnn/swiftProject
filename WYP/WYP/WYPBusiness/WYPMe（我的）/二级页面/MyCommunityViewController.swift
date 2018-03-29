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
    
    
    var statmentId: String!
    
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
    var type: String! = ""
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
            let releaseButton = UIBarButtonItem(image: UIImage.init(named: "community_icon_publish_normalmore"), style: .done, target: self, action: #selector(releaseDynamic))
            navigationItem.rightBarButtonItem = releaseButton
            followBtn.isHidden = true
        } else {
            // 不是自己的朋友圈
            followBtn.isHidden = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        loadPersonData()
        
        setupUI()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(shareSuccess), name: NSNotification.Name(rawValue: "shareSuccessNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared().isEnabled = false
        
        loadNetData(requestType: .update)
        
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
        tableViewHeaderView.addSubview(imageLabel)
        tableViewHeaderView.addSubview(friendsCountLabel)
        tableViewHeaderView.addSubview(fansCountLabel)
        tableViewHeaderView.addSubview(signatureLabel)
        tableViewHeaderView.addSubview(followBtn)
        
        view.addSubview(interactionView)
        interactionView.addSubview(commentTextField)
        
        //添加 查找聊天记录View
        view.addSubview(findChatHistory)
        //添加 消息免打扰View
        view.addSubview(essageDoNotDisturb)
        //添加 发送消息按钮
        setupUIFrame()
    }
    
    func setupUIFrame() {
        
        
        tableView.snp.makeConstraints { (make) in
            if deviceTypeIPhoneX() {
                make.top.equalTo(view).offset(-88)
            }else {
                make.top.equalTo(view).offset(-64)
            }
            
            make.left.right.equalTo(view)
            make.bottom.equalTo(self.view)
        }
        
        interactionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(40)
        }
        
        
        headerImgView.snp.makeConstraints { (make) in
            make.top.equalTo(tableViewHeaderView).offset(100)
            make.centerX.equalTo(tableViewHeaderView)
            make.size.equalTo(75)
        }
        
        nickNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(tableViewHeaderView)
            make.top.equalTo(headerImgView.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 200, height: 30))
        }
        
        imageLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 2, height: 13))
            make.centerX.equalTo(tableViewHeaderView)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(5)
        }
        
        friendsCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(imageLabel.snp.centerY)
            make.right.equalTo(imageLabel.snp.left).offset(-10)
            make.height.equalTo(35)
        }
        
        fansCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(imageLabel.snp.centerY)
            make.left.equalTo(imageLabel.snp.right).offset(10)
            make.height.equalTo(35)
        }
        
        signatureLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(tableViewHeaderView)
            make.height.equalTo(20)
            make.top.equalTo(imageLabel.snp.bottom).offset(12)
            make.width.equalTo(kScreen_width - 140)
        }
        
        followBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(fansCountLabel)
            make.left.equalTo(fansCountLabel.snp.right).offset(15)
            make.size.equalTo(CGSize(width: 60, height: 30))
        }
        
        commentTextField.snp.makeConstraints { (make) in
            
            make.top.equalTo(interactionView.snp.top).offset(3)
            make.right.equalTo(interactionView).offset(0)
            make.left.equalTo(interactionView).offset(0)
            make.height.equalTo(34)
        }
    }
    
    //发送消息按钮
    lazy var sendMessageButton: UIButton = {
        let sendMessageButton:UIButton = UIButton()
        sendMessageButton.addTarget(self, action: #selector(clickAddFriendsButton), for: UIControlEvents.touchUpInside)
        sendMessageButton.layer.cornerRadius = 5
        sendMessageButton.setTitle("添加朋友", for: .normal)
        sendMessageButton.backgroundColor = UIColor(red: 221/250, green: 78/250, blue: 60/250, alpha: 0.5)
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
        
        let tableView = WYPTableView(frame:CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height), style: .plain)
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
        let tableViewHeaderView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_width * 0.75))
        tableViewHeaderView.backgroundColor = UIColor.white
        tableViewHeaderView.isUserInteractionEnabled = true
        return tableViewHeaderView
    }()
    
    // 头像
    lazy var headerImgView: UIImageView = {
        let headerImgView = UIImageView()
        headerImgView.layer.cornerRadius = 37.5
        headerImgView.layer.masksToBounds = true
        headerImgView.layer.borderColor = UIColor.white.cgColor
        headerImgView.layer.borderWidth = 2
        headerImgView.backgroundColor = UIColor.init(hexColor: "a1a1a1")
        return headerImgView
    }()
    
    // 昵称
    lazy var nickNameLabel: UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.textColor = UIColor.white
        nickNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        nickNameLabel.text = self.nickName
        nickNameLabel.textAlignment = NSTextAlignment.center
        return nickNameLabel
    }()
    
    // 好友
    lazy var friendsCountLabel: UILabel = {
        let friendsCountLabel = UILabel()
        friendsCountLabel.textColor = UIColor.white
        friendsCountLabel.numberOfLines = 2
        friendsCountLabel.font = UIFont.boldSystemFont(ofSize: 14)
        friendsCountLabel.text = self.friendsCount
        friendsCountLabel.textAlignment = NSTextAlignment.right
        return friendsCountLabel
    }()
    
    // 好友
    lazy var imageLabel: UIImageView = {
        let imageLabel = UIImageView()
        imageLabel.backgroundColor = UIColor.white
        return imageLabel
    }()
    
    // 粉丝
    lazy var fansCountLabel: UILabel = {
        let fansCountLabel = UILabel()
        fansCountLabel.textColor = UIColor.white
        fansCountLabel.numberOfLines = 2
        fansCountLabel.font = UIFont.boldSystemFont(ofSize: 14)
        fansCountLabel.text = self.fansCount
        
        return fansCountLabel
    }()
    
    // 粉丝
    lazy var signatureLabel: UILabel = {
        let signatureLabel = UILabel()
        signatureLabel.textColor = UIColor.white
        signatureLabel.font = UIFont.boldSystemFont(ofSize: 13)
        signatureLabel.textAlignment = NSTextAlignment.center
        signatureLabel.text = ""
        signatureLabel.isHidden = true;
        signatureLabel.layer.masksToBounds = true
        signatureLabel.layer.cornerRadius = 10
        signatureLabel.backgroundColor = UIColor.init(red: 196/255.0, green: 198/255.0, blue: 201/255.0, alpha: 0.5)
        return signatureLabel
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
    
    // 背景
    lazy var interactionView: UIView = {
        let interactionView = UIView()
        interactionView.backgroundColor = UIColor.white
        interactionView.isHidden = true
        return interactionView
    }()
    
    // 评论框
    lazy var commentTextField: SYTextField = {
        let commentTextField = SYTextField()
        commentTextField.font = UIFont.systemFont(ofSize: 13)
        commentTextField.delegate = self
        commentTextField.borderStyle = .roundedRect
        commentTextField.placeholder = "写下你的评论..."
        commentTextField.returnKeyType = .send
        
        let imageView = UIImageView(frame: CGRect(x: 5, y: 9, width: 16, height: 16))
        imageView.image = UIImage(named: "community_icon_edit_normal")
        commentTextField.addSubview(imageView)
        
        return commentTextField
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
        self.interactionView.isHidden = false
        let deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {
            //键盘的偏移量
            self.interactionView.transform = CGAffineTransform(translationX: 0 , y: -deltaY)
            
            
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else{
            animations()
        }
    }
    
    
    func keyboardWillHidden(note: NSNotification) {
        
        interactionView.isHidden = true
    }
    
    //加载个人信息
    func loadPersonData() {
        
        NetRequest.getPersonCommunityNetRequest(uid: userId, mid: AppInfo.shared.user?.userId ?? "") { (success, info, dic) in
            self.fansCountLabel.text = String.init(format: "粉丝:%@人", (dic?["fans_num"] as? String)!)
            self.friendsCountLabel.text = String.init(format: "好友:%@人", (dic?["friend_num"] as? String)!)
            
            let url = URL(string: (dic?["avatar"] as? String)!)
            self.headerImgView.kf.setImage(with: url, placeholder: UIImage(named: "mine_header_icon_normal_iPhone"), options: nil, progressBlock: nil, completionHandler: nil)
            
            self.nickNameLabel.text = String.init(format: "%@", (dic?["nickname"] as? String)!)
            
            self.addFriendsPhoneNumber = (dic?["mobile"] as? String)!
            

        
            self.tableViewHeaderView.kf.setImage(with: url, placeholder: UIImage.init(named: "place_image"), options: nil, progressBlock: nil, completionHandler: nil)
            
            self.signatureLabel.isHidden = false;
            self.signatureLabel.text = String.init(format: "%@", (dic?["signature"] as? String)!)
            
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
                    self.loadPersonData()
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
        let parameters: Parameters = ["access_token": "4170fa02947baeed645293310f478bb4",
                                      "method": "POST",
                                      "type": type,
                                      "uid": userId,
                                      "is_login_uid": AppInfo.shared.user?.userId ?? "",
                                      "page": "\(pageNumber)",
            "usertype": userType]
        let url = kApi_baseUrl(path: "api/Community")
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                
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
                    }
                    
                    if requestType == .update {
                        self.dataList = models
                    } else {
                        // 把新数据添加进去
                        self.dataList = self.dataList + models
                    }
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
                            make.top.equalTo(self.view).offset(150)
                        }
                        make.top.equalTo(self.view).offset(220)
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
    
    // FIX: //分享成功能
    func shareSuccess() {
        let parameters: Parameters = ["access_token": "4170fa02947baeed645293310f478bb4",
                                      "method": "POST",
                                      "id": self.statmentId]
        let url = kApi_baseUrl(path: "api/share_dynamic")
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                self.loadNetData(requestType: .update)
                self.tableView.reloadData()
                
            case .failure(_): break
                
            }
            
        }
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
        let staFrame = dataList[indexPath.row]
        
        if (cell.starArrayView != nil) {
            cell.starArrayView.delegate = self
            
        }else {
            
        }
        cell.statementFrame = staFrame
        cell.selectionStyle = .none
        cell.delegate = self
        if userId != staFrame.statement.userId && self.type == "1" {
            cell.deleteButton.isHidden = true
        }
        
        if self.type == "2"                                                                                                                                                                                                                     {
            cell.deleteButton.isHidden = true
        }
        
        
        cell.selectImgBlock = {(index, imageUrlArray) in
            let albumVC = AlbumViewController()
            albumVC.dataList = imageUrlArray
            albumVC.selectedIndex = index
            albumVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(albumVC, animated: true, completion: {
                
            })
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

extension MyCommunityViewController: ShowStarViewDelegate {
    public func showStarView(_ starView: ShowStarView!, list array: [Any]!) {
        let zanlistVC = ZanListViewController()
        zanlistVC.zanListArray = array! as NSArray
        self.navigationController?.pushViewController(zanlistVC, animated: true)
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
        
        self.statmentId = statement._id  //获得动态id
        
        
        let messageObject = UMSocialMessageObject()
        
        // 缩略图
        //        let thumbURL = ""
        // 分享对象
        let shareObject: UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: statement.message ?? "", descr: "在这里，总会找到你喜欢的话题，点进来看看吧", thumImage: UIImage(named: "aladdiny_icon"))
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
        
        
        //
        //        }
        
        
    }
    //图片点击
    func statementCell(_ statementCell: StatementCell!, statement: StatementModel!) {
        let personalInformationVC = PersonalInformationViewController()
        personalInformationVC.targetId = statement.userId ?? ""
        personalInformationVC.name = statement.name ?? ""
        navigationController?.pushViewController(personalInformationVC, animated: true)
    }
    
    // 更多按钮点击事件
    func statementCell(_ statementCell: StatementCell!, moreButtonAction button: UIButton!, statement: StatementModel!) {
        let moreCommenityVC = MoreCommunityViewController()
        moreCommenityVC.dataId = statement._id
        navigationController?.pushViewController(moreCommenityVC, animated: true)
    }
    // 评论按钮点击事件
    func statementCell(_ statementCell: StatementCell!, commentButtonAction button: UIButton!, statement: StatementModel!) {
        
        currentStatement = statement
        dataId = statement._id
        
        commentTextField.becomeFirstResponder()
        commentTextField.isHidden = false
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
                    self.commentTextField.resignFirstResponder()
                    self.loadNetData(requestType: .update)
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



extension MyCommunityViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        if WYPContain.stringContainsEmoji(textField.text) {
            
            if WYPContain.isNineKeyBoard(textField.text) {
                return true
            }
            SVProgressHUD.showError(withStatus: "暂不支持特殊字符")
            return false
        }
        
        //在这里做你响应return键的代码
        if !(textField.text?.isEmpty)! {
            //判断输入的字是否是回车，即按下return
            // 获取用户token
            let userId = AppInfo.shared.user?.userId ?? "1"
            let parameters: Parameters = ["access_token": "4170fa02947baeed645293310f478bb4",
                                          "method": "POST",
                                          "uid": userId,
                                          "dynamic_id": dataId,
                                          "content": textField.text!]
            let url = kApi_baseUrl(path: "api/community_comment")
            buttonActionRequestNetData(URLString: url, parameters: parameters)
            interactionView.isHidden = true
            textField.text  = ""
            return false //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        }
        
        return true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if WYPContain.stringContainsEmoji(string) {
            if WYPContain.isNineKeyBoard(string) {
                return true
            }
            SVProgressHUD.showError(withStatus: "暂不支持特殊字符")
            return false
        }
        return true
    }
}

//extension MyCommunityViewController: MoreCommunityViewControllerDelegate {
//    func changeStatementFrameModel(statementFrame: StatementFrameModel) {
//        for i in 0..<dataList.count {
//            let model = dataList[i];
//            if model.statement._id == dataId {
//                dataList[i] = statementFrame
//                tableView.reloadData()
//            }
//        }
//    }
//}

