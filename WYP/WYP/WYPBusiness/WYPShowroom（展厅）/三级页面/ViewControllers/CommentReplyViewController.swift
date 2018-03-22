//
//  CommentReplyViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/25.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class CommentReplyViewController: BaseViewController {

    // 展厅id
    var roomId: String?
    // 资讯id
    var newsId: String?
    // 区分资讯和展厅
    var flag = 0
    // 二级评论数据
    var secComment: [CommentModel]?
    // 评论内容
    var commentData: CommentModel?
    
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared().isEnabled = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - private method
    func viewConfig() {
        title = "评论详情"
        
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
            make.bottom.equalTo(commentView).offset(-10)
            make.left.equalTo(commentView).offset(13)
            make.right.equalTo(commentView).offset(-15)
            make.height.equalTo(30)
        }
    }
    
    func loadDataSource(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        
        if flag == 2 { // 资讯二级评论
            NetRequest.newsCommentDetailNetRequest(page: "\(pageNumber)", pid: commentData?.commentId ?? "", uid: AppInfo.shared.user?.userId ?? "", complete: { (success, info, result) in
                if success {
                    let array = result!.value(forKey: "data")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    if requestType == .update {
                        self.secComment = [CommentModel].deserialize(from: jsonString) as? [CommentModel]
                    } else {
                        // 把新数据添加进去
                        let secCommentArray = [CommentModel].deserialize(from: jsonString) as? [CommentModel]
                        self.secComment = self.secComment! + secCommentArray!
                    }
                    self.replyTableView.reloadData()
                    self.replyTableView.mj_header.endRefreshing()
                    self.replyTableView.mj_footer.endRefreshing()
                } else {
                    self.replyTableView.mj_header.endRefreshing()
                    self.replyTableView.mj_footer.endRefreshing()
                }
            })
        } else if flag == 3 { // 展厅资讯二级评论
        
            NetRequest.roomNewsSecCommentListNetRequest(uid: AppInfo.shared.user?.userId ?? "", pid: commentData?.commentId ?? "", page: "\(pageNumber)", complete: { (success, info, result) in
                if success {
                    let array = result!.value(forKey: "data")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    if requestType == .update {
                        self.secComment = [CommentModel].deserialize(from: jsonString) as? [CommentModel]
                    } else {
                        // 把新数据添加进去
                        
                        let secCommentArray = [CommentModel].deserialize(from: jsonString) as? [CommentModel]
                        self.secComment = self.secComment! + secCommentArray!
                    }
                    self.replyTableView.reloadData()
                    self.replyTableView.mj_header.endRefreshing()
                    self.replyTableView.mj_footer.endRefreshing()
                } else {
                    self.replyTableView.mj_header.endRefreshing()
                    self.replyTableView.mj_footer.endRefreshing()
                }

            })
            
        } else { // 展厅详情二级评论
            
            NetRequest.showRoomCommentDetailNetRequest(page: "\(pageNumber)", pid: commentData?.commentId ?? "", uid: AppInfo.shared.user?.userId ?? "") { (success, info, result) in
                if success {
                    let array = result!.value(forKey: "data")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    if requestType == .update {
                        self.secComment = [CommentModel].deserialize(from: jsonString) as? [CommentModel]
                    } else {
                        // 把新数据添加进去
                        
                        let secCommentArray = [CommentModel].deserialize(from: jsonString) as? [CommentModel]
                        self.secComment = self.secComment! + secCommentArray!
                    }
                    
                    self.replyTableView.reloadData()
                    self.replyTableView.mj_header.endRefreshing()
                    self.replyTableView.mj_footer.endRefreshing()
                } else {
                    self.replyTableView.mj_header.endRefreshing()
                    self.replyTableView.mj_footer.endRefreshing()
                }
            }
        }
    }
    
    // MARK: - event response
    
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
        tableview.allowsSelection = false
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
        
        let imageView = UIImageView(frame: CGRect(x: 5, y: 8.25, width: 13.5, height: 13.5))
        imageView.image = UIImage(named: "common_editorGary_button_normal_iPhone")
        commentTextField.addSubview(imageView)

        return commentTextField
    }()

}


extension CommentReplyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secComment?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! TopicReplyTableViewCell
        if commentData != nil {
            let topicsFrame = TopicsReplyFrameModel()
            cell.backgroundColor = UIColor.init(hexColor: "f1f2f4")
            topicsFrame.topics = secComment?[indexPath.row]
            cell.starCountButton.tag = indexPath.row + 130
            cell.topicsFrame = topicsFrame
            cell.delegate = self
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if commentData != nil {
            let topicsFrame = TopicsReplyFrameModel()
            topicsFrame.topics = secComment?[indexPath.row]
            return topicsFrame.cellHeight!
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ShowRoomCommentCell()
        headerView.backgroundColor = UIColor.white
        headerView.delegate = self
        if commentData != nil {
            let commentFrame = RoomCommentFrameModel()
            commentFrame.comment = commentData
            headerView.commentFrame = commentFrame
        }
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if commentData != nil {
            let commentFrame = RoomCommentFrameModel()
            commentFrame.comment = commentData
            return commentFrame.cellHeight!
        }
        return 0
    }

}

