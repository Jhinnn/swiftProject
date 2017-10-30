//
//  NewsDetailsViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/4/7.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailsViewController: BaseViewController {

    // 新闻id
    var newsId: String?
    // 新闻标题
    var newsTitle: String?
    // 评论数
    var commentNumber: String? {
        willSet {
            commentDetailBtn.badgeLabel.text = newValue ?? "0"
        }
    }
    // 评论数据
    var commentData = [CommentModel]()
    // 是否已收藏
    var isCollection: String? {
        willSet {
            if newValue == "1" {
                collectionButton.isSelected = true
                collectionButton.setImage(UIImage(named: "common_collection_button_selected_iPhone"), for: .selected)
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

        title = "资讯详情"
        
        viewConfig()
        layoutPageSubviews()
        commentDetailBtn.badgeLabel.frame = CGRect(x: 9, y: -2, width: 15, height: 8)
        commentDetailBtn.badgeLabel.text = commentNumber ?? "0"
        commentDetailBtn.addSubview(commentDetailBtn.badgeLabel)
        request()

        // 监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 推送资讯入口
        let push = UserDefaults.standard.object(forKey: "NewsPush") as? String
        if push == "NewsPush" {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "common_navback_button_normal_iPhone"), style: .done, target: self, action: #selector(rebackToRootViewAction(sender:)))
        }
        
        IQKeyboardManager.shared().isEnabled = false
        navigationController?.navigationBar.isHidden = false
        
        loadCommentList(requestType: .update)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
        IQKeyboardManager.shared().isEnabled = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    deinit {
        if isAddObserver {
            self.wbScrollView?.removeObserver(self, forKeyPath: "contentSize")
        }
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    // MARK: - event reaponse
    //返回
    func rebackToRootViewAction(sender: UIBarButtonItem) {
        let pushJudge = UserDefaults.standard
        pushJudge.set("", forKey: "NewsPush")
        self.dismiss(animated: false, completion: nil)
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
        let url = String.init(format: "Mob/news/index.html?news_id=%@&is_app=1", newsId ?? "")
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
                    sender.setImage(UIImage(named: "common_collection_button_selected_iPhone"), for: .selected)
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            }
        }
        
    }
    
    func chickCommentDetail(sender: UIButton) {
        
        newsWebView.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: webContentHeight ?? 0)
        newsTableView.reloadData()
        let oneIndex = IndexPath(row: 0, section: 0)
        self.newsTableView.scrollToRow(at: oneIndex, at: .top, animated: true)
    }
    
    // MARK: - private method
    func viewConfig() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "common_share_button_highlight_iPhone"), style: .done, target: self, action: #selector(shareBarButtonItemAction))
        
        view.addSubview(newsTableView)
        newsTableView.isHidden = true
        view.addSubview(interactionView)
        interactionView.addSubview(shareButton)
        interactionView.addSubview(collectionButton)
        interactionView.addSubview(commentDetailBtn)
        interactionView.addSubview(commentTextField)
    }
    
    func layoutPageSubviews() {
        newsTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 49, 0))
        }
        
        interactionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(49)
        }
        shareButton.snp.makeConstraints { (make) in
            make.right.equalTo(interactionView).offset(-15)
            make.bottom.equalTo(interactionView).offset(-14.5)
            make.size.equalTo(CGSize(width: 19.5, height: 19.5))
        }
        collectionButton.snp.makeConstraints { (make) in
            make.right.equalTo(shareButton.snp.left).offset(-10)
            make.bottom.equalTo(interactionView).offset(-14.5)
            make.size.equalTo(CGSize(width: 19.5, height: 19.5))
        }
        commentDetailBtn.snp.makeConstraints { (make) in
            make.right.equalTo(collectionButton.snp.left).offset(-10)
            make.bottom.equalTo(interactionView).offset(-13)
            make.size.equalTo(CGSize(width: 19.5, height: 19.5))
        }
        commentTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(interactionView).offset(-10)
            make.left.equalTo(interactionView).offset(13)
            make.right.equalTo(commentDetailBtn.snp.left).offset(-15)
            make.height.equalTo(30)
        }
    }
    
    func request() {
        let str = String.init(format: "Mob/news/index.html?news_id=%@", newsId ?? "")
        print(str)
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
        let newsWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height))
        newsWebView.backgroundColor = UIColor.clear
        newsWebView.isOpaque = false
        newsWebView.uiDelegate = self
        newsWebView.navigationDelegate = self
        newsWebView.scrollView.isScrollEnabled = false
        newsWebView.scrollView.showsVerticalScrollIndicator = false
        
        return newsWebView
    }()
    
    lazy var newsTableView: WYPTableView = {
        let tableView = WYPTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadCommentList(requestType: .loadMore)
        })
        tableView.register(ShowRoomCommentCell.self, forCellReuseIdentifier: "replyCell")
        
        
        return tableView
    }()
    
    // 背景
    lazy var interactionView: UIView = {
        let interactionView = UIView()
        interactionView.backgroundColor = UIColor.white
        return interactionView
    }()
    
    // 评论框
    lazy var commentTextField: SYTextField = {
        let commentTextField = SYTextField()
        commentTextField.font = UIFont.systemFont(ofSize: 13)
        commentTextField.delegate = self
        commentTextField.borderStyle = .roundedRect
        commentTextField.placeholder = "期待你的神评论"
        commentTextField.returnKeyType = .send
        
        let imageView = UIImageView(frame: CGRect(x: 5, y: 8.25, width: 13.5, height: 13.5))
        imageView.image = UIImage(named: "common_editorGary_button_normal_iPhone")
        commentTextField.addSubview(imageView)
        
        return commentTextField
    }()
    
    // 分享
    lazy var shareButton: UIButton = {
        let shareButton = UIButton()
        shareButton.setBackgroundImage(UIImage(named: "news_share_button_normal_iPhone"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareBarButtonItemAction), for: .touchUpInside)
        return shareButton
    }()
    // 收藏
    lazy var collectionButton: UIButton = {
        let collectionButton = UIButton()
        collectionButton.setBackgroundImage(UIImage(named: "common_collection_button_normal_iPhone"), for: .normal)
        collectionButton.setBackgroundImage(UIImage(named: "common_collection_button_selected_iPhone"), for: .selected)
        collectionButton.addTarget(self, action: #selector(collectionNews(sender:)), for: .touchUpInside)
        return collectionButton
    }()
    // 评论详情按钮
    lazy var commentDetailBtn: SYButton = {
        let commentDetailBtn = SYButton()
        commentDetailBtn.setBackgroundImage(UIImage(named: "newsDetail_button_normal_iPhone"), for: .normal)
        commentDetailBtn.addTarget(self, action: #selector(chickCommentDetail(sender:)), for: .touchUpInside)
        return commentDetailBtn
    }()
    
    // 监听
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 根据内容的高度重置webview视图的高度
        let newHeight = wbScrollView?.contentSize.height
        resetWebViewFrameWidthHeight(height: newHeight!)
    }
    
    func keyboardWillShow(note: NSNotification) {
        let userInfo = note.userInfo!
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {
            //键盘的偏移量
            self.interactionView.transform = CGAffineTransform(translationX: 0 , y: -deltaY)
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else{
            animations()
        }
    }
    
    
    func keyboardWillHidden(note: NSNotification) {
        self.interactionView.transform = CGAffineTransform(translationX: 0 , y: 0)
    }
}

extension NewsDetailsViewController: WKUIDelegate,WKNavigationDelegate {
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
        wbScrollView = self.newsWebView.scrollView
        wbScrollView?.bounces = false
        wbScrollView?.isScrollEnabled = true
        newsTableView.isHidden = false
    }
}

