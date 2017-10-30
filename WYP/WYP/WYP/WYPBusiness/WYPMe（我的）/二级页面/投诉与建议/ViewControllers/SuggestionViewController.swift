//
//  SuggestionViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/4/1.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class SuggestionViewController: BaseViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.placeholder = "请输入您遇到的问题和想要给我们提的意见和建议，我们会更好的为您服务。"
        textView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let manager = IQKeyboardManager.shared()
        manager.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let manager = IQKeyboardManager.shared()
        manager.isEnabled = true
    }
    
    //
    @IBAction func submitBtnAction(_ sender: UIButton) {
        
        NetRequest.feedbackIdeaNetRequest(token: AppInfo.shared.user?.token ?? "", text: textView.text ?? "", pid: "", vyid: "") { (success, info) in
            if success {
                // 反馈成功
                SVProgressHUD.showSuccess(withStatus: info)
                self.navigationController?.popViewController(animated: true)
            } else {
                // 反馈失败
                SVProgressHUD.showError(withStatus: info)
            }
        }
    }

    @IBAction func feedBackRecord(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(FeedBackRecordViewController(), animated: true)
    }
}

extension SuggestionViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
