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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "tj_icon_fx_normal"), style: .done, target: self, action: #selector(shareBarButtonItemAction))
        
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
    
    // 分享
    func shareBarButtonItemAction() {
        
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        
        let messageObject = UMSocialMessageObject()
        // 分享链接
//        let url = String.init(format: "Mob/news/index.html?news_id=%@&is_app=1&phone_type=1", newsId ?? "")
//        let shareLink = kApi_baseUrl(path: url)
        // 设置文本
        //        messageObject.text = newsTitle! + shareLink
        // 分享对象
        let shareObject: UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: newsTitle ?? "", descr: "在这里，有各种好玩的内容等着你，点进来看看吧", thumImage: UIImage(named: "aladdiny_icon"))
        // 网址
        shareObject.webpageUrl = advLink
        messageObject.shareObject = shareObject
        
        // 传相关参数
        ShareManager.shared.loadShareAdv()
//        ShareManager.shared.complaintId = newsId ?? ""
        ShareManager.shared.type = "1"
        
        ShareManager.shared.messageObject = messageObject
        ShareManager.shared.viewController = self
        ShareManager.shared.show()
    }
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



