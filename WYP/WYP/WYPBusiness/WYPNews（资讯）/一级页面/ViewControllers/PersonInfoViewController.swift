//
//  MyAnswerQViewController.swift
//  WYP
//
//  Created by aLaDing on 2018/3/19.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PersonInfoViewController: UIViewController {
    
    
    // 存放控制器的数组
    var subViewControllers: [BaseViewController]?
    // 当前所在控制器的索引
    var currentIndex: NSInteger?
    // 分页导航上的title数组
    var titles: [String]?
    
    var targId: String?
    
    var headerView: PersonInfoHeadView?
    
    
    // 记录偏移量
    var navOffset: CGFloat = 0
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "我的问答"
        
        self.navBarBgAlpha = 0
        
   
        viewConfig()
        
        let roomView = MyAqCollectionViewController()
        let ticketView = MyAqProposeViewController()
        let personView = MyAqAnswerViewController()
        
        
        roomView.title = "收藏"
        ticketView.title = "提问"
        personView.title = "回答"
        
        // 添加到控制器数组
        subViewControllers = [roomView,ticketView,personView]
        
        
        self.headerView = Bundle.main.loadNibNamed("PersonInfoHeadView", owner: nil, options: nil)?.first as? PersonInfoHeadView
        mainsView.addSubview(self.headerView!)
        
        self.headerView?.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(360)
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
        mainsView.addSubview(navTabBar)
        // 设置控制器的尺寸
        mainView.contentSize = CGSize(width: kScreen_width*CGFloat(subViewControllers!.count), height: 0)
        mainsView.addSubview(mainView)
        
        //添加视图控制器
        let viewController = subViewControllers?[currentIndex!]
        viewController?.view.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height - 360 - 42 - 35)
        
        mainView.addSubview(viewController!.view)
        self.addChildViewController(viewController!)
        
//        loadData()
    }
//
//    func loadData() {
//        let parameters: Parameters = ["access_token": access_token,
//                                      "method": "GET",
//                                      "uid" : AppInfo.shared.user?.userId ?? ""
//        ]
//        Alamofire.request(kApi_TopicHeadData, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
//            switch response.result {
//            case .success:
//                let json = JSON(response.result.value!)
//                // 获取code码
//                let code = json["code"].intValue
//                // 获取info信息
//
//                if code == 400 {
//
//                } else {
//                    // 获取数据
//                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
//
//                    self.headerView?.readLabel.text = String.init(format: "回答获%@人阅读", dic?["view_num"] as! String)
//                    self.headerView?.monthReadLabel.text = String.init(format: "本月共%@人浏览", dic?["view_num_month"] as! String)
//                    self.headerView?.zanLabel.text = String.init(format: "回答获%@人点赞", dic?["fabulous_num"] as! String)
//                    self.headerView?.monthZanLabel.text = String.init(format: "本月共%@人点赞", dic?["fabulous_num_month"] as! String)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//
    //add
    
    // 初始化视图
    private func viewConfig() {
        
        view.addSubview(mainsView)
        mainsView.snp.makeConstraints { (make) in
            if deviceTypeIPhoneX() {
                make.top.equalTo(view).offset(-88)
            }else {
                make.top.equalTo(view).offset(-64)
            }
            
            make.left.right.equalTo(view)
            make.bottom.equalTo(self.view)
        }
        
       
        
        
    }
    
    
    // MARK: - setter and getter
    lazy var navTabBar: SYNavTabBar = {
        let navTabBar = SYNavTabBar(frame:CGRect(x: 0, y: 360, width: kScreen_width, height: 42) )
        navTabBar.navigationTabBar.contentSize = CGSize(width: 0, height: kScreen_width)
        
        navTabBar.delegate = self
        navTabBar.backgroundColor = UIColor.white
        navTabBar.navTabBarHeight = 42
        navTabBar.buttonTextColor = UIColor.gray
        navTabBar.line?.isHidden = true
        navTabBar.lineColor = UIColor.red
        return navTabBar
    }()
    
    
    // 下面的控制器
    lazy var mainsView: UIScrollView = {
        let mainView = UIScrollView()
        mainView.delegate = self
        mainView.isPagingEnabled = true
        mainView.bounces = false
        mainView.isScrollEnabled = false
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        return mainView
    }()
    
    
    // 下面的控制器
    lazy var mainView: UIScrollView = {
        let mainView = UIScrollView(frame: CGRect(x: 0, y: 42 + 360, width: kScreen_width, height: kScreen_height - 360 - 42 - 35))
        mainView.delegate = self
        mainView.isPagingEnabled = true
        mainView.bounces = false
        mainView.isScrollEnabled = false
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        return mainView
    }()
    


    
}

extension PersonInfoViewController: UIScrollViewDelegate {
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
extension PersonInfoViewController: SYNavTabBarDelegate {
    func itemDidSelected(index: NSInteger, currentIndex: NSInteger) {
        mainView.contentOffset = CGPoint(x: CGFloat(index) * kScreen_width, y: 0)
    }
}

