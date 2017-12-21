//
//  TalkNewsDetailsReplyViewController.swift
//  WYP
//
//  Created by Arthur on 2017/12/21.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class TalkNewsDetailsReplyViewController: BaseViewController {
    
    // 新闻id
    var newsId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        title = "评论"
    
        view.addSubview(textView)
        view.addSubview(commitButton)
    }
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 15, y: 20, width: kScreen_width - 30, height: 100))
        textView.backgroundColor = UIColor.clear
        textView.placeholder = "感谢你的评论..."
        textView.placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    lazy var commitButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 150, width: kScreen_width - 30, height: 48)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
        button.backgroundColor = UIColor.init(hexColor: "DB3920")
        button.setTitle("提交", for: .normal)
        return button
    }()

    
    func clickAction(sender: UIButton) {
        NetRequest.topicsCommentNetRequest(openId: AppInfo.shared.user?.token ?? "", topicId: newsId ?? "", content: textView.text ?? "", pid: "") { (success, info) in
            if success {
//                textView.resignFirstResponder()
            
                SVProgressHUD.showSuccess(withStatus: info!)
//                self.loadCommentList(requestType: .update)
                self.navigationController?.popViewController(animated: true)
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
    
}
