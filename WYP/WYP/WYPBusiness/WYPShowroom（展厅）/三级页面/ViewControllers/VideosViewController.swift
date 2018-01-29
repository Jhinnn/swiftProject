//
//  VideosViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/10.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import ReachabilitySwift

class VideosViewController: BaseViewController {

    
    var initframe: CGRect!
    // 视频播放器view
    var player: WMPlayer!
    
    // 当前播放视频的相关信息
    var currentPlayData: VideoInfoModel? {
        willSet {
            videoAddressLabel.text = newValue?.videoTitle ?? ""
            videoPlayNumberLabel.text = String.init(format: "%d人浏览", newValue?.videoSee ?? 0)
            
            // 设置播放器相关
            player.urlString = newValue?.videoAddress ?? ""
            player.titleLabel.text = newValue?.videoTitle ?? ""
            player.play()
        }
    }
    // 是否有票
    var isTicket: Int? {
        willSet {
            if newValue == 1 {
                var image = UIImage(named: "common_backgroundColor_button_normal_iPhone")
                image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode: .tile)
                ticketButton.isEnabled = true
                ticketButton.setBackgroundImage(image, for: .normal)
            } else {
                var image = UIImage(named: "common_grayBack_icon_normal_iPhone")
                image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode: .tile)
                ticketButton.isEnabled = false
                ticketButton.setBackgroundImage(image, for: .normal)
            }
        }
    }
    // 视频列表
    var videoList: [VideoInfoModel]?
    // 展厅Id
    var roomId: String?
    // 视频Id
    var videoId: String?
    // 展厅名称
    var roomTitle: String? {
        willSet {
            ticketNameLabel.text = newValue
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
                // 播放器相关
//                self.player.urlString = self.currentPlayData?.videoAddress ?? ""
//                self.player.play()
            } else {
                let alert = UIAlertController(title: "系统提示", message: "当前为4g网络，是否继续观看", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "确定", style: .default, handler: { (_) in
                    if self.currentPlayData?.videoAddress != nil {
                        // 播放器相关
                        self.player.urlString = self.currentPlayData?.videoAddress ?? ""
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
    
    // MARK: - life cycle
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
        
        view.backgroundColor = UIColor.black
        
        viewConfig()
        layoutPageSubviews()
        addPlayerOnView()
//        NetworkStatusListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 关闭侧滑返回
        (self.navigationController as! BaseNavigationController).pan?.isEnabled = false
        // 允许横屏
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = true
        // 隐藏导航条
        navigationController?.setNavigationBarHidden(true, animated: true)
        // 获取设备旋转方向的通知,即使关闭了自动旋转,一样可以监测到设备的旋转方向
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        // 旋转屏幕通知
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceOrientationChange(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        loadVideoData(videoId: videoId ?? "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
        navigationController?.setNavigationBarHidden(false, animated: true)
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
    // 添加播放器
    func addPlayerOnView() {
        player = WMPlayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 230))
        
        initframe = player.frame
        player.urlString = ""
        player.shareBtn.isHidden = true
        view.addSubview(player)

        player.delegate = self
        
//        player.shareBtn.addTarget(self, action: #selector(shareBarButtonItemAction), for: .touchUpInside)
    }
    func viewConfig() {
        title = "宣传片"
        view.addSubview(grayLine)
        view.addSubview(videoTableView)
        
        headerView.addSubview(videoAddressLabel)
        headerView.addSubview(videoPlayNumberLabel)
        headerView.addSubview(ticketNameLabel)
        headerView.addSubview(ticketButton)
        videoTableView.tableHeaderView = headerView
    }
    func layoutPageSubviews() {
        videoTableView.snp.makeConstraints { (make) in
            make.top.equalTo(grayLine.snp.bottom)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        videoAddressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerView).offset(10)
            make.left.equalTo(headerView).offset(13)
            make.right.equalTo(headerView).offset(-13)
            make.height.equalTo(15)
        }
        videoPlayNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(videoAddressLabel.snp.bottom).offset(10)
            make.left.equalTo(headerView).offset(13)
            make.height.equalTo(11)
        }
        ticketButton.snp.makeConstraints { (make) in
            make.top.equalTo(videoPlayNumberLabel.snp.bottom).offset(16)
            make.right.equalTo(headerView).offset(-13)
            make.size.equalTo(CGSize(width: 108, height: 30.5))
        }
        ticketNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(videoPlayNumberLabel.snp.bottom).offset(20)
            make.left.equalTo(headerView).offset(13)
            make.right.equalTo(ticketButton.snp.left).offset(-10)
            make.height.equalTo(17)
        }
    }
    
    func loadVideoData(videoId: String) {
        NetRequest.roomDetailVideoNetRequest(videoId: videoId) { (success, info, result) in
            if success {
                let playDic = result?.value(forKey: "play") as! NSDictionary
                self.currentPlayData = VideoInfoModel.deserialize(from: playDic)
                let playArr = result?.value(forKey: "list")
                let data = try! JSONSerialization.data(withJSONObject: playArr!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                self.videoList = [VideoInfoModel].deserialize(from: jsonString) as? [VideoInfoModel]
                self.videoTableView.reloadData()
                
                let cell = self.videoTableView.cellForRow(at: IndexPath(row: 0, section: 0))
                cell?.isSelected = true
            } else {
                print(info!)
            }
        }
    }
    
    // MARK: - event response
    func clickGradTicket(sender: UIButton) {
        let board = UIStoryboard.init(name: "LotteryDetails", bundle: nil)
        let lotteryDetailsViewController = board.instantiateInitialViewController() as! LotteryDetailsViewController
        lotteryDetailsViewController.roomId = roomId
        navigationController?.pushViewController(lotteryDetailsViewController, animated: true)
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

    // MARK: - setter and getter
    lazy var grayLine: UIView = {
        let grayLine = UIView(frame: CGRect(x: 0, y: 230, width: kScreen_width, height: 1))
        grayLine.backgroundColor = UIColor.init(hexColor: "f1f2f4")
        return grayLine
    }()
    
    lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 105))
        headerView.backgroundColor = UIColor.white
        return headerView
    }()

    lazy var videoAddressLabel: UILabel = {
        let videoTitleLabel = UILabel()
        videoTitleLabel.textColor = UIColor.init(hexColor: "333333")
        videoTitleLabel.font = UIFont.systemFont(ofSize: 15)
        videoTitleLabel.text = "新湖少年宫于石狮市新湖中心小学内"
        return videoTitleLabel
    }()
    lazy var videoPlayNumberLabel: UILabel = {
        let videoPlayNumberLabel = UILabel()
        videoPlayNumberLabel.textColor = UIColor.init(hexColor: "87898f")
        videoPlayNumberLabel.font = UIFont.systemFont(ofSize: 11)
        videoPlayNumberLabel.text = "38.8万人浏览"
        return videoPlayNumberLabel
    }()
    lazy var ticketNameLabel: UILabel = {
        let ticketNameLabel = UILabel()
        ticketNameLabel.text = "速度与激情9"
        ticketNameLabel.textColor = UIColor.init(hexColor: "676767")
        ticketNameLabel.font = UIFont.systemFont(ofSize: 18)
        return ticketNameLabel
    }()
    lazy var ticketButton: UIButton = {
        let ticketButton = UIButton()
        var image = UIImage(named: "common_backgroundColor_button_normal_iPhone")
        image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode: .tile)
        ticketButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        ticketButton.setBackgroundImage(image, for: .normal)
        ticketButton.setTitle("立即抢票", for: .normal)
        ticketButton.setTitleColor(UIColor.init(hexColor: "ffffff"), for: .normal)
        ticketButton.layer.cornerRadius = 6.0
        ticketButton.layer.masksToBounds = true
        ticketButton.addTarget(self, action: #selector(clickGradTicket(sender:)), for: .touchUpInside)
        return ticketButton
    }()
    
    // 视频列表
    lazy var videoTableView: UITableView = {
        let videoTableView = UITableView(frame: .zero, style: .grouped)
        videoTableView.rowHeight = 107.5
        // - delegate
        videoTableView.delegate = self
        videoTableView.dataSource = self
        
        videoTableView.register(RoomVideoTableViewCell.self, forCellReuseIdentifier: "videoCell")
        return videoTableView
    }()
}

extension VideosViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if videoList != nil {
            return videoList?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell") as! RoomVideoTableViewCell
        cell.videoPlay = videoList?[indexPath.row]
        cell.selectedBackgroundView?.frame = cell.frame
        cell.selectedBackgroundView?.backgroundColor = UIColor.init(hexColor: "#f9e6e2")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        releaseWMPlayer()
        addPlayerOnView()
        
        let video = videoList?[indexPath.row]
        currentPlayData = video
    }
}

extension VideosViewController: WMPlayerDelegate {
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
