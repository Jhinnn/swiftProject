//
//  ApplyToEnterViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/2.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import WebKit

class ApplyToEnterViewController: BaseViewController {

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "申请入驻"
        view.addSubview(applyWebView)
        layoutPageSubViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    // MARK: - private method
    func layoutPageSubViews(){
        applyWebView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    // MARK: - setter and getter
    lazy var applyWebView: WKWebView = {
        let applyWebView = WKWebView()
        applyWebView.backgroundColor = UIColor.clear
        applyWebView.isOpaque = false
        applyWebView.uiDelegate = self
        applyWebView.navigationDelegate = self
        applyWebView.scrollView.showsVerticalScrollIndicator = false
        let str = String.init(format: "Mob/Settled/index.html?uid=%@", AppInfo.shared.user?.userId ?? "")
        let url = kApi_baseUrl(path: str)
        let urlString = URL(string: url)
        let request = URLRequest(url: urlString!)
        applyWebView.load(request)
        return applyWebView
    }()
    
}

extension ApplyToEnterViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.dismiss(withDelay: 10)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertView(title: "", message: message, delegate: self, cancelButtonTitle: "知道了")
        alert.show()
        completionHandler()
    }
}

extension ApplyToEnterViewController: UIAlertViewDelegate {
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        print(buttonIndex)
        if buttonIndex == 0 {
            return
        }
    }
}
