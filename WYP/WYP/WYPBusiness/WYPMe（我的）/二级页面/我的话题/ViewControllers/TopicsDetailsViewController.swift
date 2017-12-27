//
//  TopicsDetailsViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/4/7.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol TopicsDetailsViewControllerDelegate {
    
    func starBtnAction(topicId: String, topicsFrame: TopicsFrameModel)
    
}

class TopicsDetailsViewController: BaseViewController {

    // 话题id
    var topicId: String?
    // 评论数据
    var commentData: [CommentModel]?
    // 话题内容
    var contentData: TopicsModel?
    
    var delegate: TopicsDetailsViewControllerDelegate?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        layoutPageSubviews()
        
        //获取数据
        loadDataSource(requestType: .update)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared().isEnabled = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - private method
    func viewConfig() {
        title = "话题详情"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "common_share_button_highlight_iPhone"), style: .done, target: self, action: #selector(shareBarButtonItemAction))
        
        view.addSubview(replyTableView)
        view.addSubview(commentView)
        commentView.addSubview(commentTextField)
    }
    
    func layoutPageSubviews() {
        replyTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 50, 0))
        }
        commentView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.size.equalTo(CGSize(width: kScreen_width, height: 50))
        }
        commentTextField.snp.makeConstraints { (make) in
            make.left.equalTo(commentView).offset(13)
            make.right.equalTo(commentView).offset(-13)
            make.centerY.equalTo(commentView)
            make.height.equalTo(35)
        }
    }
    
    func loadDataSource(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.topicDetailsNetRequest(page: "\(pageNumber)", uid: AppInfo.shared.user?.userId ?? "", topicId: topicId ?? "") { (success, info, result) in
            if success {
                self.commentTextField.text = ""
                self.commentTextField.resignFirstResponder()
                
                // 评论内容
                let array = result!.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                
                if requestType == .update {
                    self.commentData = [CommentModel].deserialize(from: jsonString) as? [CommentModel]
                } else {
                    // 把新数据添加进去
                    let commentArray = [CommentModel].deserialize(from: jsonString) as? [CommentModel]
                    self.commentData = self.commentData! + commentArray!
                }
                
                self.replyTableView.reloadData()
                
                self.replyTableView.reloadData()
                self.replyTableView.mj_header.endRefreshing()
                self.replyTableView.mj_footer.endRefreshing()
            } else {
                self.replyTableView.mj_header.endRefreshing()
                self.replyTableView.mj_footer.endRefreshing()
            }
        }
    }
    
    // MARK: - event response
    // 分享
    func shareBarButtonItemAction() {
        let messageObject = UMSocialMessageObject()
        
        // 分享链接
        let str = String.init(format: "Mob/News/gambit_detail.html?id=%@", topicId ?? "")
        let shareLink = kApi_baseUrl(path: str)
        // 设置文本
//        messageObject.text = contentData!.content! + shareLink
        // 分享对象
        let shareObject: UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: contentData?.content ?? "", descr: "在这里，总会找到你喜欢的话题，点进来看看吧", thumImage: UIImage(named: "aladdiny_icon"))
        // 网址
        shareObject.webpageUrl = shareLink
        messageObject.shareObject = shareObject
        
        // 传相关参数
        ShareManager.shared.loadShareAdv()
        ShareManager.shared.complaintId = topicId ?? ""
        ShareManager.shared.type = "5"
        
        ShareManager.shared.messageObject = messageObject
        ShareManager.shared.viewController = self
        ShareManager.shared.show()
    }

    func keyboardWillShow(note: NSNotification) {
        let userInfo = note.userInfo!
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {
            //键盘的偏移量
            self.commentView.transform = CGAffineTransform(translationX: 0 , y: -deltaY)
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else{
            animations()
        }
    }
    
    
    func keyboardWillHidden(note: NSNotification) {
        self.commentView.transform = CGAffineTransform(translationX: 0 , y: 0)
    }
    
    // MARK: - setter and getter
    lazy var replyTableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = UIColor.groupTableViewBackground
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        tableview.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadDataSource(requestType: .loadMore)
        })
        tableview.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadDataSource(requestType: .update)
        })
        tableview.register(TopicReplyTableViewCell.self, forCellReuseIdentifier: "replyCell")
        return tableview
    }()
    
    // 底部的view
    lazy var commentView: UIView = {
        let commentView = UIView()
        commentView.backgroundColor = UIColor.white
        return commentView
    }()
    // 评论框
    lazy var commentTextField: SYTextField = {
        let commentTextField = SYTextField()
        commentTextField.font = UIFont.systemFont(ofSize: 13)
        commentTextField.delegate = self
        commentTextField.borderStyle = .roundedRect
        commentTextField.placeholder = "期待你的神评论"
        commentTextField.returnKeyType = .send
        
        let imageView = UIImageView(frame: CGRect(x: 5, y: 10.75, width: 13.5, height: 13.5))
        imageView.image = UIImage(named: "common_editorGary_button_normal_iPhone")
        commentTextField.addSubview(imageView)
        
        return commentTextField
    }()
}


