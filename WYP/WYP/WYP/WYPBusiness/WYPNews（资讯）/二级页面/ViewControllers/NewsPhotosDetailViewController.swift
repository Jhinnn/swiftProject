//
//  NewsPhotosDetailViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/4.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class NewsPhotosDetailViewController: BaseViewController {

    var imageArray: [String]?
    var contentArray: [String]?
    var currentIndex: NSInteger = 0
    // 标记
    var flag = 0
    // 评论数
    var commentNumber: String?

    // 图集视图
    var pictureBrowserView: WBImageBrowserView?
    
    // 资讯Id
    var newsId: String?
    // 新闻标题
    var newsTitle: String?
    // 是否关注改图集
    var isFollow: String? {
        willSet {
            if newValue == "1" {
                collectionButton.isSelected = true
            }
        }
    }
    
    // 记录上一次的屏幕状态
    var lastOrienation: UIDeviceOrientation = UIDeviceOrientation.portrait
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 推送资讯入口
        let push = UserDefaults.standard.object(forKey: "PhotoPush") as? String
        if push == "PhotoPush" {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "common_navback_button_normal_iPhone"), style: .done, target: self, action: #selector(rebackToRootViewAction(sender:)))
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = true
        
        IQKeyboardManager.shared().isEnabled = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        viewConfig()
        
        seePicture()
        addNotificationCenter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let window = UIApplication.shared.keyWindow!
        window.backgroundColor = UIColor.themeColor
        // 强制翻转屏幕，Home键在下边
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
        IQKeyboardManager.shared().isEnabled = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(orientation), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    // 处理旋转过程中需要的操作
    func orientation(notification: NSNotification) {
        
        let orientation = UIDevice.current.orientation
        var newVCH = kScreen_height
        var newVCW = kScreen_width
        
        switch orientation {
        case .portrait:
            
            print(lastOrienation.isPortrait)
            
            if lastOrienation != orientation {

                // 屏幕竖直
                print("屏幕竖直")
                
                newVCH = kScreen_height
                newVCW = kScreen_width
                
                interactionView.snp.updateConstraints({ (make) in
                    make.height.equalTo(160)
                })
                commentTextField.snp.updateConstraints({ (make) in
                    make.height.equalTo(30)
                })
                collectionButton.isHidden = false
                commentDetailBtn.isHidden = false
                
                pictureBrowserView?.orientation = orientation
            }
            
            
        case .landscapeLeft:
            // 屏幕向左转
            print("屏幕向左转")
            // 横屏
            newVCH = kScreen_width
            newVCW = kScreen_height
            
            interactionView.snp.updateConstraints({ (make) in
                make.height.equalTo(80)
            })
            commentTextField.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            collectionButton.isHidden = true
            commentDetailBtn.isHidden = true
            
            pictureBrowserView?.orientation = orientation
            
        case .landscapeRight:
            // 屏幕向右转
            print("屏幕向右转")
            // 横屏
            newVCH = kScreen_width
            newVCW = kScreen_height

            interactionView.snp.updateConstraints({ (make) in
                make.height.equalTo(80)
            })
            commentTextField.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            collectionButton.isHidden = true
            commentDetailBtn.isHidden = true
            
            pictureBrowserView?.orientation = orientation
            
        default:
            break
        }
        
        self.view.frame = CGRect(x: 0, y: 0, width: newVCW, height: newVCH)
        
        lastOrienation = orientation
        print(lastOrienation.isPortrait)
    }
    
    // MARK: - private method
    func viewConfig() {
        let window = UIApplication.shared.keyWindow!
        window.backgroundColor = UIColor.black
        self.view.backgroundColor = UIColor.black
        
        pictureBrowserView = WBImageBrowserView.pictureBrowsweView(withFrame: CGRect(x: 0, y: -64, width: kScreen_width, height: kScreen_height), delegate: self, browserInfoArray: imageArray)
        pictureBrowserView?.orientation = UIDevice.current.orientation
        pictureBrowserView?.viewController = self
        pictureBrowserView?.startIndex = currentIndex
        pictureBrowserView?.show(in: window)
        
        window.addSubview(interactionView)
        interactionView.addSubview(collectionButton)
        interactionView.addSubview(commentDetailBtn)
        interactionView.addSubview(commentTextField)
        interactionView.addSubview(contentLabel)
    
        interactionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(window)
            make.height.equalTo(160)
        }
        collectionButton.snp.makeConstraints { (make) in
            make.right.equalTo(interactionView).offset(-15)
            make.bottom.equalTo(interactionView).offset(-14.5)
            make.size.equalTo(CGSize(width: 19.5, height: 19.5))
        }
        commentDetailBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(interactionView).offset(-13)
            make.right.equalTo(collectionButton.snp.left).offset(-10)
            make.size.equalTo(CGSize(width: 19.5, height: 19.5))
        }
        commentTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(interactionView).offset(-10)
            make.left.equalTo(interactionView).offset(13)
            make.right.equalTo(commentDetailBtn.snp.left).offset(-15)
            make.height.equalTo(30)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(commentTextField.snp.top).offset(-10)
            make.left.equalTo(interactionView).offset(13)
            make.right.equalTo(interactionView).offset(-13)
        }
        
        // 添加评论数
        commentDetailBtn.badgeLabel.frame = CGRect(x: 9, y: -2, width: 15, height: 8)
        commentDetailBtn.badgeLabel.text = commentNumber ?? "0"
        commentDetailBtn.addSubview(commentDetailBtn.badgeLabel)
    }
    
    // 浏览图集
    func seePicture() {
        NetRequest.pictureSeeNetRequest(newsId: newsId ?? "") { (success, info) in
            if success {
                self.contentLabel.text = String.init(format: "1/%d %@", self.imageArray?.count ?? 0, self.contentArray?[0] ?? "")
                self.contentLabel.attributedText = self.changeTextFont(text: self.contentLabel.text ?? "")
            } else {
                print(info!)
            }
        }
    }
    
    // MARK: - event response
    // 返回
    func rebackToRootViewAction(sender: UIBarButtonItem) {
        let pushJudge = UserDefaults.standard
        pushJudge.set("", forKey: "PhotoPush")
        pictureBrowserView?.removeFromSuperview()
        interactionView.removeFromSuperview()
        
        self.dismiss(animated: false, completion: nil)
    }
    // 分享
    func shareBarButtonItemAction() {
        
        let uid = AppInfo.shared.user?.userId ?? ""
        if uid == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        
        let messageObject = UMSocialMessageObject()
        // 分享链接
        let str = String.init(format: "Mob/news/index.html?news_id=%@&is_app=1", newsId ?? "")
        let shareLink = kApi_baseUrl(path: str)
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

    
    func backAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionNews(sender: UIButton) {
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        if sender.isSelected {
            NetRequest.cancelAttentionNetRequest(openId: token, newsId: newsId ?? "", complete: { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info!)
                    sender.isSelected = false
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            })
        } else if !sender.isSelected {
            NetRequest.collectionNewsNetRequest(openId: token, newsId: newsId ?? "") { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info!)
                    sender.isSelected = true
                    sender.setImage(UIImage(named: "common_collection_button_selected_iPhone"), for: .selected)
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            }
        }
    }
    
    func chickCommentDetail(sender: UIButton) {
        pictureBrowserView?.removeFromSuperview()
        interactionView.removeFromSuperview()
        
        let photoComment = PhotosCommentsDetailViewController()
        photoComment.newsId = newsId
        navigationController?.pushViewController(photoComment, animated: true)
    }
    
    // MARK: - setter and getter
    // 背景
    lazy var interactionView: UIView = {
        let interactionView = UIView()
        interactionView.backgroundColor = UIColor.black
        interactionView.alpha = 0.65
        interactionView.isUserInteractionEnabled = true
        return interactionView
    }()
    // 图片匹配的信息
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.textColor = UIColor.white
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        return contentLabel
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
    // 收藏
    lazy var collectionButton: UIButton = {
        let collectionButton = UIButton()
        collectionButton.setBackgroundImage(UIImage(named: "common_collection_button_normal_iPhone"), for: .normal)
        collectionButton.setBackgroundImage(UIImage(named: "common_collection_button_selected_iPhone"), for: .selected)
        collectionButton.addTarget(self, action: #selector(collectionNews(sender:)), for: .touchUpInside)
        return collectionButton
    }()
    
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
    
    func changeTextFont(text: String) -> NSMutableAttributedString{
        let nsText = text as NSString
        
        let attributedString = NSMutableAttributedString(string: text)
        
        let arr = nsText.components(separatedBy: " ")
        let contentNum = arr[0] as NSString
        let textRange = NSMakeRange(0, contentNum.length)
        nsText.enumerateSubstrings(in: textRange, options: .byLines) { (subString, subStringRange, _, _) in
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20), range: subStringRange)
        }
        return attributedString
    }
}

