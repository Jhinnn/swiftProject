//
//  TalkNewsDetailsCommentViewController.swift
//  WYP
//
//  Created by Arthur on 2018/1/17.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class TalkNewsDetailsCommentViewController: BaseViewController {

    //评论id
    var pid: String?
    
    //话题id
     var newsId: String?
    
    //话题名称
    var newsTitle: String?
    
    
    
    // 图集视图
    var pictureBrowserView: WBImageBrowserView?
    
    var imageIndex: Int?
    
    var webImageListArray : Array<Any>!
    
    
    
    // 设置webView的高
    var webContentHeight: CGFloat?
    // webview的scrollView
    var wbScrollView: UIScrollView?
    
    // 是否添加了观察者
    var isAddObserver = false
    
    // 评论数据
    var commentData = [CommentModel]()
    
    
    //评论数量
    var commentNumber: String?{
        willSet {
            commentDetailBtn.badgeLabel.text = newValue ?? "0"
        }
    }
    
    var commentZanNumber: String?
    
    
    var isStar: String? {
        willSet {
            if newValue == "1" {
                collectionButton.isSelected = true
                collectionButton.setImage(UIImage(named: "discuss_icon_dzh_select"), for: .selected)
            }
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        request()
        
        //更新点赞 评论数量
        zanNumberRequest()
        
        loadCommentList(requestType: .update)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "阿拉丁问答"
        
        view.backgroundColor = UIColor.white
        
        viewConfig()
        
        layoutPageSubviews()
    
    }
    
    func viewConfig() {
        
        commentDetailBtn.badgeLabel.frame = CGRect(x: 9, y: -2, width: 15, height: 8)
        commentDetailBtn.badgeLabel.text = commentNumber ?? "0"
        commentDetailBtn.addSubview(commentDetailBtn.badgeLabel)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "tj_icon_fx_normal"), style: .done, target: self, action: #selector(shareBarButtonItemAction))
        
        view.addSubview(newsTableView)
        newsTableView.isHidden = true
        view.addSubview(interactionView)
        interactionView.addSubview(collectionButton)
        interactionView.addSubview(commentDetailBtn)
        interactionView.addSubview(commentTextField)
    }
    
    func layoutPageSubviews() {
        newsTableView.snp.makeConstraints { (make) in
            if deviceTypeIPhoneX() {
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 34, 0))
            }else {
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 59, 0))
            }
        }
        
        interactionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(59)
        }
        
        collectionButton.snp.makeConstraints { (make) in
            make.right.equalTo(interactionView).offset(-24)
            make.centerY.equalTo(commentTextField.snp.centerY)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        commentDetailBtn.snp.makeConstraints { (make) in
            make.right.equalTo(collectionButton.snp.left).offset(-24)
            make.centerY.equalTo(commentTextField.snp.centerY)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        commentTextField.snp.makeConstraints { (make) in
            if deviceTypeIPhoneX() {
                make.centerY.equalTo(interactionView.snp.centerY).offset(-4)
            }else {
                make.centerY.equalTo(interactionView.snp.centerY)
            }
            
            make.left.equalTo(interactionView).offset(13)
            make.right.equalTo(commentDetailBtn.snp.left).offset(-30)
            make.height.equalTo(34)
        }
    }
    
    
    func request() {

        let str = String.init(format: "/Mob/news/gambit_detail_pinglun.html?news_id=%@&pid=%@", newsId ?? "",pid ?? "")
        let url = kApi_baseUrl(path: str)
        let urlString = URL(string: url)
        let request = URLRequest(url: urlString!)
        newsWebView.load(request)
    }
    
    // 获取评论列表
    func loadCommentList(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.newsCommentDetailNetRequest(page:
        "\(pageNumber)", pid: pid ?? "", uid: AppInfo.shared.user?.userId ?? "") { (success, info, result) in
            if success {
                let array = result!.value(forKey: "data")
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
        conf.userContentController.add(self as WKScriptMessageHandler, name: "huidaClick")
        conf.userContentController.add(self as WKScriptMessageHandler, name: "backHuidaClick")
        
        let newsWebView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 0), configuration: conf)
        newsWebView.uiDelegate = self
        newsWebView.navigationDelegate = self
        newsWebView.scrollView.isScrollEnabled = false
        newsWebView.scrollView.showsVerticalScrollIndicator = false
        
        return newsWebView
    }()
    
    lazy var newsTableView: WYPTableView = {
      
        let newAllTableView = WYPTableView()
        newAllTableView.backgroundColor = UIColor.white
        newAllTableView.delegate = self
        newAllTableView.dataSource = self
        newAllTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        newAllTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadCommentList(requestType: .loadMore)
        })
        newAllTableView.register(CommentDetailCommentCell.self, forCellReuseIdentifier: "replyCell")
        return newAllTableView
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
        commentTextField.font = UIFont.systemFont(ofSize: 14)
        commentTextField.delegate = self
        commentTextField.placeholder = "写下你的想法..."
        commentTextField.returnKeyType = .send
        commentTextField.returnKeyType = .send
        commentTextField.layer.masksToBounds = true
        commentTextField.layer.cornerRadius = 15
        commentTextField.backgroundColor = UIColor.init(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        let imageView = UIImageView(frame: CGRect(x: 10, y: 8, width: 16, height: 16))
        imageView.image = UIImage(named: "zx_icon_write_normal")
        commentTextField.addSubview(imageView)
        
        return commentTextField
    }()
    
    // 点赞
    lazy var collectionButton: SYButton = {
        let collectionButton = SYButton()
        collectionButton.setBackgroundImage(UIImage(named: "discuss_icon_dz_normal"), for: .normal)
        collectionButton.setBackgroundImage(UIImage(named: "discuss_icon_dzh_select"), for: .selected)
        collectionButton.addTarget(self, action: #selector(zanAction(sender:)), for: .touchUpInside)
        return collectionButton
    }()
    // 评论详情按钮
    lazy var commentDetailBtn: SYButton = {
        let commentDetailBtn = SYButton()
        commentDetailBtn.setBackgroundImage(UIImage(named: "newsDetail_button_normal_iPhone"), for: .normal)
        commentDetailBtn.addTarget(self, action: #selector(chickCommentDetail(sender:)), for: .touchUpInside)
        return commentDetailBtn
    }()
    
    
    // MARK: -分享按钮
    func shareBarButtonItemAction() {
        
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        
        let messageObject = UMSocialMessageObject()
        // 分享链接
        let url = String.init(format: "/Mob/news/gambit_detail_pinglun.html?news_id=%@&pid=%@&is_app=1&phone_type=1", newsId ?? "",pid ?? "")
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
    
    // MARK: -点击评论按钮
    func chickCommentDetail(sender: UIButton) {
        newsWebView.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: webContentHeight ?? 0)
        newsTableView.reloadData()
        let oneIndex = IndexPath(row: 0, section: 0)
        self.newsTableView.scrollToRow(at: oneIndex, at: .top, animated: true)
    }
    
    // MARK: -点击赞按钮
    func zanAction(sender: UIButton) {
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        NetRequest.topicStarNetRequest(openId: token, newsId: newsId ?? "", typeId: "2", cid: pid ?? "") { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info!)
                self.collectionButton.isSelected = true
                self.collectionButton.setBackgroundImage(UIImage(named: "discuss_icon_dzh_select"), for: .selected)
                
                self.zanNumberRequest()
            } else {
                SVProgressHUD.showError(withStatus: info!)
                
            }
        }
    }
    
    // MARK: -获得点赞数量
    func zanNumberRequest() {
        NetRequest.getTopicCommentDetailNetRequest(pid: pid ?? "") { (sucess, info, result) in
            if sucess {
                self.commentNumber = result?["comment_num"] as? String
                
                self.commentZanNumber = result?["like_num"] as? String
                self.newsTableView.reloadData()
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

extension TalkNewsDetailsCommentViewController: UITableViewDelegate, UITableViewDataSource {
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
            label.font = UIFont.systemFont(ofSize: 17)
            label.textColor = UIColor.init(hexColor: "afafaf")
            cell.addSubview(label)
            
            label.snp.makeConstraints({ (make) in
                make.centerX.equalTo(cell)
                make.size.equalTo(CGSize(width: kScreen_width, height: 40))
            })
            
            return cell
        } else {
            let cell = CommentDetailCommentCell(style: .default, reuseIdentifier: "TopicsViewIdentifier")
            let commentFrame = CommentDetailFrameModel()
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
            let commentFrame = CommentDetailFrameModel()
            commentFrame.comment = commentData[indexPath.row]
            return commentFrame.cellHeight ?? 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 50))
        headerView.backgroundColor = UIColor.white
        
        let commentNumLabel = UILabel()
        commentNumLabel.frame = CGRect(x: 15, y: 0, width: 60, height: 50)
        commentNumLabel.font = UIFont.systemFont(ofSize: 14)
        commentNumLabel.text = String.init(format: "评论 %@", commentNumber ?? "0")
        headerView.addSubview(commentNumLabel)

        
        let hotCommentLabel = UILabel(frame: CGRect(x: kScreen_width - 75, y: 0, width: 60, height: 50))
        hotCommentLabel.text = String.init(format: "%@赞", commentZanNumber ?? "0")
        hotCommentLabel.font = UIFont.systemFont(ofSize: 14)
        hotCommentLabel.textAlignment = NSTextAlignment.right
        headerView.addSubview(hotCommentLabel)
        
        let lineLabel = UILabel()
        lineLabel.frame = CGRect(x: 0, y: 49, width: kScreen_width, height: 1)
        lineLabel.backgroundColor = UIColor.groupTableViewBackground
        headerView.addSubview(lineLabel)
        
        return headerView
    }
    
    
    // MARK: -点击进入评论的评论列表
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = TalkCommentCommentViewController()
        let model = commentData[indexPath.row]
        vc.commentNumber = model.comment_num
        vc.commentModel = model
        vc.pid = model.commentId
        vc.newsId = self.newsId
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: -点击评论按钮
extension TalkNewsDetailsCommentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return false
        }
        NetRequest.topicsCommentNetRequest(openId: token, topicId: newsId ?? "", content: textField.text ?? "", pid:  pid ?? "") { (success, info) in
            if success {
                textField.resignFirstResponder()
                self.commentTextField.text = ""
                SVProgressHUD.showSuccess(withStatus: info!)
                
                self.zanNumberRequest()  //更行 评论数量
                self.loadCommentList(requestType: .update)
                
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
        return true
    }
}

