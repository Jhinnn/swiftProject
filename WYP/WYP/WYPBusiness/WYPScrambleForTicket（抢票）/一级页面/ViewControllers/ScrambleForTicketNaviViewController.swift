//
//  ScrambleForTicketNaviViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/2/24.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ScrambleForTicketNaviViewController: BaseViewController {
    
    var firstLotteryView: FirstScrambleForTicketView!
    // 标记是否刚进来
    var flag = 0
    // 是否抽奖
    var isLottery = false
    
    // 存放控制器的数组
    var subViewControllers: [BaseViewController]?
    // 当前所在控制器的索引
    var currentIndex: NSInteger? {
        willSet {
            navTabBar.currentIndex = newValue!
            if subViewControllers != nil && flag == 0 {
                let viewController = subViewControllers?[newValue!];
                viewController?.view.frame = CGRect(x: CGFloat(newValue!) * kScreen_width, y: 0, width: kScreen_width, height: mainView.frame.size.height)
                mainView.addSubview(viewController!.view)
                self.addChildViewController(viewController!)
                
                mainView.setContentOffset(CGPoint(x: CGFloat(newValue!) * kScreen_width, y: 0), animated: false)
                
            }
        }
    }
    // 分页导航上的title数组
    var titles: [String]?
    // 遮罩
    var backView: UIView?
    // 热搜
    var hotSearchArray: [String]?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initControl()
        viewConfig()
        layoutPageSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 当前城市
        let cityName = UserDefaults.standard.object(forKey: "cityName") as? String ?? "北京"
        if cityName.count < 3 {
            leftBarButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
            leftBarButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 40, bottom: 0, right: 0)
            leftBarButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        } else if cityName.count > 2 && cityName.count < 5 {
            leftBarButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
            leftBarButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 60, bottom: 0, right: 0)
            leftBarButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        } else {
            leftBarButton.frame = CGRect(x: 0, y: 0, width: 90, height: 30)
            leftBarButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 55, bottom: 0, right: 0)
            leftBarButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -50, bottom: 0, right: 0)
        }
        leftBarButton.setTitle(cityName, for: .normal)
        
        self.navigationController?.navigationBar.isHidden = false
        
        flag = 0
        
        // 视图控制器索引和标题的设置
        currentIndex = ticketsCurrentIndex
        
        //MARK: - 显示大转盘
        loadLottery()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ticketsCurrentIndex = currentIndex!
    }
    
    // MARK: - Private Methods
    func loadLottery() {
        let uid = AppInfo.shared.user?.userId ?? ""
        NetRequest.everyLotteryNetRequest(uid: uid) { (success) in
            self.isLottery = success
            self.showLottery()
        }
    }
    func showLottery() {
        let uid = AppInfo.shared.user?.userId ?? ""
        // 判断今天是不是抽过
        if uid != "" && firstLotteryView == nil && isLottery {
            let window = self.view.window
            firstLotteryView = FirstScrambleForTicketView()
            let str = String.init(format: "Mob/WebActivity/indexluckdraw.html?uid=%@", AppInfo.shared.user?.userId ?? "")
            firstLotteryView.url = kApi_baseUrl(path: str)
            view.addSubview(firstLotteryView)
            firstLotteryView.snp.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsetsMake(-64, 0, 0, 0))
            }
            window?.bringSubview(toFront: firstLotteryView)
        }
    }
    // 初始化控件信息
    private func initControl() {
        
        // 视图控制器索引和标题的设置
        currentIndex = ticketsCurrentIndex
        
        var viewArray = [BaseViewController]()
        
        // 添加到控制器数组
        for i in 0..<3 {
            let ticket = ScrambleForTicketViewController()
            ticket.ticketType = "\(3 - i)"
            ticket.isShowBanner = true
            viewArray.append(ticket)
        }
        subViewControllers = viewArray
        
        //添加视图控制器
        let viewController = subViewControllers?[currentIndex!]
        viewController?.view.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height)
        
        mainView.addSubview(viewController!.view)
        self.addChildViewController(viewController!)
        
        // 初始化标题数组
        titles = ["抽奖","投票","问答"]
        // 将标题数组赋给分页导航的数组
        navTabBar.itemTitles = titles
        // 刷新数据
        navTabBar.updateData()
        
        view.addSubview(navTabBar)
        
        // 设置控制器的尺寸
        mainView.contentSize = CGSize(width: kScreen_width*CGFloat(subViewControllers!.count), height: 0)
        
        view.addSubview(exchangeButton)
    }

    private func viewConfig() {
        // 设置城市选择按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        // 设置导航控制器
        self.navigationItem.titleView = searchTitleView
    }
    private func layoutPageSubviews() {

        navTabBar.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(0)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.height.equalTo(42)
        }
        // 兑换按钮
        exchangeButton.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.right.equalTo(view).offset(-30)
            make.height.equalTo(42)
        }
    }
    
    lazy var searchViewController: PYSearchViewController = {
        let hotSearchArray = ["赵薇黄晓明","农村老太","盆景艺术","棉麻棉衣","共享单车","你好2017","赵薇黄晓明","农村老太","盆景艺术","棉麻棉衣","共享单车","你好2017"]
        
        let searchViewController = PYSearchViewController(hotSearches: hotSearchArray, searchBarPlaceholder: "可输入关键词，查看近期抢票活动") { (searchViewController, searchBar, searchText) in
            let result = TicketSearchResultViewController()
            result.searchView.searchTextField.text = searchText
            self.navigationController?.pushViewController(result, animated: true)
        }
        searchViewController?.hotSearchStyle = .rankTag
        searchViewController?.searchHistoryStyle = .normalTag
//        searchViewController?.cancelButton = UIBarButtonItem(title: "搜索", style: .done, target: self, action: #selector(searchButtonAction))
//        searchViewController?.naviItemHidesBackButton = true
        
        let searchBtn = UIButton(type: .custom)
        searchBtn.setTitle("搜索", for: .normal)
        searchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        searchBtn.setTitleColor(UIColor.white, for: .normal)
        searchBtn.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
        searchViewController?.cancelButton = UIBarButtonItem(customView: searchBtn)
        
        return searchViewController!
    }()
    
    // MARK: - event response
    // 城市选择按钮响应事件
    func  chooseCity(sender: UIButton) {
        let cityView = CityListViewController()
        let cityName = LocationManager.shared.currentCity ?? "北京"
        cityView.locationCityArray = [cityName]
        navigationController?.pushViewController(cityView, animated: true)
    }
    
    // 筛选
    func screenInfo(sender: UIButton) {
        
        let point = CGPoint(x: kScreen_width - 27, y: 60)
        YBPopupMenu.show(at: point, titles: ["投票", "抽奖", "问答"], icons: nil, menuWidth: 120, delegate: self)
    }
    
    // 点击搜索
    func searchNews(sender: UIButton) {
        navigationController?.pushViewController(searchViewController, animated: false)
        
        NetRequest.hotSearchNetRequest() { (success, info, hotSearches) in
            if success {
                self.searchViewController.hotSearches = hotSearches
            }
        }
    }
    
    // 搜索框取消按钮点击事件
    func searchButtonAction() {
        let result = TicketSearchResultViewController()
        result.searchView.searchTextField.text = searchViewController.searchBar.text
        self.navigationController?.pushViewController(result, animated: true)
    }
    
    // 兑换
    func exchangeTicket(sender: UIButton) {
        let inputAlert = UIAlertView(title: "奖品兑换", message: "请输入奖品兑换码", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        inputAlert.alertViewStyle = .plainTextInput
        inputAlert.show()
    }
    
    // MARK: - Setter
    // 设置城市选择按钮
    lazy var leftBarButton: UIButton = {
        let leftBarButton = UIButton(type: .custom)
        leftBarButton.setTitle("北京", for: .normal)
        leftBarButton.setImage(UIImage(named: "common_down_button_normal_iPhone"), for: .normal)
        leftBarButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftBarButton.addTarget(self, action: #selector(chooseCity(sender:)), for: .touchUpInside)
        return leftBarButton
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
    
    lazy var navTabBar: SYNavTabBar = {
        let navTabBar = SYNavTabBar(frame: .zero)
        navTabBar.delegate = self
        navTabBar.itemSpace = Int(kScreen_width) / 12
        navTabBar.backgroundColor = UIColor.white
        navTabBar.navTabBarHeight = 42
        navTabBar.buttonTextColor = UIColor.black
        navTabBar.lineColor = UIColor.red
        return navTabBar
    }()
    // 下面的控制器
    lazy var mainView: UIScrollView = {
        let mainView = UIScrollView(frame: CGRect(x: 0, y: 54, width: kScreen_width, height: kScreen_height))
        mainView.delegate = self
        mainView.isPagingEnabled = true
        mainView.bounces = false
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        self.view.addSubview(mainView)
        return mainView
    }()
    
    // 兑换按钮
    lazy var exchangeButton: UIButton = {
        let exchangeButton = UIButton()
        exchangeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        exchangeButton.backgroundColor = UIColor.clear
        exchangeButton.setTitleColor(UIColor.black, for: .normal)
        exchangeButton.setTitleColor(UIColor.red, for: .highlighted)
        exchangeButton.setTitle("兑换", for: .normal)
        exchangeButton.addTarget(self, action: #selector(exchangeTicket(sender:)), for: .touchUpInside)
        return exchangeButton
    }()
}

extension ScrambleForTicketNaviViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        flag = 2
        
        currentIndex = Int(scrollView.contentOffset.x) / Int(kScreen_width)
        navTabBar.currentIndex = currentIndex!
        
        /** 当scrollview滚动的时候加载当前视图 */
        let viewController = subViewControllers?[currentIndex!];
        viewController?.view.frame = CGRect(x: CGFloat(currentIndex!) * kScreen_width, y: 0, width: kScreen_width, height: mainView.frame.size.height)
        mainView.addSubview(viewController!.view)
        self.addChildViewController(viewController!)
    }
}
extension ScrambleForTicketNaviViewController: SYNavTabBarDelegate {
    func itemDidSelected(index: NSInteger, currentIndex: NSInteger) {
        if currentIndex-index > 3 || currentIndex-index < -3 {
            mainView.contentOffset = CGPoint(x: CGFloat(index) * kScreen_width, y: 0)
        }else{
            mainView.setContentOffset(CGPoint(x: CGFloat(index) * kScreen_width, y: 0), animated: false)
        }
    }
}

extension ScrambleForTicketNaviViewController: YBPopupMenuDelegate {
    func ybPopupMenuDidSelected(at index: Int, ybPopupMenu: YBPopupMenu!) {
        print(index)
    }
}

extension ScrambleForTicketNaviViewController: UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            return
        }
        let textField = alertView.textField(at: 0)
        
        
        
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
