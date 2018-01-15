//
//  NewsDetailsViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/4/7.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import WebKit

class TalkNewsDetailsViewController: BaseViewController {

    var webImageListArray : Array<Any>!
    
    var collectionButton: UIButton!
    // 新闻id
    var newsId: String?
    // 新闻标题
    var newsTitle: String?
    // 评论数
    
    // 图集视图
    var pictureBrowserView: WBImageBrowserView?
    
    var imageIndex: Int?

    
    var commentNumber: String? {
        willSet {
//            commentDetailBtn.badgeLabel.text = newValue ?? "0"
        }
    }
    // 评论数据
    var commentData = [CommentModel]()
    // 是否已收藏
    var isCollection: String? {
        willSet {
            if newValue == "1" {
                collectionButton.isSelected = true
                collectionButton.setImage(UIImage(named: "detail_icon_follow_select"), for: .selected)
            }
        }
    }
    // 设置webView的高
    var webContentHeight: CGFloat?
    // webview的scrollView
    var wbScrollView: UIScrollView?
    
    // 是否添加了观察者
    var isAddObserver = false
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "话题详情"
        
        viewConfig()
        
        layoutPageSubviews()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        request()
        
        loadCommentList(requestType: .update)
    }
    
    func layoutPageSubviews() {
        newsTableView.snp.makeConstraints { (make) in
            if deviceTypeIPhoneX() {
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 59 + 24, 0))
            }else {
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 59, 0))
            }
        }
        
        if deviceTypeIPhoneX() {
            interactionView.snp.makeConstraints { (make) in
                make.left.right.equalTo(view)
                make.bottom.equalTo(0)
                make.height.equalTo(59 + 34)
            }
        }else {
            interactionView.snp.makeConstraints { (make) in
                make.left.right.bottom.equalTo(view)
                make.height.equalTo(59)
            }
        }
        
    }
    
    // 分享
    func shareBarButtonItemAction() {
        
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        
        let messageObject = UMSocialMessageObject()
        // 分享链接
        let url = String.init(format: "Mob/news/index.html?news_id=%@&is_app=1&phone_type=1", newsId ?? "")
        let shareLink = kApi_baseUrl(path: url)
        // 设置文本
//        messageObject.text = newsTitle! + shareLink
        // 分享对象
        let shareObject: UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: newsTitle ?? "", descr: "在这里，有各种好玩的资讯等着你，点进来看看吧", thumImage: UIImage(named: "aladdiny_icon"))
        // 网址
        shareObject.webpageUrl = shareLink
        messageObject.shareObject = shareObject
        
        // 传相关参数
        ShareManager.shared.loadShareAdv()
        ShareManager.shared.complaintId = newsId ?? ""
        ShareManager.shared.type = "1"
        
        ShareManager.shared.messageObject = messageObject
        ShareManager.shared.viewController = self
        ShareManager.shared.show()
    }
    
   
    

    
    // MARK: - private method
    func viewConfig() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "tj_icon_fx_normal"), style: .done, target: self, action: #selector(shareBarButtonItemAction))
        
        view.addSubview(newsTableView)
        newsTableView.isHidden = true
        view.addSubview(interactionView)

        
        let imageArray = ["theme_icon_more_normal","detail_icon_follow_normal","theme_icon_publish_normal"]
        let titleArray = ["更多","关注","提问"]
        
        for i in 0..<3 {
            let button: TalkButton = TalkButton()
            button.backgroundColor = UIColor.white
            button.frame = CGRect(x: CGFloat(i) * kScreen_width/6, y: 0, width: kScreen_width/6, height: 59)
            button.setImage(UIImage(named: imageArray[i]), for: .normal)
            button.tag = 100 + i
            if i == 1 {
                collectionButton = button
            }
            button.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
            button.setTitle(titleArray[i], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.setTitleColor(UIColor.init(hexColor: "999999"), for: .normal)
            button.titleLabel?.textAlignment = NSTextAlignment.center
            interactionView.addSubview(button)
        }
        
        let button = UIButton()
        button.frame = CGRect(x: kScreen_width/2, y: 0, width: kScreen_width/2, height: 59)
        button.backgroundColor = UIColor.init(hexColor: "DC3A20")
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(answerAction(sender:)), for: .touchUpInside)
        button.setTitle("回复话题", for: .normal)
        interactionView.addSubview(button)
        
    }
    
   
    
    func request() {
        let str = String.init(format: "Mob/news/index.html?news_id=%@", newsId ?? "")
        let url = kApi_baseUrl(path: str)
        let urlString = URL(string: url)
        let request = URLRequest(url: urlString!)
        newsWebView.load(request)
    }
    
    // 获取高度
    func resetWebViewFrameWidthHeight(height: CGFloat) {
        // 如果是新高度，那就重置
        if height != webContentHeight {
            if height >= kScreen_height {
                newsWebView.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height)
            } else {
                newsWebView.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: height)
            }
            newsTableView.reloadData()
            webContentHeight = height
        }
    }

    
    // 获取评论列表
    func loadCommentList(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.newsCommentListNetRequest(page:
        "\(pageNumber)", newsId: newsId ?? "", uid: AppInfo.shared.user?.userId ?? "") { (success, info, result) in
            if success {
                self.isCollection = result?.value(forKey: "cunZai") as? String
                let array = result!.value(forKey: "comments")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                if requestType == .update {
                    self.commentData = [CommentModel].deserialize(from: jsonString) as! [CommentModel]
                } else {
                    let commentData = [CommentModel].deserialize(from: jsonString) as! [CommentModel]
                    self.commentData = self.commentData + commentData
                }
                self.newsTableView.mj_footer.endRefreshing()
                self.newsTableView.reloadData()
                self.commentNumber = String(self.commentData.count)
                
            } else {
                self.newsTableView.mj_footer.endRefreshing()
            }
        }
    }
    
    // MARK: - setter and getter

    lazy var newsWebView: WKWebView = {
        
        // 自定义配置
        let conf = WKWebViewConfiguration()
        conf.userContentController = WKUserContentController()
        conf.preferences.javaScriptEnabled = true
        conf.selectionGranularity = WKSelectionGranularity.character
        conf.userContentController.add(self as WKScriptMessageHandler, name: "clickIndex")
        conf.userContentController.add(self as WKScriptMessageHandler, name: "showImgs")
        
        let newsWebView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 0), configuration: conf)
        newsWebView.backgroundColor = UIColor.red
        
        newsWebView.uiDelegate = self
        newsWebView.navigationDelegate = self
        newsWebView.scrollView.isScrollEnabled = false
        newsWebView.scrollView.showsVerticalScrollIndicator = false
        
        return newsWebView
    }()
    
    lazy var newsTableView: WYPTableView = {
//        let newAllTableView = WYPTableView(frame: .zero, style: .grouped)
        let newAllTableView = WYPTableView()
        newAllTableView.backgroundColor = UIColor.init(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
//        newAllTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        newAllTableView.delegate = self
        newAllTableView.dataSource = self

        newAllTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadCommentList(requestType: .loadMore)
        })
        newAllTableView.register(ShowRoomCommentCell.self, forCellReuseIdentifier: "replyCell")
        return newAllTableView
    }()
    
    // 背景
    lazy var interactionView: UIView = {
        let interactionView = UIView()
        interactionView.backgroundColor = UIColor.white
        return interactionView
    }()
    


    // 监听
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 根据内容的高度重置webview视图的高度
        let newHeight = wbScrollView?.contentSize.height
        resetWebViewFrameWidthHeight(height: newHeight!)
    }
    
    func collectionNews(sender: UIButton) {
        
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        if sender.isSelected {
            NetRequest.cancelAttentionNetRequest(openId: token, newsId: newsId ?? "", complete: { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info!)
                    sender.isSelected = false
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            })
        } else if !sender.isSelected {
            NetRequest.collectionNewsNetRequest(openId: token, newsId: newsId ?? "") { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info!)
                    sender.isSelected = true
                    sender.setImage(UIImage(named: "detail_icon_follow_select"), for: .selected)
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            }
        }
        
    }
    
}

