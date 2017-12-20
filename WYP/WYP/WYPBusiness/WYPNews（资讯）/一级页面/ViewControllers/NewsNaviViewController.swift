 
//
//  NewsNaviViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/2/24.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import Alamofire

class NewsNaviViewController: BaseViewController {

    // 标记是否是刚进来
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
    
    // MARK: - life cycle
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
        currentIndex = newsCurrentIndex
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        newsCurrentIndex = currentIndex!
    }
    
    // MARK: - private method
    // 初始化控件信息
    func initControl() {
        
        // 视图控制器索引和标题的设置
        currentIndex = newsCurrentIndex
        
        var viewArray = [BaseViewController]()
        // 添加到控制器数组
        for i in 0..<2 {
            let news = NewsViewController()
            if i == 0 {
                news.isShowBanner = true
                news.newsType = "1"
            } else {
                news.isShowBanner = false
                news.newsType = "2"
            }
            viewArray.append(news)
        }
        let photos = NewsPhotosViewController()
        let videos = NewsVideosViewController()
        viewArray.append(photos)
        viewArray.append(videos)
        
        for j in 0..<7  {
            let news = NewsViewController()
            news.newsType = "\(j + 5)"
            news.isShowBanner = false
            viewArray.append(news)
        }
        
        let tallk = TallkViewController()
        tallk.newsType = "12"
        viewArray.append(tallk)
        
        subViewControllers = viewArray
        
        //添加视图控制器
        let viewController = subViewControllers?[currentIndex!]
        viewController?.view.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height)
        
        mainView.addSubview(viewController!.view)
        self.addChildViewController(viewController!)
        // 设置控制器的尺寸
        mainView.contentSize = CGSize(width: kScreen_width*CGFloat(subViewControllers!.count), height: 0)
        
        // 初始化标题数组
        titles = ["推荐","热点","图集","视频","人物","现场","演出","旅游","赛事","会展","电影","话题"]
        // 将标题数组赋给分页导航的数组
        navTabBar.itemTitles = titles
        // 刷新数据
        navTabBar.updateData()
    
        view.addSubview(navTabBar)
        
    }
    // 初始化视图
    func viewConfig() {
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
    }
    lazy var searchViewController: PYSearchViewController = {
        let hotSearchArray = ["赵薇黄晓明","农村老太","盆景艺术","棉麻棉衣","共享单车","你好2017","赵薇黄晓明","农村老太","盆景艺术","棉麻棉衣","共享单车","你好2017"]
        
        let searchViewController = PYSearchViewController(hotSearches: hotSearchArray, searchBarPlaceholder: "可输入关键词，查看最新最热动态") { (searchViewController, searchBar, searchText) in
            let result = NewsSearchResultViewController()
            result.searchView.searchTextField.text = searchText
            self.navigationController?.pushViewController(result, animated: true)
        }
        searchViewController?.hotSearchStyle = .rankTag
        searchViewController?.searchHistoryStyle = .normalTag
//        searchViewController?.cancelButton = UIBarButtonItem(title: "搜索", style: .done, target: self, action: #selector(searchButtonAction))
        
        let searchBtn = UIButton(type: .custom)
        searchBtn.setTitle("搜索", for: .normal)
        searchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        searchBtn.setTitleColor(UIColor.white, for: .normal)
        searchBtn.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
        searchViewController?.cancelButton = UIBarButtonItem(customView: searchBtn)
    
   
        
//        searchViewController?.naviItemHidesBackButton = true
        
        return searchViewController!
    }()
    
    // MARK: - event response
    // 搜索框取消按钮点击事件
    func searchButtonAction() {
        if searchViewController.searchBar.text == "" {
            SYAlertController.showAlertController(view: self, title: "提示", message: "搜索内容不能为空")
            return
        }
        let result = NewsSearchResultViewController()
        result.searchView.searchTextField.text = searchViewController.searchBar.text
        self.navigationController?.pushViewController(result, animated: true)
    }
    
    
    
    // MARK: - setter and getter
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
    
    lazy var searchTitleView: AdvisorySearchTitleView = {
        let searchTitleView = AdvisorySearchTitleView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 34))
        searchTitleView.delegate = self
        return searchTitleView
    }()
    
}

extension NewsNaviViewController: UIScrollViewDelegate {
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
extension NewsNaviViewController: SYNavTabBarDelegate {
    func itemDidSelected(index: NSInteger, currentIndex: NSInteger) {
        if currentIndex-index > 3 || currentIndex-index < -3 {
            mainView.contentOffset = CGPoint(x: CGFloat(index) * kScreen_width, y: 0)
        } else {
            mainView.setContentOffset(CGPoint(x: CGFloat(index) * kScreen_width, y: 0), animated: false)
        }
    }
}
 
extension NewsNaviViewController: navTitleViewDelegate {
    func searchYouWant() {
        navigationController?.pushViewController(searchViewController, animated: false)
        
        NetRequest.hotSearchNetRequest() { (success, info, hotSearches) in
            if success {
                self.searchViewController.hotSearches = hotSearches
            }
        }
    }
}