extension CommentReplyViewController: TopicReplyTableViewCellDelegate {
    func replyStarDidSelected(sender: UIButton, commentReply: CommentModel) {
        if flag == 3 { // 展厅详情 - 资讯详情
            NetRequest.roomNewsThumbUpNetRequest(commentId: commentReply.commentId ?? "", uid: AppInfo.shared.user?.userId ?? "") { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    sender.isSelected = true
                    commentReply.isStar = "1"
                    commentReply.zanNumber = "\(Int(commentReply.zanNumber!)! + 1)"
                    self.replyTableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
            
        } else if flag == 2 {
            // 资讯详情二级评论点赞
            NetRequest.topicStarNetRequest(openId: AppInfo.shared.user?.token ?? "", newsId: newsId ?? "", typeId: "2", cid: commentReply.commentId ?? "") { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info!)
                    sender.isSelected = true
                    commentReply.isStar = "1"
                    commentReply.zanNumber = "\(Int(commentReply.zanNumber!)! + 1)"
                    self.replyTableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            }
        } else {
            // 展厅详情点赞
            NetRequest.thumbUpNetRequest(id: commentReply.commentId ?? "", uid: AppInfo.shared.user?.userId ?? "") { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    sender.isSelected = true
                    commentReply.isStar = "1"
                    commentReply.zanNumber = "\(Int(commentReply.zanNumber!)! + 1)"
                    self.replyTableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
        }
    }
}

extension CommentReplyViewController: ShowRoomCommentCellDelegate {
    func commentPushButtonDidSelected(sender: UIButton, comments: CommentModel) {
        let personInfo = PersonalInformationViewController()
        personInfo.targetId = comments.uid ?? ""
        personInfo.name = comments.nickName ?? ""
        self.navigationController?.pushViewController(personInfo, animated: true)
    }
    
    func commentReplyStarDidSelected(sender: UIButton, comments: CommentModel) {
        
        if flag == 3 { // 展厅详情 - 资讯详情
            NetRequest.roomNewsThumbUpNetRequest(commentId: comments.commentId ?? "", uid: AppInfo.shared.user?.userId ?? "") { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    sender.isSelected = true
                    comments.isStar = "1"
                    comments.zanNumber = "\(Int(comments.zanNumber!)! + 1)"
                    self.replyTableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }

        } else if flag == 2 {
            // 资讯详情二级评论点赞
            NetRequest.topicStarNetRequest(openId: AppInfo.shared.user?.token ?? "", newsId: newsId ?? "", typeId: "2", cid: comments.commentId ?? "") { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info!)
                    sender.isSelected = true
                    comments.isStar = "1"
                    comments.zanNumber = "\(Int(comments.zanNumber!)! + 1)"
                    self.replyTableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            }
        } else {
            // 展厅详情点赞
            NetRequest.thumbUpNetRequest(id: comments.commentId ?? "", uid: AppInfo.shared.user?.userId ?? "") { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    sender.isSelected = true
                    comments.isStar = "1"
                    comments.zanNumber = "\(Int(comments.zanNumber!)! + 1)"
                    self.replyTableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
        }
    }

    func commentReplyButtonDidSelected(sender: UIButton) {
        
    }
}

extension CommentReplyViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.count)! < 0 {
            SVProgressHUD.showError(withStatus: "评论内容不能为空！")
            return false
        }
        let commentId = commentData?.commentId ?? ""
        print(commentId)
        if flag == 2 { // 资讯详情二级评论
            NetRequest.topicsCommentNetRequest(openId: AppInfo.shared.user?.token ?? "", topicId: newsId ?? "", content: textField.text ?? "", pid: commentId, complete: { (success, info) in
                if success {
                    textField.text = ""
                    textField.resignFirstResponder()
                    SVProgressHUD.showSuccess(withStatus: info!)
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
                self.loadDataSource(requestType: .update)
            })
            
        } else if flag == 3 {
            // 展厅详情资讯详情二级评论
            NetRequest.roomNewsCommentNetRequest(pid: commentId, newId: newsId ?? "", uid: AppInfo.shared.user?.userId ?? "" , comment: textField.text ?? "", complete: { (success, info) in
                if success {
                    textField.text = ""
                    textField.resignFirstResponder()
                    SVProgressHUD.showSuccess(withStatus: info!)
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
                self.loadDataSource(requestType: .update)
            })
            
        } else {
            // 展厅详情二级评论
            NetRequest.issueCommentNetRequest(openId: AppInfo.shared.user?.token ?? "", groupId: roomId ?? "", content: textField.text ?? "", pid: commentId) { (success, info, result) in
                if success {
                    textField.text = ""
                    textField.resignFirstResponder()
                    SVProgressHUD.showSuccess(withStatus: info!)
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
                self.loadDataSource(requestType: .update)
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
