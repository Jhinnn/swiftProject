//
//  AnnouncementViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import WebKit

class AnnouncementViewController: BaseViewController {

    // 公告id
    var announcementId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "公告详情"
        
        view.addSubview(webView)
        layoutPageSubViews()
        
        let url = String.init(format: "mob/group/groupAnnouncement/id/%@", announcementId ?? "")
        let urlString = URL(string: kApi_baseUrl(path: url))
        let request = URLRequest(url: urlString!)
        webView.load(request)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    // MARK: - private method
    func layoutPageSubViews(){
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
    }

    // MARK: - setter and getter
    lazy var webView: WKWebView = {
        
        let webView = WKWebView()
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        
        return webView
    }()

}

extension AnnouncementViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.dismiss(withDelay: 10)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}
