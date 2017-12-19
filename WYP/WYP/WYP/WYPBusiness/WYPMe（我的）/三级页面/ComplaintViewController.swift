//
//  ComplaintViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/26.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import WebKit

class ComplaintViewController: BaseViewController {

    // 投诉对象的Id
    var complaintId: String?
    // 投诉的类型 1.资讯 2.展厅 3.票务 4.活动 5.话题 6.社区
    var type: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    // MARK: - private method
    func viewConfig() {
        self.title = "投诉"
        view.addSubview(newsWebView)
        
        newsWebView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(kScreen_width)
            make.height.equalTo(kScreen_height)
        }
        
        let str = String.init(format: "mob/group/Complaints?uid=%@&type=%@&id=%@", AppInfo.shared.user?.userId ?? "", type ?? "", complaintId ?? "")
        let url = kApi_baseUrl(path: str)
        let urlString = URL(string: url)
        let request = URLRequest(url: urlString!)
        newsWebView.load(request)
        
    }
    
    lazy var newsWebView: WKWebView = {
        let newsWebView = WKWebView()
        newsWebView.backgroundColor = UIColor.clear
        newsWebView.uiDelegate = self
        newsWebView.navigationDelegate = self
        newsWebView.isOpaque = false
        newsWebView.scrollView.showsVerticalScrollIndicator = false
        
        return newsWebView
    }()
}

extension ComplaintViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.dismiss(withDelay: 10)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "好的", style: UIAlertActionStyle.cancel) { (_) in
            completionHandler()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
}

