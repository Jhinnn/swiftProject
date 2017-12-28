//
//  MyFriendsViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class MyFriendsViewController: BaseViewController {
    
    // 存放控制器的数组
    var subViewControllers: [UIViewController]?
    // 当前所在控制器的索引
    var currentIndex: NSInteger?
    // 分页导航上的title数组
    var titles: [String]?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initControl()
        viewConfig()
        layoutPageSubviews()
    }
    
    // MARK: - private method
    // 初始化控件信息
    func initControl() {
        
        // 视图控制器的设置
        let chatView = ChatViewController()
        chatView.title = "聊天"
        let groupView = GroupsViewController()
        groupView.title = "群组"
        let contactView = ContactsViewController()
        contactView.title = "通讯录"
        // 添加到控制器数组
        subViewControllers = [chatView,groupView,contactView]
        
        // 视图控制器索引和标题的设置
        currentIndex = 0
        navTabBar.currentIndex = currentIndex!
        // 初始化标题数组
        titles = [String]()
        for viewC in subViewControllers! {
            titles?.append(viewC.title!)
        }
        // 将标题数组赋给分页导航的数组
        navTabBar.itemTitles = titles
        // 刷新数据
        navTabBar.updateData()
        view.addSubview(navTabBar)
        // 设置控制器的尺寸
        mainView.contentSize = CGSize(width: kScreen_width * CGFloat(subViewControllers!.count), height: 0)
        view.addSubview(mainView)
    }
    // 初始化视图
    func viewConfig() {
        self.title = "我的好友"
        initWithNavgationBar()
        
        //添加视图控制器
        let viewController = subViewControllers?[currentIndex!]
        viewController?.view.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height)
        
        mainView.addSubview(viewController!.view)
        self.addChildViewController(viewController!)
    }
    
    // 初始化导航条
    func initWithNavgationBar() {
        
        let searchBarButton = UIBarButtonItem(image: UIImage(named: "common_whiteSearch_button_normal_iPhone"), style: .done, target: self, action: #selector(searchFriends(sender:)))
        let addBarButton = UIBarButtonItem(image: UIImage(named: "mine_addFriends_button_normal_iPhone"), style: .done, target: self, action: #selector(addFriends(sender:)))
        navigationItem.rightBarButtonItems = [addBarButton,searchBarButton]

    }
    func layoutPageSubviews() {
        navTabBar.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(0)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.height.equalTo(42)
        }
    }
    
    // MARK: - event response
    func searchFriends(sender: UIBarButtonItem) {
        navigationController?.pushViewController(SearchFriendsViewController(), animated: true)
    }
    func addFriends(sender: UIBarButtonItem) {
        let x = UIScreen.main.bounds.size.width - 20
        let y = CGFloat(78)
        let p = CGPoint(x: x, y: y)
        LSXPopMenu.show(at: p, titles: ["扫一扫","添加好友"], icons: ["",""], menuWidth: 100, isShowTriangle: false, delegate: self as LSXPopMenuDelegate)
        //原来的代码，暂时注释掉
//        navigationController?.pushViewController(ContactsFriendsViewController(), animated: true)
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
        mainView.isScrollEnabled = false
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        self.view.addSubview(mainView)
        return mainView
    }()
    // 导航条上的item设置
    lazy var searchItem: UIBarButtonItem = {
        let searchItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchFriends(sender:)))
        searchItem.tintColor = UIColor.black
        return searchItem
    }()
    lazy var addItem: UIBarButtonItem = {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(searchFriends(sender:)))
        addItem.tintColor = UIColor.black
        return addItem
    }()
}


extension MyFriendsViewController: UIScrollViewDelegate {
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
extension MyFriendsViewController: SYNavTabBarDelegate {
    func itemDidSelected(index: NSInteger, currentIndex: NSInteger) {
        if currentIndex-index > 3 || currentIndex-index < -3 {
            mainView.contentOffset = CGPoint(x: CGFloat(index) * kScreen_width, y: 0)
        }else{
            mainView.setContentOffset(CGPoint(x: CGFloat(index) * kScreen_width, y: 0), animated: false)
        }
    }
}
//点击扫一扫添加好友
extension MyFriendsViewController:LSXPopMenuDelegate{
    func lsxPopupMenuDidSelected(at index: Int, lsxPopupMenu LSXPopupMenu: LSXPopMenu!) {
        if index == 1 {
            navigationController?.pushViewController(AddFriendsViewController(), animated: true)
        }else{
            navigationController?.pushViewController(ScanOneScanViewController(), animated: true)
        }
//        navigationController?.pushViewController(ContactsFriendsViewController(), animated: true)
    }
}
