//
//  VideoDetailViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/28.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import ReachabilitySwift

class VideoDetailViewController: BaseViewController {

    var initframe: CGRect!
    // 视频播放器view
    var player: WMPlayer!
    // 记录状态的隐藏显示
    var isHiddenStatusBar = false
    // newsId
    var newsId: String?
    // 新闻标题
    var newsTitle: String?
    // 标记
    var flag = 0
    
    // model
    var videoData: VideoDetailModel? {
        willSet {
            // 播放器相关
            player.titleLabel.text = newValue?.videoTitle ?? ""
            player.urlString = newValue?.videoPath ?? ""
            player.play()
            
            commentNumLabel.text = newValue?.videoCommentNumber ?? "0"
            videoTitleLabel.text = newValue?.videoTitle ?? ""
            videoDetailLabel.text = newValue?.videoDetail ?? ""
            videoSourceLabel.text = String.init(format: "来源：%@", newValue?.videoSource ?? "一千零一夜")
            videoTime.text = newValue?.videoCreateTime?.getTimeString()
            seeNumberLabel.text = String.init(format: "浏览人数：%@", newValue?.videoSeeNumber ?? "浏览人数：0")
            starCountButton.setTitle(String.init(format: " %@", newValue?.videoLikeNumber ?? ""), for: .normal)
            if newValue?.isStar == "1" {
                starCountButton.isSelected = true
            } else if newValue?.isStar == "0" {
                starCountButton.isSelected = false
            }
            if newValue?.isFollow == "1" {
                collectionButton.isSelected = true
            } else if newValue?.isFollow == "0" {
                collectionButton.isSelected = false
            }
        }
    }
    
    // Reachability必须一直存在，所以需要设置为全局变量
    let reachability = Reachability()!
    
    func NetworkStatusListener() {
        // 1、设置网络状态消息监听 2、获得网络Reachability对象
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            // 3、开启网络状态消息监听
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    // 主动检测网络状态
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            print("网络连接：可用")
            if reachability.isReachableViaWiFi {
                print("连接类型：WiFi")
                
            } else {
                let alert = UIAlertController(title: "系统提示", message: "当前为4g网络，是否继续观看", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "确定", style: .default, handler: { (_) in
                    if self.videoData?.videoPath != nil {
                        // 播放器相关
                        self.player.urlString = self.videoData?.videoPath ?? ""
                        self.player.play()
                    }
                })
                let cancelAction = UIAlertAction(title: "取消", style: .default, handler: { (_) in
                    self.navigationController?.popViewController(animated: false)
                })
                alert.addAction(OKAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            print("网络连接：不可用")
            DispatchQueue.main.async {
                self.alert_noNetwrok()
            }
        }
    }
    
    // 警告框，提示没有连接网络 *********************
    func alert_noNetwrok() -> Void {
        let alert = UIAlertController(title: "系统提示", message: "请检查网络连接", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return isHiddenStatusBar
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        // 对于present出来的控制器，要主动的更新一个约束，让wmPlayer全屏，更安全
        if player.isFullscreen == false {
            player.snp.remakeConstraints { (make) in
                make.width.equalTo(kScreen_height)
                make.height.equalTo(kScreen_width)
                make.center.equalTo(self.player.superview!)
            }
            player.isFullscreen = true
        }
        return UIInterfaceOrientation.portrait
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupUI()
        addPlayerOnView()
//        NetworkStatusListener()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 推送资讯入口
        let push = UserDefaults.standard.object(forKey: "VideoPush") as? String
        if push == "VideoPush" {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "common_navback_button_normal_iPhone"), style: .done, target: self, action: #selector(rebackToRootViewAction(sender:)))
        }
        
        if flag != 100 {
            (self.navigationController as! BaseNavigationController).pan?.isEnabled = false
        }
        
        // 实时刷新数据
        loadVideoData(requestType: .update)
        newsTableView.reloadData()
        
        // 允许自动旋转
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = true
        
        // 获取设备旋转方向的通知,即使关闭了自动旋转,一样可以监测到设备的旋转方向
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        // 旋转屏幕通知
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceOrientationChange(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        navigationController?.setNavigationBarHidden(true, animated: true)
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared().isEnabled = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        player.pause()
    }
    
    deinit {
        releaseWMPlayer()
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        // 关闭网络状态消息监听
        reachability.stopNotifier()
        // 移除网络状态消息通知
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    // MARK: - private method
    func loadVideoData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }

        NetRequest.newsVideoDetailNetRequest(page: "\(pageNumber)",uid: AppInfo.shared.user?.userId ?? "", newsId: newsId ?? "") { (success, info, result) in
            if success {
                
                if requestType == .update {
                    self.videoData = VideoDetailModel.deserialize(from: result)
                } else {
                    let array = result!.value(forKey: "comments")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    let commentData = [CommentModel].deserialize(from: jsonString) as! [CommentModel]
                    self.videoData?.comment = (self.videoData?.comment)! + commentData
                }
                self.newsTableView.mj_header.endRefreshing()
                self.newsTableView.mj_footer.endRefreshing()
                self.newsTableView.reloadData()
            } else {
                self.newsTableView.mj_header.endRefreshing()
                self.newsTableView.mj_footer.endRefreshing()
            }
            
        }
    }
    
    // 添加播放器
    func addPlayerOnView() {
        player = WMPlayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 230))
        
