//
//  ProjectCertificationViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import WebKit

class ProjectCertificationViewController: BaseViewController {
    
    var roomId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "项目认证"
        
        view.addSubview(projectWebView)
        layoutPageSubViews()
        
        let url = String.init(format: "mob/group/app_renzheng.html?group_id=%@", roomId ?? "")
        let urlString = URL(string: kApi_baseUrl(path: url))
        let request = URLRequest(url: urlString!)
        projectWebView.load(request)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    // MARK: - private method
    func layoutPageSubViews(){
        projectWebView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
    // MARK: - event response
    
    // MARK: - setter and getter
    lazy var projectWebView: WKWebView = {
        
        let projectWebView = WKWebView()
        projectWebView.backgroundColor = UIColor.clear
        projectWebView.isOpaque = false
        projectWebView.uiDelegate = self
        projectWebView.navigationDelegate = self
        projectWebView.scrollView.showsVerticalScrollIndicator = false
        
        return projectWebView
    }()
}

extension ProjectCertificationViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.dismiss(withDelay: 10)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}
