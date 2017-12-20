//
//  PhotosCommentsDetailViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/6/5.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class PhotosCommentsDetailViewController: BaseViewController {

    // 图集Id
    var newsId: String?
    // 评论内容
    var commentData = [CommentModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfig()
        loadCommentList(requestType: .update)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - private method
    func viewConfig() {
        title = "评论"
        view.addSubview(newsTableView)
        
        newsTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }

    // 获取评论列表
    func loadCommentList(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.newsCommentListNetRequest(page: "\(pageNumber)", newsId: newsId ?? "", uid: AppInfo.shared.user?.userId ?? "") { (success, info, result) in
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
                
                // 先移除再添加
                self.noDataImageView.removeFromSuperview()
                self.noDataLabel.removeFromSuperview()
                // 没有数据的情况
                self.view.addSubview(self.noDataImageView)
                self.view.addSubview(self.noDataLabel)
                self.noDataImageView.snp.makeConstraints { (make) in
                    if deviceTypeIphone5() || deviceTypeIPhone4() {
                        make.top.equalTo(self.view).offset(130)
                    }
                    make.top.equalTo(self.view).offset(180)
                    make.centerX.equalTo(self.view)
                    make.size.equalTo(CGSize(width: 100, height: 147))
                }
                self.noDataLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(self.noDataImageView.snp.bottom).offset(20)
                    make.centerX.equalTo(self.view)
                    make.height.equalTo(11)
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
        tableView.tableFooterView = UIView()
        tableView.register(ShowRoomCommentCell.self, forCellReuseIdentifier: "replyCell")
        
        return tableView
    }()
    
    // 没有数据时的图片
    lazy var noDataImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "common_noResult_icon_normal_iPhone")
        return imageView
    }()
    // 没有找到结果
    lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "暂无评论"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
}

extension PhotosCommentsDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if commentData.count == 0 {
            noDataLabel.isHidden = false
            noDataImageView.isHidden = false
        } else {
            noDataLabel.isHidden = true
            noDataImageView.isHidden = true
        }
        return commentData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ShowRoomCommentCell(style: .default, reuseIdentifier: "TopicsViewIdentifier")
        let commentFrame = RoomCommentFrameModel()
        commentFrame.comment = commentData[indexPath.row]
        cell.starCountButton.tag = indexPath.row + 180
        cell.replyButton.tag = indexPath.row + 190
        cell.delegate = self
        cell.commentFrame = commentFrame
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let commentFrame = RoomCommentFrameModel()
        commentFrame.comment = commentData[indexPath.row]
        return commentFrame.cellHeight ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let commentReply = CommentReplyViewController()
        commentReply.flag = 2
        commentReply.newsId = newsId ?? ""
        commentReply.commentData = commentData[indexPath.row]
        navigationController?.pushViewController(commentReply, animated: true)
    }
}

extension PhotosCommentsDetailViewController: ShowRoomCommentCellDelegate {
    // 点赞按钮
    func commentReplyStarDidSelected(sender: UIButton, comments: CommentModel) {
        let uid = AppInfo.shared.user?.userId ?? ""
        if uid == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        NetRequest.thumbUpNetRequest(id: comments.commentId ?? "", uid: uid) { (success, info) in
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
        commentReply.flag = 2
        commentReply.newsId = newsId ?? ""
        commentReply.commentData = commentData[sender.tag - 190]
        navigationController?.pushViewController(commentReply, animated: true)
    }
}