        initframe = player.frame
        player.urlString = ""
        view.addSubview(player)
        
        player.delegate = self
        
        // 分享按钮
        player.shareBtn.addTarget(self, action: #selector(shareBarButtonItemAction), for: .touchUpInside)
    }
    // 释放播放器
    func releaseWMPlayer() {
        player.pause()
        player.removeFromSuperview()
        player.playerLayer.removeFromSuperlayer()
        player.player.replaceCurrentItem(with: nil)
        player.player = nil
        player.currentItem = nil
        // 释放定时器 否侧不会调用WMPlayer中的dealloc方法
        if player.autoDismissTimer != nil {
            player.autoDismissTimer.invalidate()
            player.autoDismissTimer = nil
        }
        player.playOrPauseBtn = nil
        player.playerLayer = nil
        player = nil
        
    }
    
    /**
     *  旋转屏幕通知
     */
    func onDeviceOrientationChange(notification: NSNotification) {
        if player == nil || player.superview == nil {
            return
        }
        let orientation = UIDevice.current.orientation
        let interfaceOrientation: UIInterfaceOrientation = UIInterfaceOrientation(rawValue: orientation.rawValue)!
        
        switch interfaceOrientation {
        case .portraitUpsideDown:
            print("第3个旋转方向---电池栏在下")
            player.isFullscreen = false
            player.fullScreenBtn.isSelected = false
            
            break
        case .portrait:
            print("第0个旋转方向---电池栏在上")
            self.toOrientation(orientation: UIInterfaceOrientation.portrait)
            player.isFullscreen = false
            player.fullScreenBtn.isSelected = false
            
            break
        case .landscapeLeft:
            print("第2个旋转方向---电池栏在左")
            self.toOrientation(orientation: UIInterfaceOrientation.landscapeLeft)
            player.isFullscreen = true
            player.fullScreenBtn.isSelected = true
            
            break
        case .landscapeRight:
            print("第1个旋转方向---电池栏在右")
            self.toOrientation(orientation: UIInterfaceOrientation.landscapeRight)
            player.isFullscreen = true
            player.fullScreenBtn.isSelected = true
            
            break
        default: break
        }
        
    }
    // 点击进入,退出全屏,或者监测到屏幕旋转去调用的方法
    func toOrientation(orientation: UIInterfaceOrientation) {
        
        if orientation == UIInterfaceOrientation.portrait {
            
            player.snp.remakeConstraints({ (make) in
                make.top.equalTo(self.view)
                make.left.equalTo(self.view)
                make.right.equalTo(self.view)
                make.height.equalTo(initframe.size.height)
            })
        } else {
            player.snp.remakeConstraints({ (make) in
                make.width.equalTo(kScreen_width)
                make.height.equalTo(kScreen_height)
                make.center.equalTo(self.player.superview!)
            })
        }
        
    }
    
