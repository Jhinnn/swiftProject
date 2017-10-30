//
//  IssueTopicViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/4/4.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol IssueTopicViewControllerDelegate {
    func issueTopicsSuccess()
}

class IssueTopicViewController: BaseViewController {

    var delegate: IssueTopicViewControllerDelegate! = nil
    
    @IBOutlet weak var textView: UITextView!
    
    var typeIdStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textView.placeholder = "请输入话题内容"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    deinit {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - event response
    func keyboardWillShow(note: NSNotification) {
        let userInfo = note.userInfo!
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let deltaY = keyBoardBounds.size.height - 200
        let animations:(() -> Void) = {
            if deviceTypeIphone5() || deviceTypeIPhone4() {
                //键盘的偏移量
                self.textView.transform = CGAffineTransform(translationX: 0 , y: -deltaY)
            }
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else{
            animations()
        }
    }
    
    
    func keyboardWillHidden(note: NSNotification) {
        self.textView.transform = CGAffineTransform(translationX: 0 , y: 0)
    }
    
    @IBAction func typeButtonAction(_ sender: UIButton) {
        // 取消上一个选中按钮的背景颜色
        let index: Int = (Int(typeIdStr) ?? 0) + 200
        let lastButton = view.viewWithTag(index)
        lastButton?.backgroundColor = UIColor.init(hexColor: "#D3D7D8")
        // 设置新的选中按钮的背景颜色
        sender.backgroundColor = UIColor.themeColor
        
        typeIdStr = "\(sender.tag - 200)"
    }
    
    @IBAction func issueButtonAction(_ sender: UIButton) {
//        if textView.text.characters.count > 100 {
//            SVProgressHUD.showError(withStatus: "内容过多，请控制在50字以内")
//            return
//        } else if textView.text.characters.count < 1 {
//            SVProgressHUD.showError(withStatus: "内容不能为空")
//            return
//        }
        // 13:演出文化 14:旅游文化 15:体育文化 16:电影文化 17:会展文化 18:饮食文化
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        NetRequest.issueTopicNetRequest(token: token, typeId: typeIdStr, text: textView.text) { (success, info) in
            if success {
                // 发布成功
                self.delegate?.issueTopicsSuccess()
                SVProgressHUD.showSuccess(withStatus: info)
                self.navigationController?.popViewController(animated: true)
            } else {
                // 发布失败
                SVProgressHUD.showError(withStatus: info)
            }
//            Integer
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension IssueTopicViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
