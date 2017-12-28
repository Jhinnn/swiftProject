//
//  HomeViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/2/24.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import ReachabilitySwift
import Alamofire
import SwiftyJSON
class HomeViewController: BaseViewController {
    
    // 首页数据
    var homeData: HomeModel?
    // 首页资讯
    var homeNewsData: [InfoModel]?
    // 热门搜索
    var hotSearchArray: [String]?
    // banner数据
    var bannerData: [BannerModel]?
    // logo数据
    var logoData: [BannerModel]?
    // 阿拉丁头条
    var headlineArray = [String]()
    
    // 监听单点登录
    var singleTimer: Timer?
    // 跳转至AppStore
    var trackViewUrl: String?
    
    
    
    // banner图片
    var bannerImages: [String]? {
        willSet {
            syBanner.imagePaths = newValue!
        }
    }
    
    // 记录偏移量
    var navOffset: CGFloat = 0
    
    //记录刷新次数
    var upnumb: Int = 0
    
    // 分组标题
    lazy var sectionTitleArray: [String] = {
//        let sectionTitleArray = ["抢票专区", "热门发现", "推荐群组", "热点资讯", "", "精选话题"]
        let sectionTitleArray = ["", "", "热门发现", "推荐群组", "", "精选话题", "劲爆热抢"]
        
        return sectionTitleArray
    }()
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHomeData()
        
        NetworkStatusListener()
        setupBarButtonItem()
        setupUI()
        
        