    func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "common_share_button_highlight_iPhone"), style: .done, target: self, action: #selector(shareBarButtonItemAction))
        
        view.addSubview(grayLine)
        view.addSubview(openCloseButton)
        view.addSubview(videoTitleLabel)
        view.addSubview(videoDetailLabel)
        view.addSubview(videoSourceLabel)
        view.addSubview(videoTime)
        view.addSubview(starCountButton)
        view.addSubview(seeNumberLabel)
        view.addSubview(line)
        view.addSubview(newsTableView)
        view.addSubview(interactionView)
        interactionView.addSubview(collectionButton)
        interactionView.addSubview(commentTextField)
        setupUIFrame()
    }
    
    func setupUIFrame() {
        // 展开按钮
        openCloseButton.snp.makeConstraints { (make) in
            make.top.equalTo(grayLine.snp.bottom).offset(13)
            make.right.equalTo(view).offset(-13)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        // 视频标题
        videoTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(grayLine.snp.bottom).offset(12)
            make.left.equalTo(view).offset(13)
            make.right.equalTo(openCloseButton.snp.left).offset(-10)
            make.height.equalTo(13)
        }
        // 视频简介
        videoDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(13)
            make.top.equalTo(videoTitleLabel.snp.bottom).offset(13)
            make.right.equalTo(view).offset(-13)
            make.height.equalTo(0)
        }
        // 视频来源
        videoSourceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(videoDetailLabel.snp.bottom).offset(13)
            make.left.equalTo(view).offset(13)
            make.height.equalTo(11)
        }
        // 视频创建时间
        videoTime.snp.makeConstraints { (make) in
            make.left.equalTo(videoSourceLabel.snp.right).offset(13)
            make.top.equalTo(videoDetailLabel.snp.bottom).offset(13)
            make.height.equalTo(11)
        }
        // 点赞按钮
        starCountButton.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(13)
            make.size.equalTo(CGSize(width: 41, height: 25))
            make.top.equalTo(videoSourceLabel.snp.bottom).offset(15)
        }
        // 浏览数
        seeNumberLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(starCountButton)
            make.right.equalTo(view).offset(-13)
            make.height.equalTo(10)
        }
        // 线
        line.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(seeNumberLabel.snp.bottom).offset(6)
            make.height.equalTo(1)
        }
        // 评论tableview
        newsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(5)
            make.bottom.equalTo(view).offset(-49)
            make.left.right.equalTo(view)
        }
        // 评论框
        interactionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(49)
        }
        collectionButton.snp.makeConstraints { (make) in
            make.right.equalTo(interactionView).offset(-15)
            make.bottom.equalTo(interactionView).offset(-14.5)
            make.size.equalTo(CGSize(width: 19.5, height: 19.5))
        }
        commentTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(interactionView).offset(-10)
            make.left.equalTo(interactionView).offset(13)
            make.right.equalTo(collectionButton.snp.left).offset(-15)
            make.height.equalTo(30)
        }
    }
    
    // MARK: - event reaponse
    //返回
    func rebackToRootViewAction(sender: UIBarButtonItem) {
        let pushJudge = UserDefaults.standard
        pushJudge.set("", forKey: "VideoPush")
        self.dismiss(animated: false, completion: nil)
    }
    // 分享
    func shareBarButtonItemAction() {
        
        let uid = AppInfo.shared.user?.userId ?? ""
        if uid == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        
        // 点击分享的时候视频暂停
        player.pause()
        
        let messageObject = UMSocialMessageObject()
        // 分享链接
        let url = String.init(format: "Mob/news/video.html?news_id=%@", newsId ?? "")
        let shareLink = kApi_baseUrl(path: url)
        // 设置文本
//        messageObject.text = newsTitle! + shareLink
        // 分享对象
        let shareObject: UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: newsTitle ?? "", descr: "在这里，有各种好玩的资讯等着你，点进来看看吧", thumImage: UIImage(named: "aladdiny_icon"))
        // 网址
        shareObject.webpageUrl = shareLink
        messageObject.shareObject = shareObject
        
        // 传相关参数
        ShareManager.shared.loadShareAdv()
        ShareManager.shared.complaintId = newsId ?? ""
        ShareManager.shared.type = "1"
        
        ShareManager.shared.messageObject = messageObject
        ShareManager.shared.viewController = self
        ShareManager.shared.show()
    }


    func collectionNews(sender: UIButton) {
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        if sender.isSelected {
            NetRequest.cancelAttentionNetRequest(openId: token, newsId: newsId ?? "", complete: { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info!)
                    sender.isSelected = false
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            })
        } else if !sender.isSelected {
            NetRequest.collectionNewsNetRequest(openId: token, newsId: newsId ?? "") { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info!)
                    sender.isSelected = true
                    sender.setImage(UIImage(named: "common_collection_button_selected_iPhone"), for: .selected)
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            }
        }
    }
    
    // MARK: - setter and getter
    // 隔离线
    lazy var grayLine: UIView = {
        let grayLine = UIView(frame: CGRect(x: 0, y: 230, width: kScreen_width, height: 1))
        grayLine.backgroundColor = UIColor.init(hexColor: "f1f2f4")
        return grayLine
    }()
    // 展开收起按钮
    lazy var openCloseButton: UIButton = {
        let openCloseButton = UIButton()
        openCloseButton.setImage(UIImage(named: "common_allType_button_normal_iPhone"), for: .normal)
        openCloseButton.setImage(UIImage(named: "common_up_button_normal_iPhone"), for: .selected)
        openCloseButton.addTarget(self, action: #selector(openOrClose(sender:)), for: .touchUpInside)
        return openCloseButton
    }()
    // 视频标题
    lazy var videoTitleLabel: UILabel = {
        let videoTitleLabel = UILabel()
        videoTitleLabel.font = UIFont.systemFont(ofSize: 13)
        videoTitleLabel.textColor = UIColor.init(hexColor: "333333")
        return videoTitleLabel
    }()
    // 视频简介
    lazy var videoDetailLabel: UILabel = {
        let videoDetailLabel = UILabel()
        videoDetailLabel.numberOfLines = 0
        videoDetailLabel.font = UIFont.systemFont(ofSize: 11)
        videoDetailLabel.textColor = UIColor.init(hexColor: "a1a1a1")
        return videoDetailLabel
    }()
    // 视频来源
    lazy var videoSourceLabel: UILabel = {
        let videoSourceLabel = UILabel()
        videoSourceLabel.font = UIFont.systemFont(ofSize: 10)
        videoSourceLabel.textColor = UIColor.init(hexColor: "a1a1a1")
        return videoSourceLabel
    }()
    // 视频创建时间
    lazy var videoTime: UILabel = {
        let videoTime = UILabel()
        videoTime.font = UIFont.systemFont(ofSize: 10)
        videoTime.textColor = UIColor.init(hexColor: "a1a1a1")
        return videoTime
    }()
    // 视频点赞数
    lazy var starCountButton: UIButton = {
        let starCountButton = UIButton()
        starCountButton.setImage(UIImage(named: "common_grayStar_button_normal_iPhone"), for: .normal)
        starCountButton.setImage(UIImage(named: "common_zan_button_selected_iPhone"), for: .selected)
        starCountButton.setTitleColor(UIColor.init(hexColor: "a1a1a1"), for: .normal)
        starCountButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        starCountButton.addTarget(self, action: #selector(clickStarButton(sender:)), for: .touchUpInside)
        return starCountButton
    }()
    // 视频评论数
    lazy var commentNumLabel: UILabel = {
        let commentNumLabel = UILabel()
        commentNumLabel.textColor = UIColor.init(hexColor: "a1a1a1")
        commentNumLabel.font = UIFont.systemFont(ofSize: 10)
        return commentNumLabel
    }()
    // 视频浏览数
    lazy var seeNumberLabel: UILabel = {
        let seeNumberLabel = UILabel()
        seeNumberLabel.textColor = UIColor.init(hexColor: "a1a1a1")
        seeNumberLabel.font = UIFont.systemFont(ofSize: 10)
        return seeNumberLabel
    }()
    // 线
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.init(hexColor: "a1a1a1")
        return line
    }()
    
    lazy var newsTableView: WYPTableView = {
        let tableView = WYPTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.mj_header =  MJRefreshNormalHeader(refreshingBlock: {
            self.loadVideoData(requestType: .update)
        })
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadVideoData(requestType: .loadMore)
        })

        tableView.register(TopicReplyTableViewCell.self, forCellReuseIdentifier: "replyCell")
        
        return tableView
    }()
    
    // 背景
    lazy var interactionView: UIView = {
        let interactionView = UIView()
        interactionView.backgroundColor = UIColor.white
        return interactionView
    }()
    
    // 评论框
    lazy var commentTextField: SYTextField = {
        let commentTextField = SYTextField()
        commentTextField.font = UIFont.systemFont(ofSize: 13)
        commentTextField.delegate = self
        commentTextField.borderStyle = .roundedRect
        commentTextField.placeholder = "期待你的神评论"
        commentTextField.returnKeyType = .send
        
        let imageView = UIImageView(frame: CGRect(x: 5, y: 8.25, width: 13.5, height: 13.5))
        imageView.image = UIImage(named: "common_editorGary_button_normal_iPhone")
        commentTextField.addSubview(imageView)
        
        return commentTextField
    }()
    // 收藏
    lazy var collectionButton: UIButton = {
        let collectionButton = UIButton()
        collectionButton.setBackgroundImage(UIImage(named: "common_collection_button_normal_iPhone"), for: .normal)
        collectionButton.setBackgroundImage(UIImage(named: "common_collection_button_selected_iPhone"), for: .selected)
        collectionButton.addTarget(self, action: #selector(collectionNews(sender:)), for: .touchUpInside)
        return collectionButton
    }()
    
    
    // MARK: - IBAction
    // 展开收起按钮
    func openOrClose(sender: UIButton) {
        if sender.isSelected { // 当前为展开状态
            videoDetailLabel.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
        } else { // 当前为收起状态
            let contentSize = String().stringSize(text: videoData?.videoDetail ?? "", font: UIFont.systemFont(ofSize: 11), maxSize: CGSize(width: kScreen_width - 26, height: 1000))
            print(contentSize.height)
            videoDetailLabel.snp.updateConstraints({ (make) in
                make.height.equalTo(contentSize.height)
            })
            
        }
        sender.isSelected = !sender.isSelected
    }
    
    // 点赞按钮
    func clickStarButton(sender: UIButton) {
        
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        NetRequest.topicStarNetRequest(openId: token, newsId: newsId ?? "", typeId: "1", cid: "") { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info!)
                sender.isSelected = true
                self.loadVideoData(requestType: .update)
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
    
    func keyboardWillShow(note: NSNotification) {
        let userInfo = note.userInfo!
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
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
        self.interactionView.transform = CGAffineTransform(translationX: 0 , y: 0)
    }

}



extension VideoDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if videoData?.comment != nil {
            return (videoData?.comment?.count)!
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ShowRoomCommentCell(style: .default, reuseIdentifier: "TopicsViewIdentifier")
        let commentFrame = RoomCommentFrameModel()
        commentFrame.comment = videoData?.comment?[indexPath.row]
        cell.replyButton.tag = indexPath.row + 190
        cell.delegate = self
        cell.commentFrame = commentFrame
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let commentFrame = RoomCommentFrameModel()
        commentFrame.comment = videoData?.comment?[indexPath.row]
        return commentFrame.cellHeight ?? 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 40))
        headerView.backgroundColor = UIColor.white
        let iconView = UIImageView(frame: CGRect(x: 0, y: 13, width: 2, height: 18))
        iconView.image = UIImage(named: "home_rednote_icon_normal_iPhone")
        headerView.addSubview(iconView)
        let hotCommentLabel = UILabel(frame: CGRect(x: 13, y: 10, width: 100, height: 30))
        hotCommentLabel.text = "最新评论"
        hotCommentLabel.font = UIFont.systemFont(ofSize: 15)
        headerView.addSubview(hotCommentLabel)
        
        commentNumLabel.frame = CGRect(x: kScreen_width - 50, y: 0, width: 60, height: 40)
        commentNumLabel.text = String.init(format: "评论数%d", videoData?.comment?.count ?? 0)
        headerView.addSubview(commentNumLabel)
        
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if videoData?.comment != nil {
            return 50
        } else {
            return 0
        }
    }
}