extension NewsDetailsViewController: UITableViewDelegate, UITableViewDataSource {
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
            let cell = ShowRoomCommentCell(style: .default, reuseIdentifier: "TopicsViewIdentifier")
            let commentFrame = RoomCommentFrameModel()
            commentFrame.comment = commentData[indexPath.row]
            cell.starCountButton.tag = indexPath.row + 180
            cell.replyButton.tag = indexPath.row + 190
            cell.delegate = self
            cell.commentFrame = commentFrame
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if commentData.count == 0 {
            return 50
        } else {
            let commentFrame = RoomCommentFrameModel()
            commentFrame.comment = commentData[indexPath.row]
            return commentFrame.cellHeight ?? 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 40))
        headerView.backgroundColor = UIColor.white
        // 图标视图
        let iconView = UIImageView(frame: CGRect(x: 0, y: 13, width: 2, height: 18))
        iconView.image = UIImage(named: "home_rednote_icon_normal_iPhone")
        headerView.addSubview(iconView)
        let hotCommentLabel = UILabel(frame: CGRect(x: 13, y: 10, width: 100, height: 30))
        hotCommentLabel.text = "最新评论"
        hotCommentLabel.font = UIFont.systemFont(ofSize: 15)
        headerView.addSubview(hotCommentLabel)
        
        let commentNumLabel = UILabel()
        commentNumLabel.frame = CGRect(x: kScreen_width - 50, y: 0, width: 60, height: 40)
        commentNumLabel.font = UIFont.systemFont(ofSize: 10)
        commentNumLabel.textColor = UIColor.init(hexColor: "a1a1a1")
        commentNumLabel.text = String.init(format: "评论数%@", commentNumber ?? "0")
        headerView.addSubview(commentNumLabel)
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if commentData.count > 0 {
            let commentReply = CommentReplyViewController()
            commentReply.flag = 2
            commentReply.newsId = newsId ?? ""
            commentReply.commentData = commentData[indexPath.row]
            navigationController?.pushViewController(commentReply, animated: true)
        }
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

}

extension NewsDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return false
        }
        NetRequest.topicsCommentNetRequest(openId: token, topicId: newsId ?? "", content: textField.text ?? "", pid: "") { (success, info) in
            if success {
                textField.resignFirstResponder()
                self.commentTextField.text = ""
                SVProgressHUD.showSuccess(withStatus: info!)
                self.loadCommentList(requestType: .update)
                
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if PublicGroupViewController().stringContainsEmoji(string) {
            if PublicGroupViewController().isNineKeyBoard(string) {
                return true
            }
            SVProgressHUD.showError(withStatus: "暂不支持特殊字符")
            return false
        }
        return true
    }
}

extension NewsDetailsViewController: ShowRoomCommentCellDelegate {
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
}
