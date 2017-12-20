//
//  FirstScrambleForTicketView.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/31.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import WebKit

class FirstScrambleForTicketView: UIView {
    
    var url: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.addSubview(backView)
        self.addSubview(closeButton)
        self.addSubview(lotteryWebView)
        
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(80)
            make.right.equalTo(self)                                                                                                                                                                                                                                                                                                          .offset(-13)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        backView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        lotteryWebView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 290 * width_height_ratio, height: 320 * width_height_ratio))
        }
        
        url = String.init(format: "Mob/WebActivity/indexluckdraw.html?uid=%@", AppInfo.shared.user?.userId ?? "")
        let urlString = URL(string: kApi_baseUrl(path: url ?? ""))
        let request = URLRequest(url: urlString!)
        lotteryWebView.load(request)
        
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapTheBackView(tap:)))
//        tap.numberOfTapsRequired = 1
//        tap.numberOfTouchesRequired = 1
//        backView.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - event response
    func closeView(sender: UIButton) {
        self.removeFromSuperview()
    }
    
    // MARK: - setter and getter
    lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = UIColor.black
        backView.alpha = 0.5
        return backView
    }()
    
    lazy var lotteryWebView: WKWebView = {
        // 自定义配置
        let conf = WKWebViewConfiguration()
        conf.userContentController = WKUserContentController()
        conf.preferences.javaScriptEnabled = true
        conf.selectionGranularity = WKSelectionGranularity.character
        conf.userContentController.add(self as WKScriptMessageHandler, name: "CouponViewController")
        conf.userContentController.add(self as WKScriptMessageHandler, name: "hid")
        conf.userContentController.add(self as WKScriptMessageHandler, name: "save")
        
        
        let lotteryWebView = WKWebView(frame: CGRect.zero, configuration: conf)
        lotteryWebView.layer.masksToBounds = true
        lotteryWebView.layer.cornerRadius = 5.0
        lotteryWebView.backgroundColor = UIColor.clear
        lotteryWebView.isOpaque = false
        lotteryWebView.uiDelegate = self
        lotteryWebView.navigationDelegate = self
        lotteryWebView.scrollView.showsVerticalScrollIndicator = false
        
        return lotteryWebView
    }()
    
    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "news_photo_button_normal_iPhone"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeView(sender:)), for: .touchUpInside)
        return closeButton
    }()
}

extension FirstScrambleForTicketView: WKUIDelegate, WKNavigationDelegate {
    
}

extension FirstScrambleForTicketView: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "hid" {
            
            self.removeFromSuperview()
        }
        
//        if message.name == "save" {
//            // 获取今天的日期
//            let formatter = DateFormatter()
//            formatter.dateFormat = "YYYY-MM-dd"
//            let date = formatter.string(from: Date())
//            // 存起来
//            let userDefault = UserDefaults.standard
//            userDefault.set(date, forKey: "today")
//        }
        
        guard let nameSpage = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("没有命名空间")
            return
        }
        
        guard let childVcClass = NSClassFromString(nameSpage + "." + message.name) else {
            print("没有获取到对应的class")
            return
        }
        
        guard let childVcType = childVcClass as? UIViewController.Type else {
            print("没有得到的类型")
            return
        }
        // lb_coder
        //根据类型创建对应的对象
        let vc = childVcType.init()
        
        self.viewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIView {
    func viewController() -> UIViewController? {
        //通过响应者链，取得此视图所在的视图控制器
        var next = self.next
        
        while(next != nil) {
            //判断响应者对象是否是视图控制器类型
            if next!.isKind(of: UIViewController.self) {
                return next as? UIViewController;
            }
            next = next!.next
        }
        return nil;
    }
}
