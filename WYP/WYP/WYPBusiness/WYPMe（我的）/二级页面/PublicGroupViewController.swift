//
//  PublicGroupViewController.swift
//  WYP
//
//  Created by Arthur on 2017/12/18.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class PublicGroupViewController: BaseViewController{
    
    
    var typeid: String!
    
    var uid: String!
    var userToken: String!
    var post_topic: String!
    
    //选中的button
    var selectedBtn: UIButton!
    
    //存放图片的数组
    var uploadImageArray = [UIImage]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "发布话题"
        // 创建注册Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .done, target: self, action: #selector(publicButtonItemAction))
        
        view.addSubview(scrollView)
//        scrollView.addSubview(publicLabel)
        scrollView.addSubview(lineLabel)
        scrollView.addSubview(contentLabel)
        scrollView.addSubview(textView)
        scrollView.addSubview(bgView)
        scrollView.addSubview(lineLabel1)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(contentLabel)
        scrollView.addSubview(titleView)
        
        bgView.addSubview(photoView)
        
        /*
        
        let buttonWidth = (kScreen_width - 34 - 10 * 5) / 6;
        let buttonHeight = buttonWidth
        
        
        let titleArray: [String] = ["演出文化","旅游文化","体育文化","电影文化","会展文化","饮食文化"]
        for i in 0..<6 {
            let button: UIButton = UIButton(type: .custom)
            button.backgroundColor = UIColor.white
            button.frame = CGRect(x: 17 + CGFloat(i) * (buttonWidth + 10), y: publicLabel.bottom + 24 , width: buttonWidth, height: buttonHeight)
            if i == 0{
                button.isSelected = true
                button.setBackgroundImage(UIImage.init(named: "theme_icon_option_pitch"), for: .selected)
                button.setBackgroundImage(UIImage.init(named: "theme_icon_option_normal"), for: .normal)
                button.setTitleColor(UIColor.white, for: .selected)
                self.selectedBtn = button
            }else{
                button.setBackgroundImage(UIImage.init(named: "theme_icon_option_normal"), for: .normal)
                button.setBackgroundImage(UIImage.init(named: "theme_icon_option_pitch"), for: .selected)
                button.setTitleColor(UIColor.gray, for: .normal)
            }
            button.addTarget(self, action: #selector(clickAction(button:)), for: .touchUpInside)
            button.setTitle(titleArray[i], for: .normal)
            button.titleLabel?.numberOfLines = 2
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
            button.layer.masksToBounds = true
            button.titleLabel?.textAlignment = NSTextAlignment.center
            button.tag = 100 + i
            scrollView.addSubview(button)
        }
 
 
 */

    }
 
 
    
    //滚动视图
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.backgroundColor = UIColor.white
        return scrollView
    }()
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 18, y: 30, width: 54, height: 27))
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "标题"
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 15, y: 70, width: kScreen_width - 30, height: 40))
        textView.placeholder = "请输入您的话题标题"
        textView.placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    lazy var lineLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 18, y: 111, width: kScreen_width - 18, height: 1))
        label.backgroundColor = UIColor.init(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 18, y: 125, width: 54, height: 27))
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "内容"
        return label
    }()
    
    
    lazy var titleView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 15, y: 160, width: kScreen_width - 30, height: 100))
        textView.placeholder = "请输入您的话题描述"
        textView.placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    lazy var lineLabel1: UILabel = {
        let label = UILabel(frame: CGRect(x: 18, y: 270, width: kScreen_width - 18, height: 1))
        label.backgroundColor = UIColor.init(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1)
        return label
    }()
    
//    //发布标签
//    lazy var publicLabel: UILabel = {
//        let label = UILabel(frame: CGRect(x: 13, y: 18.5, width: 54, height: 27))
//        label.textColor = UIColor.gray
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.text = "分类"
//        return label
//    }()
    
    lazy var manager: HXPhotoManager = {
        let manager = HXPhotoManager(type: HXPhotoManagerSelectedTypePhoto)
        manager?.openCamera = true
        manager?.outerCamera = true
        manager?.photoMaxNum = 3
        manager?.maxNum = 3
        manager?.showFullScreenCamera = true
        return manager!
    }()
    
    
    lazy var bgView: UIView = {
        let view = UIView(frame: CGRect(x: 15, y: 275, width: kScreen_width - 30, height: 100))
        return view
    }()
    
    lazy var photoView: HXPhotoView = {
        let photoView = HXPhotoView(frame: CGRect(x: 0, y: 13, width: kScreen_width - 30, height: 100), with: self.manager)
        photoView?.delegate = self
        return photoView!
    }()
    

    /*
    //MARK: -Button 点击事件
    func clickAction(button : UIButton) {
        
        for i in 0..<6 {
            let tag = i + 100
            let button = view.viewWithTag(tag) as! UIButton
            button.setTitleColor(UIColor.gray, for: .normal)
            button.isSelected = false
        }
        
        let btn = view.viewWithTag(button.tag) as! UIButton
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.isSelected = true
        
        if button.tag != 100 {
            let btn = view.viewWithTag(100) as! UIButton
            btn.setBackgroundImage(UIImage.init(named: "theme_icon_option_normal"), for: .normal)
        }
        
        //获得选中的按钮
        self.selectedBtn = btn
        
    }
 
 */
    
    // MARK: --发布按钮点击事件
    func publicButtonItemAction() {
        
        if self.textView.text.count <= 5 {
            SVProgressHUD.showInfo(withStatus: "标题太短了")
            return
        }

        if self.titleView.text.count <= 5 {
            SVProgressHUD.showInfo(withStatus: "内容太少了")
            return
        }
    
        NetRequest.publishTopicNetRequest(open_id: AppInfo.shared.user?.token ?? "", type: self.typeid, title: self.textView.text, content: self.titleView.text,images: uploadImageArray) { (success, info, userDic) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info)
                let time: TimeInterval = 0.8
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }else {
                SVProgressHUD.showError(withStatus: info)
            }
        }
    }
    
}

extension PublicGroupViewController: HXPhotoViewDelegate{
    func photoViewChangeComplete(_ allList: [HXPhotoModel]!, photos: [HXPhotoModel]!, videos: [HXPhotoModel]!, original isOriginal: Bool) {
//        uploadImageArray.removeAll()
//        for model in photos {
//            uploadImageArray.append(model.thumbPhoto)
//        }
        
        uploadImageArray.removeAll()
        for model in photos {
            if model.asset == nil { //拍摄照片
                uploadImageArray.append(model.previewPhoto)
            }else {
                HXPhotoTools.fetchPhoto(for: model.asset, size: CGSize.init(width: kScreen_width, height: kScreen_height), resizeMode: PHImageRequestOptionsResizeMode.fast, completion: { (image, info) in
                    if info!["PHImageFileSandboxExtensionTokenKey"] != nil {
                        self.uploadImageArray.append(image!)
                    }
                })
            }
        }
    }
    
    func photoViewDeleteNetworkPhoto(_ networkPhotoUrl: String!) {
        
    }
    
    func photoViewUpdateFrame(_ frame: CGRect, with view: UIView!) {
        
    }
}
