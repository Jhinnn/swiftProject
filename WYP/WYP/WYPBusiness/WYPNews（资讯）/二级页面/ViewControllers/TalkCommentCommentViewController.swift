//
//  TalkCommentCommentViewController.swift
//  WYP
//
//  Created by Arthur on 2018/1/18.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class TalkCommentCommentViewController: BaseViewController {
    
    //评论id
    var pid: String?
    //话题id
    var newsId: String?
    
    //第一个cell
    var commentModel: CommentModel?
    
    // 评论数据
    var commentData = [CommentModel]()
    
    //评论数量
    var commentNumber: String?
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
       
        layoutPageSubviews()
        
        loadCommentList(requestType: .update)
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
                    self.commentData.insert(self.commentModel!, at: 0)
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
    
    func layoutPageSubviews() {
        view.addSubview(newsTableView)
        view.addSubview(interactionView)
        interactionView.addSubview(commentTextField)
        newsTableView.snp.makeConstraints { (make) in
            if deviceTypeIPhoneX() {
                make.edges.equalTo(UIEdgeInsetsMake(44, 0, 34, 0))
            }else {
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 59, 0))
            }
        }
        
        interactionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(59)
        }
        
        commentTextField.snp.makeConstraints { (make) in
            if deviceTypeIPhoneX() {
                make.centerY.equalTo(interactionView.snp.centerY).offset(-4)
            }else {
                make.centerY.equalTo(interactionView.snp.centerY)
            }
            
            make.left.equalTo(interactionView).offset(13)
            make.right.equalTo(interactionView).offset(-13)
            make.height.equalTo(34)
        }
    }
    
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
    
    
    lazy var newsTableView: WYPTableView = {
        
        let newAllTableView = WYPTableView()
        newAllTableView.backgroundColor = UIColor.white
        newAllTableView.delegate = self
        newAllTableView.dataSource = self
        newAllTableView.tableFooterView = UIView()
        newAllTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
                self.loadCommentList(requestType: .loadMore)
        })
        
      
        
        newAllTableView.register(CommentDetailCommentCell.self, forCellReuseIdentifier: "replyCell")
        return newAllTableView
    }()
    
}

extension TalkCommentCommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    
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
            cell.replyCountLabel.isHidden = true
            if indexPath.row == 0 {
                
                cell.contentView.backgroundColor = UIColor.white
                
            }else {
                cell.contentView.backgroundColor = UIColor.init(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
            }
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
        
        
        let closeBtn = UIButton()
        closeBtn.frame = CGRect(x: 10, y: 10, width: 40, height: 30)
        closeBtn.setImage(UIImage.init(named: "huifu_icon_guanbi"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        headerView.addSubview(closeBtn)
    
        let hotCommentLabel = UILabel(frame: CGRect(x: (kScreen_width - 200) / 2 , y: 0, width: 200, height: 50))
        hotCommentLabel.font = UIFont.systemFont(ofSize: 17)
        hotCommentLabel.text = "评论详情(\(self.commentNumber ?? ""))"
        hotCommentLabel.textAlignment = NSTextAlignment.center
        headerView.addSubview(hotCommentLabel)
    
        return headerView
    }
    
    // MARK: -下拉退出
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if deviceTypeIPhoneX() {
            if offsetY < -50 {
                self.dismiss(animated: true, completion: {
                    
                })
            }
        }else {
            if offsetY < -30 {
                self.dismiss(animated: true, completion: {
                    
                })
            }
        }
        
    }
    
    
    func closeAction() {
        self.dismiss(animated: true) {
            
        }
    }
    

}

// MARK: -cell delegate
extension TalkCommentCommentViewController: CommentDetailCommentCellDelegate {
    
    // MARK: 点赞
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
    
    // MARK: 删除
    func commentReplyButtonDidSelected(sender: UIButton, comments: CommentModel) {
        let token = AppInfo.shared.user?.token ?? ""
        
        
        
        NetRequest.deleteCommentCommentNetRequest(openId: token, pid: comments.commentId ?? "") { (succeee, info, result) in
            if succeee {
                SVProgressHUD.showSuccess(withStatus: info!)
                
                if Int(self.commentNumber!)! == 0 {
                    self.dismiss(animated: true, completion: {
                        
                    })
                    return
                }
                
                self.commentNumber = "\(Int(self.commentNumber!)! - 1)"
                self.loadCommentList(requestType: .update)
            }else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
    
    func commentPushButtonDidSelected(sender: UIButton, comments: CommentModel) {
        let personInfo = PersonalInformationViewController()
        personInfo.targetId = comments.uid ?? ""
        personInfo.name = comments.nickName ?? ""
        
        self.navigationController?.pushViewController(personInfo, animated: true)
    }
    
   
    
}

// MARK: -点击评论按钮
extension TalkCommentCommentViewController: UITextFieldDelegate {
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
                
                self.commentNumber = "\(Int(self.commentNumber!)! + 1)"
                
                self.loadCommentList(requestType: .update)
                
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
        return true
    }

}


