//
//  IssueCommentViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/25.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class IssueCommentViewController: BaseViewController {
    
    var roomId: String?
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfig()
        layoutPageSubviews()
    }

    // MARK: - private method
    func viewConfig() {
        title = "发布评论"
        
        view.addSubview(commentTextView)
        view.addSubview(issueButton)
    }
    func layoutPageSubviews() {
        commentTextView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(0)
            make.left.right.equalTo(view)
            make.height.equalTo(230)
        }
        issueButton.snp.makeConstraints { (make) in
            make.top.equalTo(commentTextView.snp.bottom).offset(60)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 276, height: 46))
        }
    }
    
    // 发布展厅评论
    func issueComment(sender: UIButton) {
        if commentTextView.text.characters.count < 5 {
            SVProgressHUD.showError(withStatus: "评论内容不少于5个字")
            return
        }
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        NetRequest.issueCommentNetRequest(openId: token, groupId: roomId ?? "", content: commentTextView.text, pid: "") { (success, info, result) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info!)
                self.navigationController?.popViewController(animated: true)
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
    
    // MARK: - setter and getter
    lazy var commentTextView: UITextView = {
       let commentTextView = UITextView()
        commentTextView.frame = CGRect(x: 0, y: 64, width: kScreen_width, height: 260)
        commentTextView.font = UIFont.systemFont(ofSize: 15)
        commentTextView.placeholder = "请输入评论内容，内容不少于5个字"
        commentTextView.delegate = self
        
        return commentTextView
    }()
    
    lazy var issueButton: UIButton = {
        let issueButton = UIButton(type: .custom)
        issueButton.layer.cornerRadius = 8.0
        issueButton.layer.masksToBounds = true
        issueButton.backgroundColor = UIColor.themeColor
        issueButton.setTitle("发布", for: .normal)
        issueButton.setTitleColor(UIColor.white, for: .normal)
        issueButton.addTarget(self, action: #selector(issueComment(sender:)), for: .touchUpInside)
        return issueButton
    }()

}

extension IssueCommentViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
}