extension TopicsDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if commentData != nil {
            return commentData?.count ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! TopicReplyTableViewCell
        if commentData != nil {
            let topicsFrame = TopicsReplyFrameModel()
            cell.backgroundColor = UIColor.init(hexColor: "f1f2f4")
            topicsFrame.topics = commentData?[indexPath.row]
            cell.starCountButton.tag = indexPath.row + 130
            cell.topicsFrame = topicsFrame
            cell.selectionStyle = .none
            cell.delegate = self
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if commentData != nil {
            let topicsFrame = TopicsReplyFrameModel()
            topicsFrame.topics = commentData?[indexPath.row]
            return topicsFrame.cellHeight!
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TopicsCell()
        headerView.backgroundColor = UIColor.white
        headerView.delegate = self
        if contentData != nil {
            let topicFrame = TopicsFrameModel()
            topicFrame.topics = contentData
            headerView.topicsFrame = topicFrame
        }
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if contentData != nil {
            let topicsFrame = TopicsFrameModel()
            topicsFrame.topics = contentData
            return topicsFrame.cellHeight!
        }
        return 0
    }
}

extension TopicsDetailsViewController: TopicReplyTableViewCellDelegate {
    func replyStarDidSelected(sender: UIButton, commentReply: CommentModel) {
        // 话题评论点赞
        NetRequest.topicStarNetRequest(openId: AppInfo.shared.user?.token ?? "", newsId: contentData?.topicId ?? "", typeId: "2", cid: commentReply.commentId ?? "") { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info!)
                sender.isSelected = true
                sender.setTitle("\(Int(commentReply.zanNumber!)! + 1)", for: .normal)
                commentReply.isStar = "1"
                commentReply.zanNumber = "\(Int(commentReply.zanNumber!)! + 1)"
                
                self.replyTableView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
}

extension TopicsDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NetRequest.topicsCommentNetRequest(openId: AppInfo.shared.user?.token ?? "", topicId: contentData?.topicId ?? "", content: textField.text ?? "", pid: "") { (success, info) in
            if success {
                textField.resignFirstResponder()
                SVProgressHUD.showSuccess(withStatus: info!)
                self.loadDataSource(requestType: .update)
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

extension TopicsDetailsViewController: TopicsCellDelegate {
    func clickImageAction(sender: UIButton, topics: TopicsModel) {
        let personalInformationVC = PersonalInformationViewController()
        personalInformationVC.targetId = topics.peopleId ?? ""
        personalInformationVC.name = topics.nickName ?? ""
        navigationController?.pushViewController(personalInformationVC, animated: true)
    }
    

    func starDidSelected(sender: UIButton, topics: TopicsModel) {
        NetRequest.topicStarNetRequest(openId: AppInfo.shared.user?.token ?? "", newsId: topics.topicId ?? "", typeId: "1", cid: "") { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info!)
                sender.isSelected = true
                sender.setTitle("\(Int(topics.starCount!)! + 1)", for: .normal)
                topics.isStar = "1"
                topics.starCount = "\(Int(topics.starCount!)! + 1)"
                
                // 通知代理对象
                let topicsFrame = TopicsFrameModel()
                topicsFrame.topics = topics
                self.delegate?.starBtnAction(topicId: self.topicId!, topicsFrame: topicsFrame)
                
                self.replyTableView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
}


class SYTextField: UITextField {
    
    // 控制默认文本的位置(placeholder)
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 23.5, y: bounds.origin.y, width: bounds.size.width - 23.5, height: bounds.size.height)
    }
    
    // 控制编辑文本的位置
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 23.5, y: bounds.origin.y, width: bounds.size.width - 23.5, height: bounds.size.height)
        
    }
    
    // 控制显示文本的位置
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 23.5, y: bounds.origin.y, width: bounds.size.width - 23.5, height: bounds.size.height)
    }
    
    override func drawPlaceholder(in rect: CGRect) {
        
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)])
        
        super.drawPlaceholder(in: rect)
    }
}