extension TalkNewsDetailsViewController: WKUIDelegate,WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.dismiss(withDelay: 10)
    }
    func alert() {
        SYAlertController.showAlertController(view: self, title: "提示", message: "网络不佳，请稍后再试")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
        
        
        //这个方法也可以计算出webView滚动视图滚动的高度
        webView.evaluateJavaScript("document.body.scrollWidth") { (result, error) in

            let webViewW = result as! CGFloat
            let ratio = self.newsWebView.frame.width/webViewW
            
            webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (result, error) in
                
                let newHeight = (result as! CGFloat) * ratio
                self.resetWebViewFrameWidthHeight(height: newHeight)
                if newHeight < kScreen_height {
                    //如果webView此时还不是满屏，就需要监听webView的变化  添加监听来动态监听内容视图的滚动区域大小
                    self.wbScrollView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
                    self.isAddObserver = true
                }
            })
        }
        newsTableView.tableHeaderView = newsWebView
//        wbScrollView = self.newsWebView.scrollView
        wbScrollView?.bounces = false
        wbScrollView?.isScrollEnabled = true
        newsTableView.isHidden = false
    }
}

extension TalkNewsDetailsViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if commentData.count == 0 {
//            return 1
//        } else {
//            return commentData.count
//        }
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if commentData.count == 0 {
            return 1
        } else {
            return commentData.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if commentData.count == 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "tableViewCell")
            tableView.separatorStyle = .none
            
