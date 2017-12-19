//
//  SeatMapViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import WebKit

class SeatMapViewController: BaseViewController {

    // 场馆Id
    var vernveId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "座位图"
        
        view.addSubview(mapWebView)
        layoutPageSubViews()
        
        let url = String.init(format: "mob/info/ticketSet/vid/%@", vernveId ?? "")
        let urlString = URL(string: kApi_baseUrl(path: url))
        let request = URLRequest(url: urlString!)
        mapWebView.load(request)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    // MARK: - private method
    func layoutPageSubViews(){
        mapWebView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
    // MARK: - event response
    
    // MARK: - setter and getter
    lazy var mapWebView: WKWebView = {
        
        let mapWebView = WKWebView()
        mapWebView.backgroundColor = UIColor.clear
        mapWebView.isOpaque = false
        mapWebView.uiDelegate = self
        mapWebView.navigationDelegate = self
        mapWebView.scrollView.showsVerticalScrollIndicator = false
        
        return mapWebView
    }()
}

extension SeatMapViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.dismiss(withDelay: 10)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}