        tableView.register(ClassifyTableViewCell.self, forCellReuseIdentifier: "classfiy")
        
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 设置导航条透明度
        DispatchQueue.main.async {
            self.navBarBgAlpha = self.navOffset
            if self.navOffset == 0 {
                self.searchTitleView.alpha = 0.5
                self.navigationController?.navigationBar.isTranslucent = true
                self.navigationController?.navigationBar.subviews.first?.alpha = 0
            
                if deviceTypeIPhoneX() {
                    if #available(iOS 11.0, *) {
                        self.tableView.contentInsetAdjustmentBehavior = .never
                        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 32, 0)
                        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
                    }else {
                        self.tableView.contentInset = UIEdgeInsetsMake(-88, 0, 0, 0)
                    }
                }else{
                    if #available(iOS 11.0, *) {
                        self.tableView.contentInsetAdjustmentBehavior = .never
                        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
                    }else {
                        self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)
                    }
                    
                }
                self.tableView.snp.makeConstraints({ (make) in
                    make.top.equalTo(self.view.snp.top)
                })
                
            } else {
                self.searchTitleView.alpha = 0
                
                
            }
        }
    }

   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置导航条透明度
        DispatchQueue.main.async {
            self.navBarBgAlpha = self.navOffset
            if self.navOffset == 0 {
                self.searchTitleView.alpha = 0.5
                self.navigationController?.navigationBar.subviews.first?.alpha = 0
            } else {
                self.searchTitleView.alpha = 1
            }
        }
        
        
        
        
        
        // 初始化定时器
        let uid = AppInfo.shared.user?.userId ?? ""
        if singleTimer == nil && uid != "" {
            singleTimer = Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(checkSingleLogin), userInfo: nil, repeats: true)
        }
        
        // 根据城市名称的长度来设置偏移量
        let cityName = UserDefaults.standard.object(forKey: "cityName") as? String ?? "北京"
        if cityName.characters.count < 3 {
            leftBarButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
            leftBarButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 35, bottom: 0, right: 0)
            leftBarButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        } else if cityName.characters.count > 2 && cityName.characters.count < 5 {
            leftBarButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
            leftBarButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 60, bottom: 0, right: 0)
            leftBarButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        } else {
            leftBarButton.frame = CGRect(x: 0, y: 0, width: 90, height: 30)
            leftBarButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 55, bottom: 0, right: 0)
            leftBarButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -50, bottom: 0, right: 0)
        }
        leftBarButton.setTitle(cityName, for: .normal)
        // 设置城市选择按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        // 获取数据
        headlineArray = [String]()
        
        // 获取轮播图的数据
        loadBannerData()
        
        // 消息小圆点的设置
        let num = UIApplication.shared.applicationIconBadgeNumber
        if num == 0 {
            notificationBarButtonItem.badgeView.isHidden = true
        } else {
            notificationBarButtonItem.badgeView.isHidden = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeNotoificationMessage), name: NSNotification.Name(rawValue: "notificationMessage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeNotoificationMessage), name: NSNotification.Name(rawValue: "notificationNumber"), object: nil)
        // 开屏广告
        NotificationCenter.default.addObserver(self, selector: #selector(pushToStartAdv), name: NSNotification.Name(rawValue: "startAdv"), object: nil)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
        
    }
   
    

    // 判断当前是不是最新版本
    func currentVersion() {
        NetRequest.getCurrentVersion { (success, array) in
            if success {
                // 获取线上version
                let onlineVersion = array?[0]?.object(forKey: "version") as? String
                self.trackViewUrl = array?[0]?.object(forKey: "trackViewUrl") as? String
                // 获取当前version
                let info = Bundle.main.infoDictionary
                let currentVersion = info?["CFBundleShortVersionString"] as? String
                if currentVersion != onlineVersion {
                    let alert = SYAlertController(title: "系统提示", message: "为了保证最新数据，请升级至最新版本", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确定", style: .default, handler: { (_) in
                        UIApplication.shared.openURL(URL(string: self.trackViewUrl ?? "")!)
                    })
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    
                    alert.addAction(okAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: false, completion: nil)
                }
                
            }
        }
    }
    
    // MARK: - Reachability
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
    
    // 移除消息通知
    deinit {
        // 关闭网络状态消息监听
        reachability.stopNotifier()
        // 移除网络状态消息通知
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    // 主动检测网络状态
    func reachabilityChanged(note: NSNotification) {
        // 准备获取网络连接信息
        let reachability = note.object as! Reachability
        // 判断网络连接状态
        if reachability.isReachable {
            print("网络连接：可用")
            // 判断网络连接类型
            if reachability.isReachableViaWiFi {
                print("连接类型：WiFi")
            } else {
                print("连接类型：移动网络")
            }
        } else {
            print("网络连接：不可用")
            // 不加这句导致界面还没初始化完成就打开警告框，这样不行
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
    
    
    // MARK: - Private Methods
    // 账号是否在其他设备登录
    func checkSingleLogin() {
        let uid = AppInfo.shared.user?.userId ?? ""
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        if uid != "" {
            NetRequest.isSingleLogin(uid: uid, uuid: uuid ?? "", complete: { (success, info) in
                if !success {
                    let alert = SYAlertController(title: "系统提示", message: info, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确定", style: .default, handler: { (_) in
                        // 跳转登录页面
                        let navi = BaseNavigationController(rootViewController: LogInViewController())
                        self.present(navi, animated: true) {}
                        // 清除用户信息
                        AppInfo.shared.user = nil
                        RCIM.shared().logout()
                        // 销毁定时器
                        if self.singleTimer != nil {
                            self.singleTimer?.invalidate()
                            self.singleTimer = nil
                        }
                    })
                    alert.addAction(okAction)
                    self.present(alert, animated: false, completion: nil)
                } else {
                    
                }
            })
        }
    }
    // 开屏广告
    func pushToStartAdv() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let startAdvData = appDelegate.startAdvData
        NetRequest.clickAdvNetRequest(advId: startAdvData?.bannerId ?? "")
        switch startAdvData?.bannerType ?? "0" {
        case "0": // 默认广告
            let adv = AdvViewController()
            let link = String.init(format: "mob/adv/advdetails/id/%@", startAdvData?.bannerId ?? "")
            adv.advLink = kApi_baseUrl(path: link)
            navigationController?.pushViewController(adv, animated: false)
            break
        case "1": // 跳转url
            let adv = AdvViewController()
            adv.advLink = startAdvData?.url
            navigationController?.pushViewController(adv, animated: false)
            break
        case "2": // 跳转展厅
            // 跳转
            var board: UIStoryboard
            if startAdvData?.isFree == "0" {
                board = UIStoryboard.init(name: "FreeShowroomDetails", bundle: nil)
            } else {
                board = UIStoryboard.init(name: "ShowroomDetails", bundle: nil)
            }
            let showroomDetailsViewController = board.instantiateInitialViewController() as! ShowroomDetailsViewController
            showroomDetailsViewController.roomId = startAdvData?.roomId
            if startAdvData?.isFree == "0" {
                showroomDetailsViewController.isFree = true
            } else {
                showroomDetailsViewController.isFree = false
            }
            showroomDetailsViewController.roomInfo?.isTicket = startAdvData?.isTicket ?? 0
            navigationController?.pushViewController(showroomDetailsViewController, animated: true)
            break
        case "3": // 跳转活动
            switch startAdvData?.ticketType ?? "" {
            case "1":
                let question = QuestionsViewController()
                question.ticketId = startAdvData?.ticketId ?? ""
                question.ticketTimeId = startAdvData?.ticketTimeId ?? ""
                navigationController?.pushViewController(question, animated: false)
                break
            case "2":
                let vote = VoteViewController()
                vote.ticketId = startAdvData?.ticketId ?? ""
                vote.ticketTimeId = startAdvData?.ticketTimeId ?? ""
                navigationController?.pushViewController(vote, animated: false)
                break
            case "3":
                let lottery = LotteryViewController()
                lottery.ticketId = startAdvData?.ticketId ?? ""
                lottery.ticketTimeId = startAdvData?.ticketTimeId ?? ""
                navigationController?.pushViewController(lottery, animated: false)
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
    // 清除小圆点
    func removeNotoificationMessage() {
        notificationBarButtonItem.badgeView.isHidden = false
    }
    
    private func setupBarButtonItem() {
    
        // 设置所有按钮和通知按钮(元素越靠前，越靠right)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationBarButtonItem)
        // 设置导航控制器
        self.navigationItem.titleView = searchTitleView
    
    }
    
    

    
    
    // 消息铃铛
    lazy var notificationBarButtonItem: SYButton = {
        let notificationBarButtonItem = SYButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        notificationBarButtonItem.setImage(UIImage(named: "common_warning_button_normal_iPhone"), for: .normal)
        // 确定小红点的位置
        notificationBarButtonItem.badgeView.frame = CGRect(x: notificationBarButtonItem.bounds.maxX - 8 , y: 0, width: 10, height: 10)
        notificationBarButtonItem.addSubview(notificationBarButtonItem.badgeView)
        notificationBarButtonItem.addTarget(self, action: #selector(notificationBarButtonItemAction), for: .touchUpInside)
        return notificationBarButtonItem
    }()
    
    private func setupUI() {
        
        view.addSubview(tableView)
        // 设置表视图的头视图
        tableView.tableHeaderView = syBanner
        
       
        
        // 添加刷新的头
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            self.loadHomeData()
            self.loadBannerData()
        })
        
        let popularizeBtn = UIButton(frame: CGRect(x: kScreen_width - 85, y: 180 * width_height_ratio - 30, width: 60, height: 20))
        popularizeBtn.layer.masksToBounds = true
        popularizeBtn.layer.cornerRadius = 3
        popularizeBtn.setTitle("我要推广", for: .normal)
        popularizeBtn.backgroundColor = UIColor.black
        popularizeBtn.alpha = 0.65
        popularizeBtn.titleLabel?.textAlignment = .right
        popularizeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        popularizeBtn.setTitleColor(UIColor.init(hexColor: "#dadada"), for: .normal)
        popularizeBtn.addTarget(self, action: #selector(popularizeBtnAction), for: .touchUpInside)
        tableView.addSubview(popularizeBtn)
        
        view.addSubview(statusBarBackground)
        statusBarBackground.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(-64)
            make.height.equalTo(64)
        }
    }
    
    func loadBannerData() {
        NetRequest.homeAdv { (success, info, result) in
            if success {
                let array = result!.value(forKey: "banner")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                self.bannerData = [BannerModel].deserialize(from: jsonString) as? [BannerModel]
                
                let array1 = result?.value(forKey: "logo")
                let data1 = try! JSONSerialization.data(withJSONObject: array1!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString1 = NSString(data: data1, encoding: String.Encoding.utf8.rawValue)! as String
                self.logoData = [BannerModel].deserialize(from: jsonString1) as? [BannerModel]
                
                self.bannerImages = [String]()
                for i in 0..<self.bannerData!.count {
                    self.bannerImages?.append(self.bannerData?[i].bannerImage ?? "")
                }
                
                self.tableView.mj_header.endRefreshing()
            }
        }
    }
    
    func loadHomeData() {

        NetRequest.homeListNetRequest(uid: (AppInfo.shared.user?.userId ?? ""), upnumb: self.upnumb) { (success, info, result) in
            if success {
                self.homeData = HomeModel.deserialize(from: result) 
                self.homeNewsData = self.homeData?.hotNews
                self.headlineArray.append(self.homeData?.headLine?[0].text ?? "")
                self.headlineArray.append(self.homeData?.headLine?[1].text ?? "")
                self.upnumb = self.upnumb + 1
                
                
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                
                
                
            } else {
                print(info!)
            }
        }
    }
    
    // MARK: - setter and getter
    // 状态栏的背景
    lazy var statusBarBackground: UIImageView = {
        let statusBarBackground = UIImageView()
        statusBarBackground.image = UIImage(named: "common_navback_icon_normal_iPhone")
        return statusBarBackground
    }()
    // 设置城市选择按钮
    lazy var leftBarButton: UIButton = {
        let leftBarButton = UIButton(type: .custom)
        leftBarButton.setImage(UIImage(named: "common_down_button_normal_iPhone"), for: .normal)
        leftBarButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftBarButton.addTarget(self, action: #selector(chooseCity(sender:)), for: .touchUpInside)
        
        return leftBarButton
    }()
    
    // 设置表视图
    @IBOutlet weak var tableView: WYPTableView!
    
    // 设置表视图头视图
    lazy var syBanner: SYBannerView = {
        let banner = SYBannerView(frame: CGRect(x: 0, y: 80, width: kScreen_width, height: 180 * width_height_ratio))
        banner.delegate = self
        return banner
    }()
    
    // 导航栏上的view
    lazy var searchTitleView: commonSearchView = {
        let searchTitleView = commonSearchView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 34))

        // 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchNews(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        searchTitleView.addGestureRecognizer(tap)
        
        return searchTitleView
    }()
    
    func setupButton(_ imageName: String, _ title: String, _ frame: CGRect) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.blue
        let btnImg = UIImage(named: imageName)
        btnImg?.cornerImage(size: CGSize(width: 40, height: 40), radius: 20, fillColor: UIColor.clear, completion: { (image) in
            button.setImage(btnImg, for: .normal)
        })
        button.setTitle(title, for: .normal)
        
        return button
    }
    
    lazy var searchViewController: PYSearchViewController = {
        let hotSearchArray = ["赵薇黄晓明","农村老太","盆景艺术","棉麻棉衣","共享单车","你好2017","赵薇黄晓明","农村老太","盆景艺术","棉麻棉衣","共享单车","你好2017"]
        
        let searchViewController = PYSearchViewController(hotSearches: hotSearchArray, searchBarPlaceholder: "可输入关键字进行信息搜索") { (searchViewController, searchBar, searchText) in
            let result = SearchResultNaviViewController()
            result.searchView.searchTextField.text = searchText
            
            self.navigationController?.pushViewController(result, animated: true)
        }
        searchViewController?.delegate = self
        searchViewController?.hotSearchStyle = .rankTag
        searchViewController?.searchHistoryStyle = .normalTag
//        searchViewController?.naviItemHidesBackButton = true
        
        let searchBtn = UIButton(type: .custom)
        searchBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 24)
        searchBtn.setTitle("搜索", for: .normal)
        searchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        searchBtn.setTitleColor(UIColor.white, for: .normal)
        searchBtn.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
        searchViewController?.cancelButton = UIBarButtonItem(customView: searchBtn)
        
        return searchViewController!
    }()
    
    // MARK: - NSCopying
    
    
    
    // MARK: - IBActions
    
    // 搜索按钮点击事件
    func searchNews(sender: UIButton) {
        
        navigationController?.pushViewController(searchViewController, animated: false)
        
        NetRequest.hotSearchNetRequest() { (success, info, hotSearches) in
            if success {
                self.searchViewController.hotSearches = hotSearches
            }
        }
    }
    
    // 通知按钮点击事件
    func notificationBarButtonItemAction() {
        navigationController?.pushViewController(NotificationViewController(), animated: false)
    }
    
    // 搜索框取消按钮点击事件
    func searchButtonAction() {
        if searchViewController.searchBar.text == "" {
            SYAlertController.showAlertController(view: self, title: "提示", message: "搜索内容不能为空")
            return
        }
        let result = SearchResultNaviViewController()
        result.searchView.searchTextField.text = searchViewController.searchBar.text
        self.navigationController?.pushViewController(result, animated: true)
    }
    
    // 8大类按钮点击事件
    @IBAction func buttonAction(_ sender: UIButton) {
        // 100 - 107

        switch sender.tag {
        case 100:
            roomsCurrentIndex = 1
            tabBarController?.selectedIndex = 2
        case 101:
            roomsCurrentIndex = 5
            tabBarController?.selectedIndex = 2
        case 102:
            roomsCurrentIndex = 2
            tabBarController?.selectedIndex = 2
        case 103:
            roomsCurrentIndex = 3
            tabBarController?.selectedIndex = 2
        case 104:
            roomsCurrentIndex = 6
            tabBarController?.selectedIndex = 2
        case 105:
            roomsCurrentIndex = 4
            tabBarController?.selectedIndex = 2
        case 106:
            newsCurrentIndex = 11
            tabBarController?.selectedIndex = 1
            
        case 107:
            var friendsArr = [PersonModel]()
            // 获取好友数
            NetRequest.friendsListNetRequest(openId: AppInfo.shared.user?.token ?? "", page: "") { (success, info, result) in
                if success {
                    let array = result!.value(forKey: "data")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    friendsArr = [PersonModel].deserialize(from: jsonString) as! [PersonModel]
                    
                    let community = MyCommunityViewController()
                    community.title = "个人主页"
                    community.headImageUrl = AppInfo.shared.user?.headImgUrl ?? ""
                    community.userId = AppInfo.shared.user?.userId ?? ""
                    community.nickName = AppInfo.shared.user?.nickName ?? ""
                    community.fansCount = String.init(format: "粉丝:%@人", AppInfo.shared.user?.fans ?? "0")
                    community.friendsCountLabel.text = String.init(format: "好友:%d人", friendsArr.count)
                    community.type = "2"
                    community.isFollowed = false
                    self.navigationController?.pushViewController(community, animated: true)
                    
                } else {
                    if info == "请先登录！" {
                        
                        // 跳转登录页面
                        let navi = BaseNavigationController(rootViewController: LogInViewController())
                        self.present(navi, animated: true) {}

                    } else {
                        SVProgressHUD.showError(withStatus: info!)
                    }
                }
                sender.isEnabled = false
                self.perform(#selector(self.delayToEnable(sender:)), with: nil, afterDelay: 0.1)
            }
            
        default:
            break
        }
    }
    // 延时1s才能点击
    func delayToEnable(sender: UIButton) {
        let button = view.viewWithTag(107) as! UIButton
        button.isEnabled = true
    }
    
    // 抢票专区按钮点击事件
    @IBAction func scrambleTicketBtnAction(_ sender: UIButton) {
        // tag: 500 - 503
        switch sender.tag {
        case 500:
            let inputAlert = UIAlertView(title: "奖品兑换", message: "请输入奖品兑换码", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            inputAlert.alertViewStyle = .plainTextInput
            inputAlert.show()
        case 501:
            ticketsCurrentIndex = 0
            tabBarController?.selectedIndex = 3
        case 502:
            ticketsCurrentIndex = 2
            tabBarController?.selectedIndex = 3
        case 503:
            ticketsCurrentIndex = 1
            tabBarController?.selectedIndex = 3
        default:
            break
        }
    }
    
    // 城市选择按钮响应事件
    func  chooseCity(sender: UIButton) {
        let cityView = CityListViewController()
        let cityName = LocationManager.shared.currentCity ?? "北京"
        cityView.locationCityArray = [cityName]
        navigationController?.pushViewController(cityView, animated: false)
    }
    
    // 点击更多
    func showMore(sender: UIButton) {
        switch sender.tag {
        case 3:
            roomsCurrentIndex = 0
            tabBarController?.selectedIndex = 2
            break
        case 4:
            navigationController?.pushViewController(TheaterGroupViewController(), animated: true)
            break
        case 6:
            newsCurrentIndex = 11
            tabBarController?.selectedIndex = 1
        default:
            break
        }
    }
    
    func popularizeBtnAction() {
        let uid = AppInfo.shared.user?.userId ?? ""
        if uid == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        // 申请入驻
        navigationController?.pushViewController(ApplyToEnterViewController(), animated: false)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
            return homeNewsData?.count ?? 0
        } else if section == 6 {
            tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
            return homeData?.hotTopics?.count ?? 0
        } else if section == 7 {
            return 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            // 分类八个按钮
            let cell = tableView.dequeueReusableCell(withIdentifier: "classfiy", for: indexPath) as! ClassifyTableViewCell
            if headlineArray.count == 0 {
                cell.titleArray = ["体验现场娱乐，参与火热抢票","体验现场娱乐，参与火热抢票"]
            } else {
                cell.titleArray = headlineArray
            }
            
            cell.delegate = self
            return cell
        } else if indexPath.section == 1 && indexPath.row == 0 {
            // 抢票专区
            let cell = tableView.dequeueReusableCell(withIdentifier: "scrambleforticketbuttonCellIdentifier", for: indexPath)
            
            return cell
        } else if indexPath.section == 3 && indexPath.row == 0 {
            
            // 热门发现
            let cell = tableView.dequeueReusableCell(withIdentifier: "showroomCellIdentifier", for: indexPath)
            let collectionView = cell.viewWithTag(300) as? UICollectionView
            if collectionView != nil {
                collectionView?.reloadData()
            }
            return cell
        } else if indexPath.section == 4 && indexPath.row == 0 {
            // 热门群组
            let cell = tableView.dequeueReusableCell(withIdentifier: "theaterGroupCellIdentifier", for: indexPath)
            let collectionView = cell.viewWithTag(301) as? UICollectionView
            if collectionView != nil {
                collectionView?.reloadData()
            }
            return cell
        } else if indexPath.section == 2  {
            if homeNewsData != nil {
                switch homeNewsData![indexPath.row].showType! {
                case 0: // 视频
                    let cell = VideoInfoTableViewCell(style: .default, reuseIdentifier: "videoCell")
                    cell.line.isHidden = false
                    cell.infoModel = homeNewsData?[indexPath.row]
                    
                    return cell
                case 1: //只有文字
                    let cell = TravelTableViewCell(style: .default, reuseIdentifier: "textCell")
                    cell.line.isHidden = false
                    cell.infoModel = homeNewsData?[indexPath.row]
            
                    return cell
                case 2: //上图下文
                    let cell = VideoInfoTableViewCell(style: .default, reuseIdentifier: "videoCell")
                    cell.line.isHidden = false
                    cell.infoModel = homeNewsData?[indexPath.row]
                    cell.infoLabel.isHidden = true
                    cell.playImageView.isHidden = true
                    return cell
                case 3: //左文右图
                    let cell = OnePictureTableViewCell(style: .default, reuseIdentifier: "onePicCell")
                    cell.line.isHidden = false
                    cell.infoModel = homeNewsData?[indexPath.row]
                    
                    return cell
                case 4: //三张图
                    let cell = ThreePictureTableViewCell(style: .default, reuseIdentifier: "threeCell")
                    cell.line.isHidden = false
                    cell.infoModel = homeNewsData?[indexPath.row]
                
                    return cell
                case 5: // 大图
                    let cell = VideoInfoTableViewCell(style: .default, reuseIdentifier: "videoCell")
                    cell.line.isHidden = false
                    cell.infoLabel.isHidden = true
                    cell.playImageView.isHidden = true
                    cell.infoModel = homeNewsData?[indexPath.row]
                    return cell
                default:
                    return UITableViewCell()
                }
                
                
            }
            return UITableViewCell()
        } else if indexPath.section == 5 {
            // 广告位
            let cell = ADTableViewCell(style: .default, reuseIdentifier: "AdvertisementCellIdentifier")
            cell.delegate = self
            let url1 = URL(string: logoData?[0].bannerImage ?? "")
            let url2 = URL(string: logoData?[1].bannerImage ?? "")
            cell.adImageView1.kf.setImage(with: url1)
            cell.adImageView2.kf.setImage(with: url2)
            return cell
            
        } else if indexPath.section == 6 {
            let cell = TopicsCell(style: .default, reuseIdentifier: "TopicsViewIdentifier")
            let view = UIView()
            view.backgroundColor = tableView.separatorColor
            cell.contentView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.height.equalTo(0.5)
                make.left.equalTo(cell.contentView).offset(15)
                make.right.equalTo(cell.contentView)
                make.bottom.equalTo(cell.contentView)
            })
            cell.delegate = self
            cell.starCountButton.tag = 110 + indexPath.row
            let topicsFrame = TopicsFrameModel()
            topicsFrame.topics = homeData?.hotTopics?[indexPath.row]
            
            cell.topicsFrame = topicsFrame
            
            return cell
        } else if indexPath.section == 7 {
            let cell = ScrambleForTicketCell(style: .default, reuseIdentifier: "ticketCell")
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 { // 六大分类
            return 110
        } else if indexPath.section == 1 { // 抢票专区
            return 0
        } else if indexPath.section == 2 { // 热门资讯
            if homeNewsData != nil {
                switch homeNewsData![indexPath.row].showType! {
                case 0:
                    return 275 * width_height_ratio
                case 1:
                    return 87.5 * width_height_ratio
                case 2:
                    return 275 * width_height_ratio
                case 3:
                    return 109
                case 4:
                    return 160 * width_height_ratio
                case 5:
                    return 275 * width_height_ratio
                default:
                    return 0
                }
            }
            return 0
            
        } else if indexPath.section == 3 { // 热门发现
            return 220
            
        } else if indexPath.section == 4 { // 推荐群组
            return 160
            
        } else if indexPath.section == 5 { // 广告位
            return 77 * width_height_ratio
        } else if indexPath.section == 6 { // 精选话题
            if homeData != nil {
                let topicsFrame = TopicsFrameModel()
                topicsFrame.topics = homeData?.hotTopics?[indexPath.row]
                
                return topicsFrame.cellHeight!
            }
            return 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // 隐藏抢票专区
        if section != 0 && section != 5 && section != 1 && section != 2 {
            return 40
        }
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 4 {
            return 0.01
        }
        // 隐藏抢票专区
        if section == 1 {
            return 0.01
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 5 || section == 0 {
            return nil
        }
        
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 0))
        sectionHeaderView.backgroundColor = UIColor.white
        
        // 图标视图
        let iconView = UIImageView()
        iconView.image = UIImage(named: "home_rednote_icon_normal_iPhone")
        sectionHeaderView.addSubview(iconView)
        iconView.isHidden = true
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.init(hexColor: "333333")
        titleLabel.text = sectionTitleArray[section - 1]
        sectionHeaderView.addSubview(titleLabel)
        // 设置布局
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(sectionHeaderView)
            make.top.equalTo(sectionHeaderView).offset(10)
            make.size.equalTo(CGSize(width: 2, height: 16))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(4)
            make.top.equalTo(sectionHeaderView).offset(10)
            make.height.equalTo(15)
        }
        /*if section == 1 {
            // 抢票专区
            
            let ccpView = CCPScrollView(frame: CGRect(x: kScreen_width - 250 * width_height_ratio - 30, y: 0, width: 250 * width_height_ratio, height: 40))
            ccpView.titleArray = ["体验现场娱乐，参与火热抢票"]
            ccpView.titleFont = 12
            ccpView.titleColor = UIColor.gray
            ccpView.bgColor = UIColor.white
            ccpView.clickTitleLabel({ (index, titleSrting) in
                print("index:\(index),titleString\(titleSrting!)")
            })
            sectionHeaderView.addSubview(ccpView)
        } */
        if section == 3 || section == 4 || section == 6 || section == 7 {
            // 更多按钮
            let moreButton = UIButton()
            moreButton.tag = section
            moreButton.setImage(UIImage(named: "home_more_button_normal_iPhone"), for: .normal)
            moreButton.addTarget(self, action: #selector(showMore(sender:)), for: .touchUpInside)
            sectionHeaderView.addSubview(moreButton)
            moreButton.snp.makeConstraints { (make) in
                make.right.equalTo(sectionHeaderView).offset(-15.5)
                make.top.equalTo(sectionHeaderView).offset(13.5)
                make.size.equalTo(CGSize(width: 17, height: 17))
            }
            // icon
            iconView.isHidden = false
        }
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 { // 热点资讯
            if homeNewsData![indexPath.row].infoType! == 4 { // 图集
                let newsDetail = NewsPhotosDetailViewController()
                newsDetail.currentIndex = 0
                newsDetail.isFollow = homeNewsData?[indexPath.row].isFollow
                newsDetail.imageArray = homeNewsData?[indexPath.row].infoImageArr
                newsDetail.contentArray = homeNewsData?[indexPath.row].contentArray
                newsDetail.newsId = homeNewsData?[indexPath.row].newsId ?? ""
                newsDetail.newsTitle = homeNewsData?[indexPath.row].infoTitle
                newsDetail.commentNumber = homeNewsData?[indexPath.row].infoComment ?? "0"
                navigationController?.pushViewController(newsDetail, animated: true)
                
            } else if homeNewsData![indexPath.row].infoType! == 2 { // 视频
                let newsDetail = VideoDetailViewController()
                newsDetail.newsId = homeNewsData?[indexPath.row].newsId ?? ""
                newsDetail.newsTitle = homeNewsData?[indexPath.row].infoTitle
                navigationController?.pushViewController(newsDetail, animated: true)
                
            } else { // web
                if homeNewsData?[indexPath.row].advLink != "" {
                    let adv = AdvViewController()
                    adv.advLink = self.homeNewsData?[indexPath.row].advLink
                    adv.newsTitle = self.homeNewsData?[indexPath.row].infoTitle
                    navigationController?.pushViewController(adv, animated: true)
                } else {
                    
                    if homeNewsData?[indexPath.row].infoSource == "话题" {
                        let talkNewsDetail = TalkNewsDetailsViewController()
                        talkNewsDetail.newsId = homeNewsData?[indexPath.row].newsId
                        talkNewsDetail.newsTitle = homeNewsData?[indexPath.row].infoTitle
                        navigationController?.pushViewController(talkNewsDetail, animated: true)
                    }else {
                        let newsDetail = NewsDetailsViewController()
                        newsDetail.newsTitle = homeNewsData?[indexPath.row].infoTitle
                        newsDetail.newsId = homeNewsData?[indexPath.row].newsId
                        newsDetail.commentNumber = homeNewsData?[indexPath.row].infoComment
                        navigationController?.pushViewController(newsDetail, animated: true)
                    }
                    
                    
                }
            }
        } else if indexPath.section == 6 {
            
            let talkNewsDetail = TalkNewsDetailsViewController()
            talkNewsDetail.newsId = homeData?.hotTopics?[indexPath.row].topicId
            talkNewsDetail.newsTitle = homeData?.hotTopics?[indexPath.row].content
            navigationController?.pushViewController(talkNewsDetail, animated: true)
        
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UICollectionView.self) {
            return
        }
        self.navOffset = scrollView.contentOffset.y / (tableView.tableHeaderView?.frame.size.height)!
        self.navBarBgAlpha = self.navOffset
        if self.navOffset > 0.3 {
            notificationBarButtonItem.changeBadgeViewColor(color: .white)
            searchTitleView.searchView.searchLabel.textColor = UIColor.init(hexColor: "cbcbcb")
            searchTitleView.alpha = 1
        } else {
            notificationBarButtonItem.changeBadgeViewColor(color: .themeColor)
            searchTitleView.searchView.searchLabel.textColor = UIColor.init(hexColor: "333333")
            searchTitleView.alpha = 0.5
        }
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if homeData != nil {
            switch collectionView.tag {
            case 300:
                return (homeData?.hotShowRoom?.count)!
            case 301:
                return (homeData?.hotGroup?.count)!
            default:
                return 0
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if homeData != nil {
            switch collectionView.tag {
            case 300:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) as! HotShowRoomCell
                cell.showRoomModel = homeData?.hotShowRoom?[indexPath.item]
                return cell
            case 301:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) as! HotTheaterGroupCell
                cell.groupModel = homeData?.hotGroup?[indexPath.item]
                return cell
            default:

                return UICollectionViewCell()
            }
        }
        
        return UICollectionViewCell()
    }
    
    // MARK: - UICollectionViewDelegate
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView.tag {
        case 300:
//            let showroomDetailsViewController = board.instantiateInitialViewController() as! ShowroomDetailsViewController
//            showroomDetailsViewController.roomId = .groupId ?? ""
            // 跳转
            let showRoom = homeData?.hotShowRoom?[indexPath.row]
            var board: UIStoryboard
            if showRoom?.isFree == "0" {
                // 免费
                board = UIStoryboard.init(name: "FreeShowroomDetails", bundle: nil)
            } else {
                // 收费
                board = UIStoryboard.init(name: "ShowroomDetails", bundle: nil)
            }
            let showroomDetailsViewController = board.instantiateInitialViewController() as! ShowroomDetailsViewController
            showroomDetailsViewController.roomId = showRoom?.groupId
            if showRoom?.isFree == "0" {
                // 免费
                showroomDetailsViewController.isFree = true
            } else {
                // 收费
                showroomDetailsViewController.isFree = false
            }
            navigationController?.pushViewController(showroomDetailsViewController, animated: true)
        case 301:
            
    
            let groupModel = homeData?.hotGroup?[indexPath.item]
    
            Alamofire.request(kApi_getIsJoinGroup, method: .post, parameters: ["access_token":access_token,"method" : "POST","uid":AppInfo.shared.user?.userId ?? "","qunid": groupModel?.groupId ?? ""], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                
                let json = JSON(response.result.value!)
                let dic = json.dictionary
                let str = dic!["is_join"]!
              
                
                if str == "0" {
                    let group = GroupMemberListViewController()
                    group.groupId = groupModel?.groupId ?? ""
                    group.roomName = groupModel?.roomName ?? ""
                    group.groupName = groupModel?.groupName ?? ""
                    self.navigationController?.pushViewController(group, animated: false)
                }else {
                    let conversationVC = ChatDeatilViewController()
                    conversationVC.conversationType = RCConversationType.ConversationType_GROUP
                    conversationVC.targetId = groupModel?.groupId ?? "0"
                    conversationVC.roomName = groupModel?.roomName ?? ""
                    conversationVC.groupName = groupModel?.groupName ?? ""
                    self.navigationController?.pushViewController(conversationVC, animated: true)
                }
                
            }
        default:
            break
        }
    }
    
    
}