extension NewsPhotosDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return false
        }
        NetRequest.topicsCommentNetRequest(openId: token, topicId: newsId ?? "", content: textField.text ?? "", pid: "") { (success, info) in
            if success {
                textField.resignFirstResponder()
                SVProgressHUD.showSuccess(withStatus: info!)
                self.commentTextField.resignFirstResponder()
                self.commentTextField.text = ""
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if PublicGroupViewController().stringContainsEmoji(string) {
            if PublicGroupViewController().isNineKeyBoard(string) {
                return true
            }
            SVProgressHUD.showError(withStatus: "暂不支持特殊字符")
            return false
        }
        return true
    }
}

extension NewsPhotosDetailViewController: WBImageBrowserViewDelegate {
    func getContentWithItem(_ item: Int) {
        contentLabel.text = String.init(format: "%d/%d %@", item + 1, contentArray?.count ?? 0, contentArray?[item] ?? "")
        self.contentLabel.attributedText = self.changeTextFont(text: self.contentLabel.text ?? "")
    }
    func backButtonToClick() {
        pictureBrowserView?.removeFromSuperview()
        interactionView.removeFromSuperview()
        if flag == 100 {
            self.dismiss(animated: false, completion: nil)
        } else {
            navigationController?.popViewController(animated: false)
        }
    }
    func shareButtonToClick() {
        shareBarButtonItemAction()
    }
}
