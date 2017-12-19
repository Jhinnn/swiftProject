//
//  AdvViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/24.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import WebKit

class AdvViewController: BaseViewController {

    // 广告链接
    var advLink: String?
    // 新闻标题
    var newsTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "广告"
        view.addSubview(applyWebView)
        layoutPageSubViews()
        
        let urlString = URL(string: advLink ?? "")
        let request = URLRequest(url: urlString!)
        applyWebView.load(request)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    func layoutPageSubViews(){
        applyWebView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
    lazy var applyWebView: WKWebView = {
        let applyWebView = WKWebView()
        applyWebView.backgroundColor = UIColor.clear
        applyWebView.isOpaque = false
        applyWebView.uiDelegate = self
        applyWebView.navigationDelegate = self
        applyWebView.scrollView.showsVerticalScrollIndicator = false
        
        return applyWebView
    }()
}

extension AdvViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.dismiss(withDelay: 10)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}