extension HomeViewController: SYBannerViewDelegate {
    
    // MARK: - LBBannerDelegate
    
    func cycleScrollView(_ scrollView: SYBannerView, didSelectItemAtIndex index: Int) {
        NetRequest.clickAdvNetRequest(advId: bannerData?[index].bannerId ?? "")
        switch bannerData?[index].bannerType ?? "0" {
        case "0": // 默认广告
            let adv = AdvViewController()
            let link = String.init(format: "mob/adv/advdetails/id/%@", bannerData?[index].bannerId ?? "")
            adv.advLink = kApi_baseUrl(path: link)
            navigationController?.pushViewController(adv, animated: false)
            break
        case "1": // 跳转url
            let adv = AdvViewController()
            adv.advLink = bannerData?[index].url ?? ""
            navigationController?.pushViewController(adv, animated: false)
            break
        case "2": // 跳转展厅
            // 跳转
            let showRoom = bannerData?[index]
            var board: UIStoryboard
            if showRoom?.isFree == "0" {
                board = UIStoryboard.init(name: "FreeShowroomDetails", bundle: nil)
            } else {
                board = UIStoryboard.init(name: "ShowroomDetails", bundle: nil)
            }
            let showroomDetailsViewController = board.instantiateInitialViewController() as! ShowroomDetailsViewController
            showroomDetailsViewController.roomId = showRoom?.roomId
            showroomDetailsViewController.isTicket = bannerData?[index].isTicket ?? 0
            if showRoom?.isFree == "0" {
                showroomDetailsViewController.isFree = true
            } else {
                showroomDetailsViewController.isFree = false
            }
            navigationController?.pushViewController(showroomDetailsViewController, animated: false)
            break
        case "3": // 跳转活动
            switch bannerData?[index].ticketType ?? "" {
            case "1":
                let question = QuestionsViewController()
                question.ticketId = bannerData?[index].ticketId ?? ""
                question.ticketTimeId = bannerData?[index].ticketTimeId ?? ""
                navigationController?.pushViewController(question, animated: false)
                break
            case "2":
                let vote = VoteViewController()
                vote.ticketId = bannerData?[index].ticketId ?? ""
                vote.ticketTimeId = bannerData?[index].ticketTimeId ?? ""
                navigationController?.pushViewController(vote, animated: false)
                break
            case "3":
                let lottery = LotteryViewController()
                lottery.ticketId = bannerData?[index].ticketId ?? ""
                lottery.ticketTimeId = bannerData?[index].ticketTimeId ?? ""
                navigationController?.pushViewController(lottery, animated: false)
                break
            default:
                break
            }
        default:
            break
        }

    }
}

