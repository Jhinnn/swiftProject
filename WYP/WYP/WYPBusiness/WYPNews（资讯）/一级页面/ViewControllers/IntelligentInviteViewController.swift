//
//  IntelligentInviteViewController.swift
//  WYP
//
//  Created by Arthur on 2018/2/2.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class IntelligentInviteViewController: BaseViewController {

    var new_id: String?
    
    // 存放控制器的数组
    var subViewControllers: [BaseViewController]?
    // 当前所在控制器的索引
    var currentIndex: NSInteger?
    // 分页导航上的title数组
    var titles: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        title = "邀请回答"
        
        let teInviteVC = TelentInviteViewController()
        teInviteVC.new_id = self.new_id
        teInviteVC.title = "达人榜"

        let friInviteVC = FriendInviteViewController()
        friInviteVC.new_id = self.new_id
        friInviteVC.title = "通讯录"
        
        subViewControllers = [teInviteVC,friInviteVC]
        
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
        navTabBar.updateData()
        view.addSubview(navTabBar)
        // 设置控制器的尺寸
        mainView.contentSize = CGSize(width: kScreen_width*CGFloat(subViewControllers!.count), height: 0)
        view.addSubview(mainView)
        
        
        viewConfig()
    }
    
    // 初始化视图
    private func viewConfig() {
        //添加视图控制器
        let viewController = subViewControllers?[currentIndex!]
        viewController?.view.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height - 45)
        
        mainView.addSubview(viewController!.view)
        self.addChildViewController(viewController!)
        
        
    }
    
    
    // MARK: - setter and getter
    lazy var navTabBar: SYNavTabBar = {
        let navTabBar = SYNavTabBar(frame:CGRect(x: (kScreen_width - 15 - 130) / 2, y: 0, width: 130, height: 45) )        
        navTabBar.delegate = self
        navTabBar.backgroundColor = UIColor.white
        navTabBar.navTabBarHeight = 45
        navTabBar.buttonTextColor = UIColor.black
        navTabBar.line?.isHidden = false
        navTabBar.lineColor = UIColor.red
        return navTabBar
    }()
    // 下面的控制器
    lazy var mainView: UIScrollView = {
        let mainView = UIScrollView(frame: CGRect(x: 0, y: 45, width: kScreen_width, height: kScreen_height - 45))
        mainView.isPagingEnabled = true
        mainView.delegate = self
        mainView.bounces = false
        mainView.isScrollEnabled = false
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        return mainView
    }()
    

    
    
}

extension IntelligentInviteViewController: UIScrollViewDelegate {
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


extension IntelligentInviteViewController: SYNavTabBarDelegate {
    func itemDidSelected(index: NSInteger, currentIndex: NSInteger) {
        mainView.contentOffset = CGPoint(x: CGFloat(index) * kScreen_width, y: 0)
    }
}
