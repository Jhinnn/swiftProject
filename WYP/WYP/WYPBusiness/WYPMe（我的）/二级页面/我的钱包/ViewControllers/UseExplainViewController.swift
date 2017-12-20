//
//  UseExplainViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/5/19.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import WebKit

class UseExplainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "规则说明"
        
        setupUI()
        
        request()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    func setupUI() {
        view.addSubview(webView)
        
        setupUIFrame()
    }
    
    func setupUIFrame() {
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func request() {
        let url = kApi_baseUrl(path: "mob/info/info")
        let urlString = URL(string: url)
        let request = URLRequest(url: urlString!)
        webView.load(request)
    }
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        
        return webView
    }()
}

extension UseExplainViewController: WKUIDelegate,WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.dismiss(withDelay: 10)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}