extension HomeViewController: TopicsCellDelegate {
    func clickImageAction(sender: UIButton, topics: TopicsModel) {
        
        let personalInformationVC = PersonalInformationViewController()
        personalInformationVC.targetId = topics.peopleId ?? ""
        personalInformationVC.name = topics.nickName ?? ""
        navigationController?.pushViewController(personalInformationVC, animated: true)

    }
    
    func starDidSelected(sender: UIButton, topics: TopicsModel) {
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        NetRequest.topicStarNetRequest(openId: AppInfo.shared.user?.token ?? "", newsId: topics.topicId ?? "", typeId: "1", cid: "") { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info!)
                sender.isSelected = true
                topics.isStar = "1"
                topics.starCount = "\(Int(topics.starCount!)! + 1)"
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
}

extension HomeViewController: UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            return
        }
        let textField = alertView.textField(at: 0)
        print(textField?.text ?? "哈哈哈")
        
        NetRequest.exchangeNetRequest(token: AppInfo.shared.user?.token ?? "", code: textField?.text ?? "") { (success, info, dic) in
            if success {
                let sb = UIStoryboard.init(name: "Main", bundle: nil)
                let goodsAdressVC = sb.instantiateViewController(withIdentifier: "GoodsAddressIdentity") as! GoodsAddressController
                goodsAdressVC.ticketTimeId = dic?.object(forKey: "ticket_time_id") as? String
                goodsAdressVC.typeId = "1"
                goodsAdressVC.walletId = dic?.object(forKey: "wallet_id") as? String
                goodsAdressVC.invitationId = ""
                goodsAdressVC.flag = 2
                self.navigationController?.pushViewController(goodsAdressVC, animated: true)
            } else {
                SVProgressHUD.showError(withStatus: info)
            }
            
        }
        
    }
}

