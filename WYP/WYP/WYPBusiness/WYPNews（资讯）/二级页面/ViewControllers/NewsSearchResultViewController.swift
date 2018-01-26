//
//  NewsSearchResultViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import ReachabilitySwift

class NewsSearchResultViewController: BaseViewController {

    // 存放控制器的数组
    var subViewControllers: [BaseViewController]?
    // 当前所在控制器的索引
    var currentIndex: NSInteger?
    // 分页导航上的title数组
    var titles: [String]?
    // 分类id
    var typeId: String?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkStatusListener()
        
        initControl()
        viewConfig()
        layoutPageSubviews()
        
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
    
    // 移除消息通知
    deinit {
        // 关闭网络状态消息监听
        reachability.stopNotifier()
        // 移除网络状态消息通知
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    // 主动检测网络状态
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            print("网络连接：可用")
            if reachability.isReachableViaWiFi {
                print("连接类型：WiFi")
            } else {
                print("连接类型：移动网络")
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
    
    
    // MARK: - private
    private func initControl() {
        // 视图控制器索引和标题的设置
        currentIndex = 0
        navTabBar.currentIndex = currentIndex!
        // 初始化标题数组
        titles = ["全部","推荐","热点","图集","视频","人物","现场","演出","旅游","赛事","会展","电影","话题"]
        // 将标题数组赋给分页导航的数组
        navTabBar.itemTitles = titles
        // 刷新数据
        navTabBar.updateData()
        view.addSubview(navTabBar)
        
        var viewArray = [BaseViewController]()
        // 添加到控制器数组
        for i in 0..<3 {
            let news = NewsViewController()
            news.isShowBanner = false
            news.flag = 2
            news.keyword = searchView.searchTextField.text
            news.newsType = "\(i)"
            viewArray.append(news)
        }
        let photos = NewsPhotosViewController()
        photos.flag = 2
        photos.keyword = searchView.searchTextField.text
        let videos = NewsVideosViewController()
        videos.flag = 2
        videos.keyword = searchView.searchTextField.text
        viewArray.append(photos)
        viewArray.append(videos)
        
        for j in 0..<7  {
            let news = NewsViewController()
            news.flag = 2
            news.keyword = searchView.searchTextField.text
            news.newsType = "\(j + 5)"
            news.isShowBanner = false
            viewArray.append(news)
        }
        
        let topic = SearchHomeTopicsViewController()
//        topic.flag = 2
        topic.keyword = searchView.searchTextField.text
        viewArray.append(topic)
        subViewControllers = viewArray
        
        // 设置控制器的尺寸
        mainView.contentSize = CGSize(width: kScreen_width*CGFloat(subViewControllers!.count), height: 0)
        
    }
    
    // 初始化视图
    private func viewConfig() {
        
        view.backgroundColor = UIColor.init(hexColor: "fafafa")
        
        //添加视图控制器
        let viewController = subViewControllers?[currentIndex!]
        viewController?.view.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height)
        
        mainView.addSubview(viewController!.view)
        self.addChildViewController(viewController!)
        
        // 添加搜索
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.titleView = searchView
    }
    
    private func layoutPageSubviews() {
        navTabBar.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(0)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.height.equalTo(42)
        }
    }

    // MARK: - event response
    func clickSearchButton(sender: UIBarButtonItem) {
        let index = currentIndex! - 1 < 0 ? 0 : currentIndex!
        if index == 3 {
            let viewController = subViewControllers?[index] as! NewsPhotosViewController
            viewController.keyword = searchView.searchTextField.text
            viewController.loadNewsData(requestType: .update)
        } else if index == 4 {
            let viewController = subViewControllers?[index] as! NewsVideosViewController
            viewController.keyword = searchView.searchTextField.text
            viewController.loadNewsData(requestType: .update)
        } else if index == 12 {
            let viewController = subViewControllers?[index] as! SearchHomeTopicsViewController
            viewController.keyword = searchView.searchTextField.text
            viewController.loadSearchResult(requestType: .update)
            
        } else {
            let viewController = subViewControllers?[index] as! NewsViewController
            viewController.keyword = searchView.searchTextField.text
            viewController.loadNewsData(requestType: .update)
        }
    }
    func whenTextFieldValueChange() {
        if (searchView.searchTextField.text?.characters.count)! < 1 {
            navigationController?.popViewController(animated: true)
        }
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
        let mainView = UIScrollView(frame: CGRect(x: 0, y: 42, width: kScreen_width, height: kScreen_height))
        mainView.delegate = self
        mainView.isPagingEnabled = true
        mainView.bounces = false
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        self.view.addSubview(mainView)
        return mainView
    }()
    
    lazy var searchView: SearchTitleView = {
        let searchView = SearchTitleView(frame: CGRect(x: 0, y: 0, width: kScreen_width - 110, height: 30))
        searchView.searchTextField.delegate = self
        return searchView
    }()
    
    lazy var rightBarButtonItem: UIBarButtonItem = {
        let rightBarButtonItem = UIBarButtonItem(title: "搜索", style: .done, target: self, action: #selector(clickSearchButton(sender:)))
        return rightBarButtonItem
    }()

}

extension NewsSearchResultViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x) / Int(kScreen_width)
        navTabBar.currentIndex = currentIndex!
        
        /** 当scrollview滚动的时候加载当前视图 */
        let viewController = subViewControllers?[currentIndex!];
        viewController?.view.frame = CGRect(x: CGFloat(currentIndex!) * kScreen_width, y: 0, width: kScreen_width, height: mainView.frame.size.height)
        mainView.addSubview(viewController!.view)
        self.addChildViewController(viewController!)
    }
}
extension NewsSearchResultViewController: SYNavTabBarDelegate {
    func itemDidSelected(index: NSInteger, currentIndex: NSInteger) {
        if currentIndex-index > 3 || currentIndex-index < -3 {
            mainView.contentOffset = CGPoint(x: CGFloat(index) * kScreen_width, y: 0)
        }else{
            mainView.setContentOffset(CGPoint(x: CGFloat(index) * kScreen_width, y: 0), animated: false)
        }
    }
}

extension NewsSearchResultViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let index = currentIndex! - 1 < 0 ? 0 : currentIndex!
        if index == 3 {
            let viewController = subViewControllers?[index] as! NewsPhotosViewController
            viewController.keyword = searchView.searchTextField.text
            viewController.loadNewsData(requestType: .update)
        } else if index == 4 {
            let viewController = subViewControllers?[index] as! NewsVideosViewController
            viewController.keyword = searchView.searchTextField.text
            viewController.loadNewsData(requestType: .update)
        } else if index == 12 {
            let viewController = subViewControllers?[index] as! SearchHomeTopicsViewController
            viewController.keyword = searchView.searchTextField.text
            viewController.loadSearchResult(requestType: .update)
        } else {
            let viewController = subViewControllers?[index] as! NewsViewController
            viewController.keyword = searchView.searchTextField.text
            viewController.loadNewsData(requestType: .update)
        }
        return true
    }
}