            let label = UILabel()
            label.tag = 160
            label.text = "暂无评论"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = UIColor.init(hexColor: "afafaf")
            cell.addSubview(label)
            
            label.snp.makeConstraints({ (make) in
                make.centerX.equalTo(cell)
                make.size.equalTo(CGSize(width: kScreen_width, height: 20))
            })
            
            return cell
        } else {
            let cell = TalkShowRoomCommentCell(style: .default, reuseIdentifier: "TopicsViewIdentifier")
            let commentFrame = TalkRoomCommentFrameModel()
            commentFrame.comment = commentData[indexPath.row]
            cell.starCountButton.tag = indexPath.section + 180
            cell.replyButton.tag = indexPath.section + 190
            cell.delegate = self
            cell.commentFrame = commentFrame
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if commentData.count == 0 {
            return 0
        } else {
            let commentFrame = TalkRoomCommentFrameModel()
            commentFrame.comment = commentData[indexPath.row]
            return commentFrame.cellHeight ?? 0
        }
    }
 
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(newsTableView) {

            let offsetY = scrollView.contentOffset.y
            if offsetY <= 0 {
                wbScrollView?.isScrollEnabled = true
                newsTableView.bounces = false
            } else {
                wbScrollView?.isScrollEnabled = false
                newsTableView.bounces = true
            }
        }
    }
    
    //三个按钮功能
    func clickAction(sender: UIButton) {
        if sender.tag == 100 {
            self.navigationController?.popViewController(animated: true)
        }else if sender.tag == 101 {
            
            self.collectionNews(sender: sender)
            
            
        }else if sender.tag == 102 {
            self.navigationController?.pushViewController(PublicGroupViewController(), animated: true)
        }
    }
    
    
    //回复话题
    func answerAction(sender: UIButton) {
        let vc = TalkNewsDetailsReplyViewController()
        vc.newsId = self.newsId
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension TalkNewsDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return false
        }
        NetRequest.topicsCommentNetRequest(openId: token, topicId: newsId ?? "", content: textField.text ?? "", pid: "") { (success, info) in
            if success {
                textField.resignFirstResponder()
                
                SVProgressHUD.showSuccess(withStatus: info!)
                self.loadCommentList(requestType: .update)
                
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if WYPContain.stringContainsEmoji(string) {
            if WYPContain.isNineKeyBoard(string) {
                return true
            }
            SVProgressHUD.showError(withStatus: "暂不支持特殊字符")
            return false
        }
        return true
    }
}

