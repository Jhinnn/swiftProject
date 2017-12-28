//
//  AttentionViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class AttentionViewController: BaseViewController {

    // 存放控制器的数组
    var subViewControllers: [BaseViewController]?
    // 当前所在控制器的索引
    var currentIndex: NSInteger?
    // 分页导航上的title数组
    var titles: [String]?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initControl()
        viewConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        navigationController?.navigationBar.isHidden = true
//    }
    
    // MARK: - private method
    // 初始化控件信息
    private func initControl() {
        
        // 视图控制器的设置
        let topicView = AttentionTopicViewController()
        let newsView = AttentionNewsViewController()
        let roomView = AttentionRoomViewController()
        let ticketView = AttentionTicketViewController()
        let personView = AttentionPersonViewController()
        
        
        if deviceTypeIphone5() || deviceTypeIPhone4() {
            topicView.title = "    话题"
        } else {
            topicView.title = "话题"
        }
        newsView.title = "资讯"
        roomView.title = "发现"
        ticketView.title = "票务"
        personView.title = "关注的人"

        // 添加到控制器数组
        subViewControllers = [topicView,newsView,roomView,ticketView,personView]
        
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
        mainView.contentSize = CGSize(width: kScreen_width*CGFloat(subViewControllers!.count), height: 0)
        view.addSubview(mainView)
    }
    // 初始化视图
    private func viewConfig() {
        self.title = "我的关注"
        layoutPageSubviews()
        
        //添加视图控制器
        let viewController = subViewControllers?[currentIndex!]
        viewController?.view.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height)
        
        mainView.addSubview(viewController!.view)
        self.addChildViewController(viewController!)
    }
    
    private func layoutPageSubviews() {
        navTabBar.snp.makeConstraints { (make) in
            make.top.equalTo(view)
//            make.centerX.equalTo(view)
            if deviceTypeIphone5() || deviceTypeIPhone4() {
               make.width.equalTo(kScreen_width)
            } else {
                make.width.equalTo(kScreen_width)
            }
            make.height.equalTo(42)
        }
        

    }
    
    // MARK: - event response

    // MARK: - setter and getter
    lazy var navTabBar: SYNavTabBar = {
        let navTabBar = SYNavTabBar(frame: .zero)
        navTabBar.delegate = self
        navTabBar.backgroundColor = UIColor.vcBgColor
        navTabBar.navTabBarHeight = 42
        navTabBar.buttonTextColor = UIColor.black
        navTabBar.line?.isHidden = true
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
}

extension AttentionViewController: UIScrollViewDelegate {
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
extension AttentionViewController: SYNavTabBarDelegate {
    func itemDidSelected(index: NSInteger, currentIndex: NSInteger) {
        mainView.contentOffset = CGPoint(x: CGFloat(index) * kScreen_width, y: 0)
    }
}
