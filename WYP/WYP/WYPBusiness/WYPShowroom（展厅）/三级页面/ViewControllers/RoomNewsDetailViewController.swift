//
//  RoomNewsDetailViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/6/6.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import WebKit

class RoomNewsDetailViewController: BaseViewController {
    
    // 新闻id
    var newsId: String?
    // 新闻标题
    var newsTitle: String?
    // 资讯图片
    var newsPhoto: String?
    // 评论数
    var commentNumber: String?
    // 评论数据
    var commentData = [CommentModel]()
    
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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadCommentList(requestType: .update)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
        IQKeyboardManager.shared().isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        IQKeyboardManager.shared().isEnabled = false
        
        navigationController?.navigationBar.isHidden = false
    }
    
    deinit {
        if isAddObserver {
            self.wbScrollView?.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
    // MARK: - event reaponse
    // 分享
    func shareBarButtonItemAction() {
        
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        
        let messageObject = UMSocialMessageObject()
        // 分享链接
        let shareLink = String.init(format: "mob/news/group_post_detail?id=%@&is_app=1", newsId ?? "")
        // 设置文本
//        messageObject.text = newsTitle! + kApi_baseUrl(path: shareLink)

        // 分享对象
        let shareObject: UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: newsTitle ?? "", descr: "在这里，有各种好玩的资讯等着你，点进来看看吧", thumImage: UIImage(named: "aladdiny_icon"))
        // 网址
        shareObject.webpageUrl = kApi_baseUrl(path: shareLink)
        messageObject.shareObject = shareObject
        
        // 传相关参数
        ShareManager.shared.loadShareAdv()
        ShareManager.shared.complaintId = newsId ?? ""
        ShareManager.shared.type = "1"
        
        ShareManager.shared.messageObject = messageObject
        ShareManager.shared.viewController = self
        ShareManager.shared.show()
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
        view.addSubview(interactionView)
        view.addSubview(commentDetailBtn)
        interactionView.addSubview(commentTextField)
        
        newsTableView.tableHeaderView = newsWebView
        wbScrollView = self.newsWebView.scrollView
        wbScrollView?.bounces = false
        wbScrollView?.isScrollEnabled = true
        
        newsTableView.isHidden = true
    }
    
    func layoutPageSubviews() {
        newsTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 49, 0))
        }
        
        interactionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(49)
        }
        commentDetailBtn.snp.makeConstraints { (make) in
            make.right.equalTo(interactionView).offset(-13)
            make.bottom.equalTo(interactionView).offset(-14.5)
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
        
        let url = String.init(format: "mob/news/group_post_detail?id=%@", newsId ?? "")
        let urlString = URL(string: kApi_baseUrl(path: url))
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
        NetRequest.roomNewsCommentListNetRequest(page: "\(pageNumber)", uid: AppInfo.shared.user?.userId ?? "", newsId: newsId ?? "") { (success, info, result) in
            if success {
                let array = result!.value(forKey: "comments")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                if requestType == .update {
                    self.commentData = [CommentModel].deserialize(from: jsonString) as! [CommentModel]
                } else {
                    let commentData = [CommentModel].deserialize(from: jsonString) as! [CommentModel]
                    self.commentData = self.commentData + commentData
                }
                self.newsTableView.mj_header.endRefreshing()
                self.newsTableView.mj_footer.endRefreshing()
                self.newsTableView.reloadData()
                
            } else {
                self.newsTableView.mj_header.endRefreshing()
                self.newsTableView.mj_footer.endRefreshing()
            }
        }
    }
    
    // MARK: - setter and getter
    
    lazy var newsWebView: WKWebView = {
        let newsWebView = WKWebView(frame: .zero)
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
        tableView.mj_header =  MJRefreshNormalHeader(refreshingBlock: {
            self.loadCommentList(requestType: .update)
        })
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

extension RoomNewsDetailViewController: WKUIDelegate,WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.dismiss(withDelay: 10)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
        
        newsTableView.isHidden = false
        
        //这个方法也可以计算出webView滚动视图滚动的高度
        webView.evaluateJavaScript("document.body.scrollWidth") { (result, error) in
            print("scrollView宽度：\(result as! CGFloat)")
            let webViewW = result as! CGFloat
            let ratio = self.newsWebView.frame.width/webViewW
            
            webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (result, error) in
                print("scrollView高度：\(result as! CGFloat)")
                print("scrollView计算高度：\((result as! CGFloat)*ratio)")
                
                let newHeight = (result as! CGFloat) * ratio
                self.resetWebViewFrameWidthHeight(height: newHeight)
                if newHeight < kScreen_height {
                    //如果webView此时还不是满屏，就需要监听webView的变化  添加监听来动态监听内容视图的滚动区域大小
                    self.wbScrollView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
                    self.isAddObserver = true
                }
            })
        }
    }
}

extension RoomNewsDetailViewController: UITableViewDelegate, UITableViewDataSource {
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
            
            if AppInfo.shared.user?.userId != nil {
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
            }
            
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
        if AppInfo.shared.user?.userId != nil && commentData.count >= 0 {
            return 50
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if commentData.count > 0 {
            let commentReply = CommentReplyViewController()
            commentReply.flag = 3
            commentReply.newsId = newsId ?? ""
            commentReply.commentData = commentData[indexPath.row]
            navigationController?.pushViewController(commentReply, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(newsTableView) {
            print("tableview")
            let offsetY = scrollView.contentOffset.y
            print("偏移\(offsetY)")
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

extension RoomNewsDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let uid = AppInfo.shared.user?.userId ?? ""
        if uid == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return false
        }
        NetRequest.roomNewsCommentNetRequest(pid: "", newId: newsId ?? "", uid: AppInfo.shared.user?.userId ?? "", comment: textField.text ?? "") { (success, info) in
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

extension RoomNewsDetailViewController: ShowRoomCommentCellDelegate {
    func commentPushButtonDidSelected(sender: UIButton, comments: CommentModel) {
        let personInfo = PersonalInformationViewController()
        personInfo.targetId = comments.uid ?? ""
        personInfo.name = comments.nickName ?? ""
        self.navigationController?.pushViewController(personInfo, animated: true)
    }
    
    // 点赞按钮
    func commentReplyStarDidSelected(sender: UIButton, comments: CommentModel) {
        let uid = AppInfo.shared.user?.userId ?? ""
        if uid == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        NetRequest.roomNewsThumbUpNetRequest(commentId: comments.commentId ?? "", uid: uid) { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info)
                sender.isSelected = true
                comments.isStar = "1"
                comments.zanNumber = "\(Int(comments.zanNumber!)! + 1)"
                self.newsTableView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: info)
            }
        }
    }
    // 回复按钮
    func commentReplyButtonDidSelected(sender: UIButton) {
        let commentReply = CommentReplyViewController()
        commentReply.flag = 3
        commentReply.newsId = newsId ?? ""
        commentReply.commentData = commentData[sender.tag - 190]
        navigationController?.pushViewController(commentReply, animated: true)
    }
}

