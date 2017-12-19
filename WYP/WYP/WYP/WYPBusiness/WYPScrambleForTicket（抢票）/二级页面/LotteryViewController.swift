//
//  LotteryViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/4/7.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import WebKit

class LotteryViewController: BaseViewController {

    // 票务Id
    var ticketId: String?
    // 票务时间Id
    var ticketTimeId: String?
    // 票务名称
    var ticketName: String = "抽奖"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "抽奖"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "common_share_button_highlight_iPhone"), style: .done, target: self, action: #selector(shareBarButtonItemAction))
        view.addSubview(lotteryWebView)
        layoutPageSubViews()
        
        let str = String.init(format: "Mob/WebActivity/adv.html?uid=%@&ticket_time_id=%@", AppInfo.shared.user?.userId ?? "", ticketTimeId ?? "")
        let url = kApi_baseUrl(path: str)

        let urlString = URL(string: url)
        let request = URLRequest(url: urlString!)
        lotteryWebView.load(request)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    // MARK: - private method
    func layoutPageSubViews(){
        lotteryWebView.snp.makeConstraints { (make) in
           make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
    // MARK: - event response
    func pushNextVC() {
        navigationController?.popViewController(animated: true)
    }
    // 分享
    func shareBarButtonItemAction() {
        let messageObject = UMSocialMessageObject()
        
        // 分享链接
        let str = String.init(format: "Mob/WebActivity/adv.html?is_share=1&ticket_time_id=%@&share_uid=%@", ticketTimeId ?? "", AppInfo.shared.user?.userId ?? "")
        let shareLink = kApi_baseUrl(path: str)
        // 设置文本
//        messageObject.text = shareLink + ticketName
        // 分享对象
        let shareObject: UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: ticketName, descr: "参与抽奖，有可能获得大奖哦，快来试试吧", thumImage: UIImage(named: "aladdiny_icon"))
        // 网址
        shareObject.webpageUrl = shareLink
        messageObject.shareObject = shareObject
        
        // 传相关参数
        ShareManager.shared.loadShareAdv()
        ShareManager.shared.complaintId = ticketId ?? ""
        ShareManager.shared.type = "3"
        
        ShareManager.shared.messageObject = messageObject
        ShareManager.shared.viewController = self
        ShareManager.shared.show()
    }

    // MARK: - setter and getter
    lazy var lotteryWebView: WKWebView = {
        // 自定义配置
        let conf = WKWebViewConfiguration()
        conf.userContentController = WKUserContentController()
        conf.preferences.javaScriptEnabled = true
        conf.selectionGranularity = WKSelectionGranularity.character
        conf.userContentController.add(self as WKScriptMessageHandler, name: "CouponViewController")
        conf.userContentController.add(self as WKScriptMessageHandler, name: "LevelViewController")
        conf.userContentController.add(self as WKScriptMessageHandler, name: "InviteFriendsViewController")
        conf.userContentController.add(self as WKScriptMessageHandler, name: "share")
        
        let lotteryWebView = WKWebView(frame: CGRect.zero, configuration: conf)
        lotteryWebView.backgroundColor = UIColor.clear
        lotteryWebView.isOpaque = false
        lotteryWebView.uiDelegate = self
        lotteryWebView.navigationDelegate = self
        lotteryWebView.scrollView.showsVerticalScrollIndicator = false
        
        return lotteryWebView
    }()

}

extension LotteryViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.dismiss(withDelay: 10)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}

extension LotteryViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "share" {
            // 分享
            return
        }
        
        guard let nameSpage = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("没有命名空间")
            return
        }
        
        guard let childVcClass = NSClassFromString(nameSpage + "." + message.name) else {
            print("没有获取到对应的class")
            return
        }
        
        guard let childVcType = childVcClass as? UIViewController.Type else {
            print("没有得到的类型")
            return
        }
        // lb_coder
        //根据类型创建对应的对象
        let vc = childVcType.init()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