// MARK: -点赞
extension TalkNewsDetailsCommentViewController: CommentDetailCommentCellDelegate {
    func commentReplyButtonDidSelected(sender: UIButton, comments: CommentModel) {
        let token = AppInfo.shared.user?.token ?? ""
        
        NetRequest.deleteCommentCommentNetRequest(openId: token, pid: comments.commentId ?? "") { (succeee, info, result) in
            if succeee {
                SVProgressHUD.showSuccess(withStatus: info!)
                
                self.commentNumber = "\(Int(self.commentNumber!)! - 1)"
                self.loadCommentList(requestType: .update)
            }else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
    
    
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
    

    // MARK: -进入个人资料页
    func commentPushButtonDidSelected(sender: UIButton, comments: CommentModel) {
        let personInfo = PersonalInformationViewController()
        personInfo.targetId = comments.uid ?? ""
        personInfo.name = comments.nickName ?? ""
        
        self.navigationController?.pushViewController(personInfo, animated: true)
    }
    
    
}

extension TalkNewsDetailsCommentViewController: WKUIDelegate,WKNavigationDelegate {
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
        wbScrollView?.bounces = false
        wbScrollView?.isScrollEnabled = true
        newsTableView.isHidden = false
    }
    
    // 获取高度
    func resetWebViewFrameWidthHeight(height: CGFloat) {
        // 如果是新高度，那就重置
        if height != webContentHeight {
            
            newsWebView.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: height)
//            if height >= kScreen_height {
//                newsWebView.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height + 100)
//            } else {
//                newsWebView.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: height)
//            }
            newsTableView.reloadData()
            webContentHeight = height
        }
    }
}




extension TalkNewsDetailsCommentViewController: WKScriptMessageHandler {
    
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
        
        // MARK: -回答
        if message.name == "huidaClick" {
            let vc = TalkNewsDetailsReplyViewController()
            vc.newsId = self.newsId
            vc.newsTitle = self.newsTitle
            navigationController?.pushViewController(vc, animated: true)
        }
        
        // MARK: -返回回答
        if message.name == "backHuidaClick" {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension TalkNewsDetailsCommentViewController: WBImageBrowserViewDelegate {
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
