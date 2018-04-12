//
//  TopicsViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class TopicsViewController: BaseViewController {
    
    var titleName: String?
    
    var targId: String?
    
    var dataList = [TopicsFrameModel]()
    
    var newsData = [MineTopicsModel]()
    
    var headerView: TopicHeaderView?
    
    //add
    // 存放控制器的数组
    var subViewControllers: [BaseViewController]?
    // 当前所在控制器的索引
    var currentIndex: NSInteger?
    // 分页导航上的title数组
    var titles: [String]?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.targId == AppInfo.shared.user?.userId {
            title = "我的话题"
            let releaseBtn = UIBarButtonItem(title: "发布", style: .done, target: self, action: #selector(releaseDynamic))
            navigationItem.rightBarButtonItem = releaseBtn
            
            let roomView = AttentionTopicViewController()
            roomView.type = 1
            let ticketView = TopicsMeViewController()
            ticketView.targId = self.targId
            let personView = TopicAnswerViewController()
            personView.targId = self.targId
            
            roomView.title = "我关注的话题"
            ticketView.title = "我提问的话题"
            personView.title = "我回答的话题"
            
            // 添加到控制器数组
            subViewControllers = [roomView,ticketView,personView]
            
        }else {
            title = self.titleName! + "的话题"
            
            
            let ticketView = TopicsMeViewController()
            ticketView.targId = self.targId
            let personView = TopicAnswerViewController()
            personView.targId = self.targId
            ticketView.title = "他提出的话题"
            personView.title = "他回答的话题"
            
            // 添加到控制器数组
            subViewControllers = [ticketView,personView]
            
        }
    
        self.headerView = Bundle.main.loadNibNamed("TopicHeaderView", owner: nil, options: nil)?.first as? TopicHeaderView
        self.view.addSubview(self.headerView!)

//        //加载头部视图
        loadHeadData()
        
        self.headerView?.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(128)
        })
        

       
        
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
        
        viewConfig()
    }
    
    //add
    
    // 初始化视图
    private func viewConfig() {
        
        
        
        //添加视图控制器
        let viewController = subViewControllers?[currentIndex!]
        viewController?.view.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height - 128 - 42 - 20)
        
        mainView.addSubview(viewController!.view)
        self.addChildViewController(viewController!)
        
        
    }
  

    
    // MARK: - event response
    
    // MARK: - setter and getter
    lazy var navTabBar: SYNavTabBar = {
        let navTabBar = SYNavTabBar(frame:CGRect(x: 0, y: 128, width: kScreen_width, height: 42) )
        navTabBar.navigationTabBar.contentSize = CGSize(width: 0, height: kScreen_width)
        
        navTabBar.delegate = self
        navTabBar.backgroundColor = UIColor.white
        navTabBar.navTabBarHeight = 42
        navTabBar.buttonTextColor = UIColor.gray
        navTabBar.line?.isHidden = false
        navTabBar.lineColor = UIColor.red
        return navTabBar
    }()
    // 下面的控制器
    lazy var mainView: UIScrollView = {
        let mainView = UIScrollView(frame: CGRect(x: 0, y: 42 + 128, width: kScreen_width, height: kScreen_height - 128 - 42 - 20))
        mainView.delegate = self
        mainView.isPagingEnabled = true
        mainView.bounces = false
        mainView.isScrollEnabled = false
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        return mainView
    }()
    
    func loadHeadData() {
        NetRequest.myNewTopicMsgListNetRequest(page: "1", token: AppInfo.shared.user?.token ?? "",uid: self.targId!) { (success, info, dic) in
            if success {
                let imageStr = dic?["avatar"] as! String
                let imageUrl = URL(string: imageStr)
                self.headerView?.imageVie.kf.setImage(with: imageUrl)
                
                self.headerView?.titleLabel.text = dic?["nickname"] as? String
                self.headerView?.textLabel.text = dic?["signature"] as? String
            }
        }
    }

    
    func releaseDynamic() {
       navigationController?.pushViewController(PublicGroupOneViewController(), animated: true)
    }
    

}



extension TopicsViewController: UIScrollViewDelegate {
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
extension TopicsViewController: SYNavTabBarDelegate {
    func itemDidSelected(index: NSInteger, currentIndex: NSInteger) {
        mainView.contentOffset = CGPoint(x: CGFloat(index) * kScreen_width, y: 0)
    }
}