extension VideoDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return false
        }
        NetRequest.topicsCommentNetRequest(openId: token, topicId: newsId ?? "", content: textField.text ?? "", pid: "") { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info!)
                self.commentTextField.text = ""
                self.commentTextField.resignFirstResponder()
                self.loadVideoData(requestType: .update)
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if PublicGroupViewController().stringContainsEmoji(string) {
            if PublicGroupViewController().isNineKeyBoard(string) {
                return true
            }
            SVProgressHUD.showError(withStatus: "暂不支持特殊字符")
            return false
        }
        return true
    }
}

extension VideoDetailViewController: ShowRoomCommentCellDelegate {
    func commentReplyStarDidSelected(sender: UIButton, comments: CommentModel) {
        
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        NetRequest.topicStarNetRequest(openId: token, newsId: newsId ?? "", typeId: "2", cid: comments.commentId ?? "") { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info!)
                sender.isSelected = true
                comments.isStar = "1"
                comments.zanNumber = "\(Int(comments.zanNumber!)! + 1)"
                self.newsTableView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }

    func commentReplyButtonDidSelected(sender: UIButton) {
        let commentReply = CommentReplyViewController()
        commentReply.flag = 2
        commentReply.newsId = newsId ?? ""
        commentReply.commentData = videoData?.comment?[sender.tag - 190]
        navigationController?.pushViewController(commentReply, animated: true)
    }
}

