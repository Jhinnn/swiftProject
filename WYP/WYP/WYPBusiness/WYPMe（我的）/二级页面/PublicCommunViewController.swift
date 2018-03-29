//
//  PublicGroupViewController.swift
//  WYP
//
//  Created by Arthur on 2017/12/18.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class PublicCommunViewController: BaseViewController{
    
    var uid: String!
    var userToken: String!
    var post_topic: String!
    
    //选中的button
    var selectedBtn: UIButton!
    
    //存放图片的数组
    var uploadImageArray = [UIImage]()
    
    //分享群组id字符串
    var group_id: String!
    var qunzu_id: String!
    var topic_id: String!
    var gambit_id: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "发布社区"
        // 创建注册Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .done, target: self, action: #selector(publicButtonItemAction))
        
        self.view.addSubview(backgroundView)
        backgroundView.addSubview(textView)
        self.view.addSubview(bgView)
        bgView.addSubview(photoView)
        self.view.addSubview(tongbuLabel)
        self.view.addSubview(tongbuButton)
        
    }
    
    lazy var backgroundView: UIView = {
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 220))
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 20, width: kScreen_width - 20, height: 200))
        textView.placeholder = "添加描述和配图（选填）"
        textView.placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    lazy var manager: HXPhotoManager = {
        let manager = HXPhotoManager(type: HXPhotoManagerSelectedTypePhoto)
        manager?.openCamera = true
        manager?.outerCamera = true
        manager?.photoMaxNum = 9
        manager?.maxNum = 9
        manager?.showFullScreenCamera = true
        return manager!
    }()
    
    
    lazy var bgView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 220, width: kScreen_width, height: 100))
        return view
    }()
    
    lazy var photoView: HXPhotoView = {
        let photoView = HXPhotoView(frame: CGRect(x: 10, y: 13, width: kScreen_width - 40, height: 220), with: self.manager)
        photoView?.delegate = self
        return photoView!
    }()
    
    
    lazy var tongbuLabel: UILabel = {
        let laebl = UILabel(frame: CGRect(x: 10, y: 380, width: 100, height: 30))
        laebl.text = "同步至"
        return laebl
    }()
    
    lazy var tongbuButton: UIButton = {
        let button = UIButton(frame: CGRect(x: kScreen_width - 80, y: 380, width: 80, height: 30))
        button.setImage(UIImage.init(named: "community_icon_more_normal"), for: .normal)
        button.addTarget(self, action: #selector(tongbuAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: --同步按钮
    func tongbuAction() {
        
        let synVC = SynchronizationViewController()
        synVC.postValueBlock = {(arrOne,arrTwo,arrThree,arrFour) in
            self.group_id = arrOne.joined(separator: ",") //展厅
            self.qunzu_id = arrTwo.joined(separator: ",")
            self.topic_id = arrThree.joined(separator: ",")
            self.gambit_id = arrFour.joined(separator: ",")
        }
        
        self.navigationController?.pushViewController(synVC, animated: true)
    }

    // MARK: --发布按钮点击事件
    func publicButtonItemAction() {
        
        
        if self.textView.text.count <= 0 {
            SVProgressHUD.showInfo(withStatus: "发布内容不能为空！")
            return
        }
        
        NetRequest.publishCommunityNetRequest(open_id: AppInfo.shared.user?.userId ?? "", title: self.textView.text, images: uploadImageArray, groupId: self.group_id ?? "", qunzuId: self.qunzu_id ?? "", topicID: self.topic_id ?? "", gambitID: self.gambit_id ?? "") { (success, info, userDic) in
            if success {
                
                SVProgressHUD.setDefaultMaskType(.none)
                SVProgressHUD.show(withStatus: "发送中...")
                
                let time: TimeInterval = 0.8
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    SVProgressHUD.dismiss()
                    
                    SVProgressHUD.showSuccess(withStatus: info)
                    self.navigationController?.popViewController(animated: true)
                }
            }else {
                SVProgressHUD.showError(withStatus: info)
            }
        }

       
    }
    
}

extension PublicCommunViewController: HXPhotoViewDelegate{
    func photoViewChangeComplete(_ allList: [HXPhotoModel]!, photos: [HXPhotoModel]!, videos: [HXPhotoModel]!, original isOriginal: Bool) {
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

