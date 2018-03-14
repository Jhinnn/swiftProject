//
//  AboutViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/4/10.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "关于1001阿拉丁"
        
//        viewConfig()
        setupUI()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        SVProgressHUD.dismiss()
//    }
//
//    // MARK: - private method
//    func viewConfig() {
//        view.addSubview(newsWebView)
//
//        newsWebView.snp.makeConstraints { (make) in
//            make.edges.equalTo(view)
//        }
//
//        let url = kApi_baseUrl(path: "Mob/About/About.html")
//        let urlString = URL(string: url)
//        let request = URLRequest(url: urlString!)
//        newsWebView.load(request)
//
//    }
//
//    lazy var newsWebView: WKWebView = {
//        let newsWebView = WKWebView(frame: .zero)
//        newsWebView.backgroundColor = UIColor.clear
//        newsWebView.isOpaque = false
//        newsWebView.uiDelegate = self
//        newsWebView.navigationDelegate = self
//        newsWebView.scrollView.showsVerticalScrollIndicator = false
//
//        return newsWebView
//    }()
    
    
    
    
    private func setupUI() {
    
        view.addSubview(iconImageView)
        
        view.addSubview(versionLabel)
        
        setupUIFrame()
    }
    
    private func setupUIFrame() {
        
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        versionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 150, height: 20))
        }
    }
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "aladdiny_icon")
        iconImageView.backgroundColor = UIColor.red
        
        return iconImageView
    }()
    
    lazy var versionLabel: UILabel = {
        let versionLabel = UILabel()
        versionLabel.text = "v1.9.2"
        versionLabel.font = UIFont.systemFont(ofSize: 15)
        versionLabel.textAlignment = .center
        return versionLabel
    }()
    
    lazy var examineVersionButton: UIButton = {
        let examineVersionButton = UIButton(type: .custom)
        examineVersionButton.setTitle("检查版本更新", for: .normal)
        examineVersionButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        examineVersionButton.setTitleColor(UIColor.black, for: .normal)
        examineVersionButton.backgroundColor = UIColor.white
        examineVersionButton.addTarget(self, action: #selector(examineVersionUpdate), for: .touchUpInside)
        
        return examineVersionButton
    }()
    
    // MARK: - IBAction
    
    func examineVersionUpdate() {
        let alert = UIAlertView(title: "版本更新", message: "当前应用为最新版本", delegate: self, cancelButtonTitle: "确定")
        alert.show()
    }
 
 
}

/*
extension AboutViewController: UIAlertViewDelegate {
    
    
}
 
 

extension AboutViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.dismiss(withDelay: 10)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}
 
 */
