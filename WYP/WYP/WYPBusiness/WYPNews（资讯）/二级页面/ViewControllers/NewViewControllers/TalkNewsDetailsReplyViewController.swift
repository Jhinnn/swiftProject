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
    
    //存放图片的数组
    var uploadImageArray = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        title = "评论"
    
        view.addSubview(textView)
        view.addSubview(commitButton)
        view.addSubview(lineView)
        bgView.addSubview(photoView)
        view.addSubview(bgView)
        
    }
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 15, y: 20, width: kScreen_width - 30, height: 150))
        textView.backgroundColor = UIColor.clear
        textView.placeholder = "感谢你的评论..."
        textView.placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    lazy var commitButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 320, width: kScreen_width - 30, height: 48)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
        button.backgroundColor = UIColor.init(hexColor: "DB3920")
        button.setTitle("提交", for: .normal)
        return button
    }()
    
    lazy var manager: HXPhotoManager = {
        let manager = HXPhotoManager(type: HXPhotoManagerSelectedTypePhoto)
        manager?.openCamera = true
        manager?.outerCamera = true
        manager?.photoMaxNum = 3
        manager?.maxNum = 3
        manager?.showFullScreenCamera = true
        return manager!
    }()
    
    lazy var lineView: UIView = {
        let view = UIView(frame: CGRect(x: 15, y: 180, width: kScreen_width - 15, height: 1))
        view.backgroundColor = UIColor.init(hexColor: "E8E8E8")
        return view
    }()
    
    lazy var bgView: UIView = {
        let view = UIView(frame: CGRect(x: 15, y: 190, width: kScreen_width - 30, height: 100))
        return view
    }()
    
    lazy var photoView: HXPhotoView = {
        let photoView = HXPhotoView(frame: CGRect(x: 0, y: 13, width: kScreen_width - 30, height: 100), with: self.manager)
        photoView?.delegate = self
        return photoView!
    }()

    
    func clickAction(sender: UIButton) {
        NetRequest.topicsCommentImagesNetRequest(openId: AppInfo.shared.user?.token ?? "", topicId: newsId ?? "", content: textView.text ?? "", pid: "", images: uploadImageArray) { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info)
                let time: TimeInterval = 0.8
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                SVProgressHUD.showError(withStatus: info!)
                
            }
        }
    }
    
}

extension TalkNewsDetailsReplyViewController: HXPhotoViewDelegate{
    func photoViewChangeComplete(_ allList: [HXPhotoModel]!, photos: [HXPhotoModel]!, videos: [HXPhotoModel]!, original isOriginal: Bool) {
        uploadImageArray.removeAll()
        for model in photos {
            uploadImageArray.append(model.thumbPhoto)
        }
    }
    
    func photoViewDeleteNetworkPhoto(_ networkPhotoUrl: String!) {
        
    }
    
    func photoViewUpdateFrame(_ frame: CGRect, with view: UIView!) {
        
    }
}