extension HomeViewController: TopicsDetailsViewControllerDelegate {
    
    func starBtnAction(topicId: String, topicsFrame: TopicsFrameModel) {
        for i in 0..<homeData!.hotTopics!.count {
            let model = homeData!.hotTopics![i]
            
            if model.topicId == topicId {
                homeData!.hotTopics![i] = topicsFrame.topics
                tableView.reloadData()
            }
        }
    }
}

extension HomeViewController: ADTableViewCellDelegate {
    func adTableViewDidSeletedImageView1() {
        adPush(item: 0)
    }
    func adTableViewDidSeletedImageView2() {
        adPush(item: 1)
    }
    
    func adPush(item: Int) {
        NetRequest.clickAdvNetRequest(advId: logoData?[item].bannerId ?? "")
        switch logoData?[item].bannerType ?? "0" {
        case "0": // 默认广告
            let adv = AdvViewController()
            let link = String.init(format: "mob/adv/advdetails/id/%@", logoData?[item].bannerId ?? "")
            adv.advLink = kApi_baseUrl(path: link)
            navigationController?.pushViewController(adv, animated: false)
            break
        case "1": // 跳转url
            let adv = AdvViewController()
            adv.advLink = logoData?[item].url
            navigationController?.pushViewController(adv, animated: false)
            break
        case "2": // 跳转展厅
            // 跳转
            let showRoom = logoData?[item]
            var board: UIStoryboard
            if showRoom?.isFree == "0" {
                board = UIStoryboard.init(name: "FreeShowroomDetails", bundle: nil)
            } else {
                board = UIStoryboard.init(name: "ShowroomDetails", bundle: nil)
            }
            let showroomDetailsViewController = board.instantiateInitialViewController() as! ShowroomDetailsViewController
            showroomDetailsViewController.roomId = showRoom?.roomId
            if showRoom?.isFree == "0" {
                showroomDetailsViewController.isFree = true
            } else {
                showroomDetailsViewController.isFree = false
            }
            showroomDetailsViewController.roomInfo?.isTicket = logoData?[item].isTicket ?? 0
            navigationController?.pushViewController(showroomDetailsViewController, animated: true)
            break
        case "3": // 跳转活动
            switch logoData?[item].ticketType ?? "" {
            case "1":
                let question = QuestionsViewController()
                question.ticketId = logoData?[item].ticketId ?? ""
                question.ticketTimeId = logoData?[item].ticketTimeId ?? ""
                navigationController?.pushViewController(question, animated: false)
                break
            case "2":
                let vote = VoteViewController()
                vote.ticketId = logoData?[item].ticketId ?? ""
                vote.ticketTimeId = logoData?[item].ticketTimeId ?? ""
                navigationController?.pushViewController(vote, animated: false)
                break
            case "3":
                let lottery = LotteryViewController()
                lottery.ticketId = logoData?[item].ticketId ?? ""
                lottery.ticketTimeId = logoData?[item].ticketTimeId ?? ""
                navigationController?.pushViewController(lottery, animated: false)
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
}

extension HomeViewController: ClassifyTableViewCellDelegate {
    func clickCCPScrollView(index: Int) {
        let news = NewsDetailsViewController()
        if homeData?.headLine != nil {
            news.newsId = homeData?.headLine![index].newsId
        }
        self.navigationController?.pushViewController(news, animated: false)
    }
    
    func clickToClassifyVC(sender: ClassButton) {
        switch sender.tag {
        case 1001:
            roomsCurrentIndex = 1
            tabBarController?.selectedIndex = 2
        case 1002:
            roomsCurrentIndex = 3
            tabBarController?.selectedIndex = 2
        case 1003:
            roomsCurrentIndex = 2
            tabBarController?.selectedIndex = 2
        case 1004:
            roomsCurrentIndex = 5
            tabBarController?.selectedIndex = 2
        case 1005:
            ticketsCurrentIndex = 1
            tabBarController?.selectedIndex = 3
        default:
            break
        }
    }

}

extension HomeViewController: PYSearchViewControllerDelegate {
    func didClickCancel(_ searchViewController: PYSearchViewController!) {
        searchButtonAction()
    }
}