extension TalkNewsDetailsViewController: TalkShowRoomCommentCellDelegate {
    
    func commenPushCenterButtonDidSelected(comments: CommentModel) {
        
        let personInfo = PersonalInformationViewController()
        personInfo.targetId = comments.uid ?? ""
        personInfo.name = comments.nickName ?? ""
        
        self.navigationController?.pushViewController(personInfo, animated: true)
    }
    
    // 点赞按钮
    func commentReplyStarDidSelected(sender: UIButton, comments: CommentModel) {
        
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        NetRequest.topicStarNetRequest(openId: token, newsId: newsId ?? "", typeId: "2", cid: comments.commentId ?? "") { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info!)
                sender.isSelected = true
                comments.isStar = "1"
                comments.zanNumber = "\(Int(comments.zanNumber!)! + 1)"
                self.newsTableView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
    // 回复按钮
    func commentReplyButtonDidSelected(sender: UIButton) {
        let commentReply = CommentReplyViewController()
        commentReply.flag = 2
        commentReply.newsId = newsId ?? ""
        commentReply.commentData = commentData[sender.tag - 190]
        navigationController?.pushViewController(commentReply, animated: true)
    }
    
    //关注
    func commentFollowButtonDidSelected(sender: UIButton, comments: CommentModel) {
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        
        if comments.is_follow == 0 {
            NetRequest.addOrCancelAttentionNetRequest(method: "POST", mid: AppInfo.shared.user?.userId ?? "", follow_who: comments.uid!) { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info!)
                    self.loadCommentList(requestType: .update)
                    self.newsTableView.reloadData()
                    
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            }
        }else {
            NetRequest.addOrCancelAttentionNetRequest(method: "DELETE", mid: AppInfo.shared.user?.userId ?? "", follow_who: comments.uid!) { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info!)
                    self.loadCommentList(requestType: .update)
                    self.newsTableView.reloadData()
                    
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            }
        }
    }
    
    func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        if error != nil {
            SVProgressHUD.showError(withStatus: "保存失败！")
            return
            
        }else {
            SVProgressHUD.showSuccess(withStatus: "保存成功!")
        }
        
    }
}


extension TalkNewsDetailsViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "clickIndex" {  //图片点击事件
            
            let window = UIApplication.shared.keyWindow!
            window.backgroundColor = UIColor.black
            
            pictureBrowserView = WBImageBrowserView.pictureBrowsweView(withFrame: CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height), delegate: self, browserInfoArray: webImageListArray)
            pictureBrowserView?.type = 1
            pictureBrowserView?.viewController = self
            pictureBrowserView?.topBgView.isHidden = true
            pictureBrowserView?.startIndex = message.body as! Int + 1
            pictureBrowserView?.show(in: window)
            pictureBrowserView?.indexLabel.text = String.init(format: "%d/%d", message.body as! Int + 1,webImageListArray.count)
            imageIndex = (message.body as! Int) //获得下标
            return
        }
        
        if message.name == "showImgs" {
            let str = message.body
            let strArray = (str as! String).components(separatedBy: ",")
            webImageListArray = strArray
            return
        }
    }
}

extension TalkNewsDetailsViewController: WBImageBrowserViewDelegate {
    func saveImageButton(toClick image: UIImage!) {
        if image != nil {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }else {
            SVProgressHUD.showInfo(withStatus: "等待加载...")
            SVProgressHUD.dismiss(withDelay: 0.5)
        }
    }
    
    func getContentWithItem(_ item: Int) {
        pictureBrowserView?.indexLabel.text = String.init(format: "%d/%d", item + 1,webImageListArray.count)
        imageIndex = item //获得图片下标
    }
    
    
    
}
