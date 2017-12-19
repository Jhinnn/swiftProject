//
//  TicketBaseNaviViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/2.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class TicketBaseNaviViewController: BaseViewController {

    // 存放控制器的数组
    var subViewControllers: [TicketsShowViewController]?
    // 当前所在控制器的索引
    var currentIndex: NSInteger?
    // 分页导航上的title数组
    var titles: [String]?
    // 二级分类
    var classPid: String?
    // 二级分类id
    var classId: [String]?
    // 一级分类
    var type: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let cityName = UserDefaults.standard.object(forKey: "cityName")
        leftBarButton.setTitle(cityName as? String ?? "北京", for: .normal)
    }
    
    // MARK: - Private Methods
    // 初始化控件信息
    func initControl() {
        // 视图控制器索引和标题的设置
        currentIndex = 0
        navTabBar.currentIndex = currentIndex!
        // 将标题数组赋给分页导航的数组
        navTabBar.itemTitles = titles
        // 刷新数据
        navTabBar.updateData()
        view.addSubview(navTabBar)
        
        var viewArray = [TicketsShowViewController]()
        // 添加到控制器数组
        for i in 0..<titles!.count {
            let ticket = TicketsShowViewController()
            if i == 0 {
                ticket.classPid = classPid
                ticket.classId = ""
            } else {
                ticket.classPid = ""
                ticket.classId = classId?[i] ?? ""
            }
            ticket.typeId = type
            viewArray.append(ticket)
        }
        subViewControllers = viewArray
        
        // 设置控制器的尺寸
        mainView.contentSize = CGSize(width: kScreen_width*CGFloat(subViewControllers!.count), height: 0)
    }
    
    func viewConfig() {
        
        //添加视图控制器
        let viewController = subViewControllers?[currentIndex!]
        viewController?.view.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height)
        
        mainView.addSubview(viewController!.view)
        self.addChildViewController(viewController!)
        
        view.addSubview(searchView)
        searchView.addSubview(leftBarButton)
        searchView.addSubview(searchTextField)
        searchView.addSubview(searchButton)
    }
    func layoutPageSubviews() {
        
        // 搜索
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(0)
            make.left.right.equalTo(view)
            make.height.equalTo(36)
        }
        leftBarButton.snp.makeConstraints { (make) in
            make.left.equalTo(searchView).offset(13 * width_height_ratio)
            make.centerY.equalTo(searchView)
            make.size.equalTo(CGSize(width: 65, height: 30))
        }
        searchButton.snp.makeConstraints { (make) in
            make.right.equalTo(searchView).offset(-13)
            make.centerY.equalTo(searchView)
            make.size.equalTo(CGSize(width: 13, height: 13))
        }
        searchTextField.snp.makeConstraints { (make) in
            make.right.equalTo(searchButton.snp.left).offset(-10)
            make.centerY.equalTo(searchView)
            make.size.equalTo(CGSize(width: 217.5 * width_height_ratio, height: 29))
        }
        
        navTabBar.snp.makeConstraints { (make) in
            make.top.equalTo(searchView.snp.bottom).offset(1)
            make.left.right.equalTo(view)
            make.height.equalTo(42)
        }
        
    }
    
    // MARK: - event response
    // 城市选择按钮响应事件
    func  chooseCity(sender: UIButton) {
        let cityView = CityListViewController()
        cityView.locationCityArray = ["北京"]
        navigationController?.pushViewController(cityView, animated: true)
    }
    // 点击搜索
    func searchTicket(sender: UIButton) {
        let index = currentIndex! - 1 < 0 ? 0 : currentIndex!
        let viewController = subViewControllers?[index]
        viewController?.flag = 3
        viewController?.keyword = searchTextField.text ?? ""
        viewController?.loadTicketData(requestType: .update)
    }
    
    // MARK: - Setter
    // 设置城市选择按钮
    lazy var leftBarButton: UIButton = {
        let leftBarButton = UIButton(type: .custom)
        leftBarButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        leftBarButton.setTitle("北京", for: .normal)
        leftBarButton.setTitleColor(UIColor.init(hexColor: "333333"), for: .normal)
        leftBarButton.setImage(UIImage(named: "common_allType_button_normal_iPhone"), for: .normal)
        leftBarButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 45, bottom: 0, right: 0)
        leftBarButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        leftBarButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftBarButton.addTarget(self, action: #selector(chooseCity(sender:)), for: .touchUpInside)
        
        return leftBarButton
    }()
    
    // 设置搜索框
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.placeholder = "搜索内容..."
        let attributeString = NSMutableAttributedString(string: searchTextField.placeholder!)
        attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 13),range: NSMakeRange(0,(searchTextField.placeholder?.characters.count)!))
        searchTextField.attributedPlaceholder = attributeString
        searchTextField.borderStyle = .roundedRect
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        return searchTextField
    }()
    lazy var searchButton: UIButton = {
        let searchButton = UIButton()
        searchButton.setImage(UIImage(named: "common_search_button_normal_iPhone"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchTicket(sender:)), for: .touchUpInside)
        return searchButton
    }()
    
    // titleView
    lazy var searchView: UIView = {
        let searchView = UIView(frame: CGRect(x: 0, y: 0, width: 370, height: 30))
        searchView.backgroundColor = UIColor.white
        return searchView
    }()
    
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
        let mainView = UIScrollView(frame: CGRect(x: 0, y: 65, width: kScreen_width, height: kScreen_height))
        mainView.delegate = self
        mainView.isPagingEnabled = true
        mainView.bounces = false
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        self.view.addSubview(mainView)
        return mainView
    }()
}

extension TicketBaseNaviViewController: UIScrollViewDelegate {
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
extension TicketBaseNaviViewController: SYNavTabBarDelegate {
    func itemDidSelected(index: NSInteger, currentIndex: NSInteger) {
        if currentIndex-index > 3 || currentIndex-index < -3 {
            mainView.contentOffset = CGPoint(x: CGFloat(index) * kScreen_width, y: 0)
        }else{
            mainView.setContentOffset(CGPoint(x: CGFloat(index) * kScreen_width, y: 0), animated: false)
        }
    }
}

extension TicketBaseNaviViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let index = currentIndex! - 1 < 0 ? 0 : currentIndex!
        let viewController = subViewControllers?[index]
        viewController?.flag = 3
        viewController?.keyword = searchTextField.text ?? ""
        viewController?.loadTicketData(requestType: .update)
        
        return true
    }
}
