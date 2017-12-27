//
//  ServiceCenterViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/4/1.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import WebKit

class ServiceCenterViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfig()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
    }

    // MARK: - private method
    func viewConfig() {
        self.title = "客服中心"
        view.addSubview(newsWebView)
        
        newsWebView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        let url = kApi_baseUrl(path: "Mob/Settled/callcenter.html")
        let urlString = URL(string: url)
        let request = URLRequest(url: urlString!)
        newsWebView.load(request)
        
    }
    
    lazy var newsWebView: WKWebView = {
        
        // 自定义配置
        let conf = WKWebViewConfiguration()
        conf.userContentController = WKUserContentController()
        conf.preferences.javaScriptEnabled = true
        conf.selectionGranularity = WKSelectionGranularity.character
        conf.userContentController.add(self as WKScriptMessageHandler, name: "CouponViewController")
        conf.userContentController.add(self as WKScriptMessageHandler, name: "call")
        
        
        let newsWebView = WKWebView(frame: .zero, configuration: conf)
        newsWebView.backgroundColor = UIColor.clear
        newsWebView.isOpaque = false
        newsWebView.uiDelegate = self
        newsWebView.navigationDelegate = self
        newsWebView.scrollView.showsVerticalScrollIndicator = false
        
        return newsWebView
    }()
    
    
}


extension ServiceCenterViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "call" {
            
            //自动打开拨号页面并自动拨打电话
            let urlString = "tel://010-64457191"
            if let url = URL(string: urlString) {
                //根据iOS系统版本，分别处理
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }

            return
        }
    }
}

extension ServiceCenterViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.dismiss(withDelay: 10)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}

