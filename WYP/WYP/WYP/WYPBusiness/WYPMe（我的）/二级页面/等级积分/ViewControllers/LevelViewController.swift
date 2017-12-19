//
//  LevelViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/8.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import WebKit

class LevelViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "等级积分详情"
        
        viewConfig()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    // MARK: - private method
    func viewConfig() {
        view.addSubview(newsWebView)
        
        newsWebView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(kScreen_width)
            make.height.equalTo(kScreen_height)
        }
        
        let url = kApi_baseUrl(path: "Mob/Settled/integral.html")
        let urlString = URL(string: url)
        let request = URLRequest(url: urlString!)
        newsWebView.load(request)
    }
    
    lazy var newsWebView: WKWebView = {
        let newsWebView = WKWebView()
        newsWebView.backgroundColor = UIColor.clear
        newsWebView.isOpaque = false
        newsWebView.uiDelegate = self
        newsWebView.scrollView.showsVerticalScrollIndicator = false
        
        return newsWebView
    }()
    
    
}

extension LevelViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.dismiss(withDelay: 10)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}

