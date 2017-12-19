//
//  SeriveTermsViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/8/11.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import WebKit

class SeriveTermsViewController: BaseViewController {
    
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
        self.title = "服务条款"
        view.addSubview(newsWebView)
        
        newsWebView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        let url = kApi_baseUrl(path: "Mob/group/fuwu")
        let urlString = URL(string: url)
        let request = URLRequest(url: urlString!)
        newsWebView.load(request)
        
    }
    
    lazy var newsWebView: WKWebView = {
        
        let newsWebView = WKWebView(frame: .zero)
        newsWebView.backgroundColor = UIColor.clear
        newsWebView.isOpaque = false
        newsWebView.uiDelegate = self
        newsWebView.navigationDelegate = self
        newsWebView.scrollView.showsVerticalScrollIndicator = false
        
        return newsWebView
    }()
    
    
}

extension SeriveTermsViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.dismiss(withDelay: 10)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}

