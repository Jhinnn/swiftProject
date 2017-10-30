//
//  SearchResultNaviViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/10.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import ReachabilitySwift

class SearchResultNaviViewController: BaseViewController {

    // 存放控制器的数组
    var subViewControllers: [BaseViewController]?
    // 当前所在控制器的索引
    var currentIndex: NSInteger? {
        willSet {
            navTabBar.currentIndex = newValue!
            if subViewControllers != nil {
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
    
    
    // MARK: - private method
    // 初始化控件信息
    private func initControl() {
        // 视图控制器索引和标题的设置
        currentIndex = 0
        navTabBar.currentIndex = currentIndex!
        // 初始化标题数组
        titles = ["全部","资讯","发现","抢票"]
        // 将标题数组赋给分页导航的数组
        navTabBar.itemTitles = titles
        // 刷新数据
        navTabBar.updateData()
        view.addSubview(navTabBar)
        
        // 添加到控制器数组
        // 全部
        let searchResult = SearchResultViewController()
        searchResult.keyword = searchView.searchTextField.text
        searchResult.delegate = self
        // 资讯
        let news = SearchHomeNewsViewController()
        news.keyword = searchView.searchTextField.text
        // 展厅
        let showRoom = ShowRoomViewController()
        showRoom.flag = 2
        showRoom.keyword = searchView.searchTextField.text
        showRoom.isShowBanner = false
        // 票务
        let ticket = SearchHomeTicketsViewController()
        ticket.keyword = searchView.searchTextField.text
        subViewControllers = [searchResult,news,showRoom,ticket]
        
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
        if index == 0 {
            let viewController = subViewControllers?[index] as! SearchResultViewController
            viewController.keyword = searchView.searchTextField.text
            viewController.loadData()
        } else if index == 1 {
            let viewController = subViewControllers?[index] as! SearchHomeNewsViewController
            viewController.keyword = searchView.searchTextField.text
            viewController.loadSearchResult(requestType: .update)
        } else if index == 2 {
            let viewController = subViewControllers?[index] as! ShowRoomViewController
            viewController.flag = 2
            viewController.keyword = searchView.searchTextField.text
            viewController.loadShowRoomData(requestType: .update)
        } else if index == 3 {
            let viewController = subViewControllers?[index] as! SearchHomeTicketsViewController
            viewController.keyword = searchView.searchTextField.text
            viewController.loadDataSource(requestType: .update)
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

extension SearchResultNaviViewController: UIScrollViewDelegate {
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
extension SearchResultNaviViewController: SYNavTabBarDelegate {
    func itemDidSelected(index: NSInteger, currentIndex: NSInteger) {
        if currentIndex-index > 3 || currentIndex-index < -3 {
            mainView.contentOffset = CGPoint(x: CGFloat(index) * kScreen_width, y: 0)
        }else{
            mainView.setContentOffset(CGPoint(x: CGFloat(index) * kScreen_width, y: 0), animated: false)
        }
    }
}

extension SearchResultNaviViewController: SearchResultViewControllerDelegate {
    func showMoreNews(sender: UIButton) {
        switch sender.tag {
        case 0:
            currentIndex = 3
            
        case 1:
            currentIndex = 1
            
        case 2:
            currentIndex = 2
        default:
            break
        }
    }
}

extension SearchResultNaviViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let index = currentIndex! - 1 < 0 ? 0 : currentIndex!
        if index == 0 {
            let viewController = subViewControllers?[index] as! SearchResultViewController
            viewController.keyword = searchView.searchTextField.text
            viewController.loadData()
        } else if index == 1 {
            let viewController = subViewControllers?[index] as! SearchHomeNewsViewController
            viewController.keyword = searchView.searchTextField.text
            viewController.loadSearchResult(requestType: .update)
        } else if index == 2 {
            let viewController = subViewControllers?[index] as! ShowRoomViewController
            viewController.flag = 2
            viewController.keyword = searchView.searchTextField.text
            viewController.loadShowRoomData(requestType: .update)
        } else if index == 3 {
            let viewController = subViewControllers?[index] as! SearchHomeTicketsViewController
            viewController.keyword = searchView.searchTextField.text
            viewController.loadDataSource(requestType: .update)
        }
        return true
    }
}
