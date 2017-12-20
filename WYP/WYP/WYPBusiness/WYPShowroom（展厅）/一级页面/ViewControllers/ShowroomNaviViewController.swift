//
//  ShowroomNaviViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/2/24.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ShowroomNaviViewController: BaseViewController {

    // 标记是否刚进来
    var flag = 0
    
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
        
        self.navigationController?.navigationBar.isHidden = false
        flag = 0
        // 视图控制器索引和标题的设置
        currentIndex = roomsCurrentIndex
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        roomsCurrentIndex = currentIndex!
    }
    
    // MARK: - Private Methods
    // 初始化控件信息
    private func initControl() {
        
        // 视图控制器索引和标题的设置
        currentIndex = roomsCurrentIndex
        
        var viewArray = [BaseViewController]()
        // 添加到控制器数组
        for i in 0..<7 {
            let showroom = ShowRoomViewController()
            if i == 0 {
                showroom.isShowBanner = true
                showroom.typeId = ""
            } else {
                if i < 3 || i == 6 {
                    showroom.typeId = "\(i)"
                }else if i == 3 {
                    showroom.typeId = "5"
                } else if i > 3  {
                    showroom.typeId = "\(i - 1)"
                }
                showroom.isShowBanner = false
                
            }
            viewArray.append(showroom)
        }
        subViewControllers = viewArray
        
        //添加视图控制器
        let viewController = subViewControllers?[currentIndex!]
        viewController?.view.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height)
        
        mainView.addSubview(viewController!.view)
        self.addChildViewController(viewController!)
        
        // 初始化标题数组
        titles = ["全部","演出","旅游","电影","会展","赛事","栏目"]
        // 将标题数组赋给分页导航的数组
        navTabBar.itemTitles = titles
        // 刷新数据
        navTabBar.updateData()
        
        view.addSubview(navTabBar)
                
        // 设置控制器的尺寸
        mainView.contentSize = CGSize(width: kScreen_width*CGFloat(subViewControllers!.count), height: 0)
    }

    private func viewConfig() {
        // 设置导航控制器
        searchTitleView.searchView.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize(width: 210 * width_height_ratio, height: 30))
        }
        self.navigationItem.titleView = searchTitleView
        self.navigationItem.rightBarButtonItem = sortItemButton
    }
    
    private func layoutPageSubviews() {
        // 分页导航
        navTabBar.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(0)
            make.size.equalTo(CGSize(width: kScreen_width, height: 42))
        }
    }
    
    lazy var searchViewController: PYSearchViewController = {
        let hotSearchArray = ["赵薇黄晓明","农村老太","盆景艺术","棉麻棉衣","共享单车","你好2017","赵薇黄晓明","农村老太","盆景艺术","棉麻棉衣","共享单车","你好2017"]
        
        let searchViewController = PYSearchViewController(hotSearches: hotSearchArray, searchBarPlaceholder: "可输入关键词，查看最新现场娱乐") { (searchViewController, searchBar, searchText) in
            let result = RoomSearchResultViewController()
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
    func screenInfo(sender: UIButton) {
        let point = CGPoint(x: kScreen_width - 30, y: 55)
        let popupMenu = YBPopupMenu.show(at: point, titles: ["最新", "最热"], icons: nil, menuWidth: 80, delegate: self)
        popupMenu?.dismissOnSelected = true
        popupMenu?.type = .default
    }

    // 搜索框取消按钮点击事件
    func searchButtonAction() {
        if searchViewController.searchBar.text == "" {
            SYAlertController.showAlertController(view: self, title: "提示", message: "搜索内容不能为空")
            return
        }
        let result = RoomSearchResultViewController()
        result.searchView.searchTextField.text = searchViewController.searchBar.text
        self.navigationController?.pushViewController(result, animated: true)
    }
    
    // MARK: - Setter
    lazy var navTabBar: SYNavTabBar = {
        let navTabBar = SYNavTabBar(frame: .zero)
        navTabBar.delegate = self
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

    lazy var searchTitleView: navTitleView = {
        let searchTitleView = navTitleView(frame: CGRect(x: 0, y: 0, width: kScreen_width - 50, height: 34))
        searchTitleView.delegate = self
        return searchTitleView
    }()
    
    // 排序按钮
    lazy var sortItemButton: UIBarButtonItem = {
        let sortItemButton = UIBarButtonItem(image: UIImage(named: "common_sort_button_normal_iPhone"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(screenInfo(sender:)))
        return sortItemButton
    }()
}

extension ShowroomNaviViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        flag = 2
        
        currentIndex = Int(scrollView.contentOffset.x) / Int(kScreen_width)
        navTabBar.currentIndex = currentIndex!
        
        /** 当scrollview滚动的时候加载当前视图 */
        let viewController = subViewControllers?[currentIndex!]
        viewController?.view.frame = CGRect(x: CGFloat(currentIndex!) * kScreen_width, y: 0, width: kScreen_width, height: mainView.frame.size.height)
        mainView.addSubview(viewController!.view)
        self.addChildViewController(viewController!)
    }
}
extension ShowroomNaviViewController: SYNavTabBarDelegate {
    func itemDidSelected(index: NSInteger, currentIndex: NSInteger) {
        if currentIndex-index > 3 || currentIndex-index < -3 {
            mainView.contentOffset = CGPoint(x: CGFloat(index) * kScreen_width, y: 0)
        }else{
            mainView.setContentOffset(CGPoint(x: CGFloat(index) * kScreen_width, y: 0), animated: false)
        }
    }
}

extension ShowroomNaviViewController: YBPopupMenuDelegate {
    func ybPopupMenuDidSelected(at index: Int, ybPopupMenu: YBPopupMenu!) {
        
        let viewController = subViewControllers?[currentIndex!] as! ShowRoomViewController
        viewController.order = "\(index + 1)"
        viewController.loadShowRoomData(requestType: .update)
    }
}

extension ShowroomNaviViewController: navTitleViewDelegate {
    func searchYouWant() {
        navigationController?.pushViewController(searchViewController, animated: false)
        
        NetRequest.hotSearchNetRequest() { (success, info, hotSearches) in
            if success {
                self.searchViewController.hotSearches = hotSearches
            }
        }
    }
}