extension VideoDetailViewController: WMPlayerDelegate {
    // 全屏按钮
    func wmplayer(_ wmplayer: WMPlayer!, clickedFullScreenButton fullScreenBtn: UIButton!) {
        
        if player.isFullscreen == true {// 全屏
            // 强制翻转屏幕，Home键在下边
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            player.isFullscreen = false
            
        } else {//非全屏
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            
            self.toOrientation(orientation: .landscapeRight)
            player.isFullscreen = true
            
        }
    }
    
    // 操作栏隐藏或者显示都会调用此方法
    func wmplayer(_ wmplayer: WMPlayer!, isHiddenTopAndBottomView isHidden: Bool) {
        isHiddenStatusBar = isHidden
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    // 关闭播放器事件
    func wmplayer(_ wmplayer: WMPlayer!, clickedClose closeBtn: UIButton!) {
        if wmplayer.isFullscreen {
            // 强制翻转屏幕，Home键在下边
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            // 刷新
            UIViewController.attemptRotationToDeviceOrientation()
            
            
            player.snp.remakeConstraints({ (make) in
                make.top.equalTo(self.view)
                make.left.equalTo(self.view)
                make.right.equalTo(self.view)
                make.height.equalTo(initframe.size.height)
            })
            player.isFullscreen = false
        } else {
            
            if (self.presentingViewController != nil) {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
