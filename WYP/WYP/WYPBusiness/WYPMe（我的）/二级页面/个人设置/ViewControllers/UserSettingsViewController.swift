//
//  UserSettingsViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/3/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import AVKit

class UserSettingsViewController: BaseViewController {

    fileprivate let titleArray = ["头像", "昵称", "性别", "个性签名","我的二维码"]
    
    fileprivate var infoArray: [String] = ["", AppInfo.shared.user!.nickName!, "\(AppInfo.shared.user!.sex!)",  AppInfo.shared.user!.signature!,""]
    
    fileprivate var infoKey = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "个人设置"
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared().isEnabled = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Private Methods
    // 设置所有控件
    fileprivate func setupUI() {
        view.addSubview(tableView)
        
        setupUIFrame()
    }
    
    // 设置控件frame
    fileprivate func setupUIFrame() {
        // 设置tableView的布局
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
//        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "common_editorGary_button_normal_iPhone"), style: .done, target: self, action: #selector(goToUserQR))
//        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    // 设置tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserSettingsCellIdentifier")
        
        return tableView
    }()
    
    lazy var headImgView: UIImageView = {
        let headImgView = UIImageView()
        headImgView.layer.cornerRadius = 37.5
        headImgView.layer.masksToBounds = true
        
        return headImgView
    }()
    
    lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.modalTransitionStyle = .coverVertical
        // 设置是否可以管理已经存在的图片或者视频
        imagePickerController.allowsEditing = true
        return imagePickerController
    }()
    
    // 文本输入框背景视图
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.vcBgColor
        
        return bgView
    }()
    
    // 文本输入框
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.returnKeyType = .done
        
        return textView
    }()
    
    // 提示标题
    lazy var placeholderTitle: UILabel = {
        let placeholderTitle = UILabel()
        placeholderTitle.font = UIFont.systemFont(ofSize: 14)
        
        return placeholderTitle
    }()
    
    // MARK: - IBActions
    fileprivate func setupTextView(placeholder: String) {
        
        view.addSubview(bgView)
        bgView.addSubview(placeholderTitle)
        bgView.addSubview(textView)
        
        bgView.snp.makeConstraints({ (make) in
        make.left.bottom.right.equalTo(view)
        make.height.equalTo(130)
        })
        
        placeholderTitle.snp.makeConstraints({ (make) in
            make.left.equalTo(10)
            make.top.right.equalTo(bgView)
            make.height.equalTo(35)
        })
        
        textView.snp.makeConstraints({ (make) in
        make.top.equalTo(placeholderTitle.snp.bottom)
        make.left.equalTo(bgView).offset(10)
        make.right.equalTo(bgView).offset(-10)
        make.bottom.equalTo(bgView).offset(-10)
        })
        
        placeholderTitle.text = placeholder
        textView.becomeFirstResponder()
    }
    
    func keyboardWillShow(note: NSNotification) {
        let userInfo = note.userInfo!
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {
            //键盘的偏移量
            self.bgView.transform = CGAffineTransform(translationX: 0 , y: -deltaY)
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else{
            animations()
        }
    }
    
    
    func keyboardWillHidden(note: NSNotification) {
        
        bgView.removeFromSuperview()
    }
    
    func netRequestAction(infoDic: [String: Any]) {
        NetRequest.editUserInfoNetRequest(infoDic: infoDic, token: AppInfo.shared.user?.token ?? "") { (success, info, dic) in
            if success {
                // 修改成功
                SVProgressHUD.showSuccess(withStatus: info)
                
                var userInfoDic = AppInfo.shared.user?.userInfo! as? [String: Any]
                userInfoDic?.updateValue(dic?.allValues.first ?? "", forKey: dic?.allKeys.first as! String)
                
                let user = UserModel.deserialize(from: userInfoDic as NSDictionary?)
                
                user?.userInfo = userInfoDic as NSDictionary?
                AppInfo.shared.user = user
                
                
                
                self.infoArray = ["", AppInfo.shared.user!.nickName!, "\(AppInfo.shared.user!.sex!)", AppInfo.shared.user!.signature!,""]
                
                
                
                self.textView.resignFirstResponder()
                self.tableView.reloadData()
            } else {
                // 修改失败
                SVProgressHUD.showError(withStatus: info)
            }
        }
    }
    
    func goToUserQR() {
        let QRVC = MyQRViewController()
        navigationController?.pushViewController(QRVC, animated: false)
    }
}

extension UserSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count ;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UserSettingsCellIdentifier")
        // 设置标题
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        
        // 设置用户资料
        cell.detailTextLabel?.text = infoArray[indexPath.row]
        cell.detailTextLabel?.textColor = UIColor.init(hexColor: "#333333")
        if indexPath.row == 2 {
            if infoArray[indexPath.row] == "0" {
                cell.detailTextLabel?.text = "女"
            } else {
                cell.detailTextLabel?.text = "男"
            }
        }
        if indexPath.row == 3 {
            cell.detailTextLabel?.numberOfLines = 2
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 11)
        } else {
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        }
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.row == 0 {
            // 头像
            cell.contentView.addSubview(headImgView)
            let url = URL(string: AppInfo.shared.user?.headImgUrl ?? "")
            headImgView.kf.setImage(with: url, placeholder: UIImage(named: "mine_header_icon_normal_iPhone"), options: nil, progressBlock: nil, completionHandler: nil)
            headImgView.snp.makeConstraints { (make) in
                make.top.equalTo(cell.contentView).offset(15)
                make.bottom.equalTo(cell.contentView).offset(-15)
                make.width.equalTo(headImgView.snp.height)
                make.right.equalTo(cell).offset(-35)
            }
        }
        if indexPath.row == 4 {
            //我的二维码
            
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            // 头像
            return 105
        }
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath {
        case [0, 0]:
            // 头像
            let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "从相册选择")
            actionSheet.tag = 101
            actionSheet.show(in: view)
        case [0, 1]:
            // 昵称
            infoKey = "nickname"
            setupTextView(placeholder: "请输入昵称")
        case [0, 2]:
            // 性别
            let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "女", "男")
            actionSheet.tag = 100
            actionSheet.show(in: view)
            infoKey = "sex"
        case [0, 3]:
            // 个性签名
            infoKey = "signature"
            
            setupTextView(placeholder: "请输入个性签名")
        case [0, 4]:
             self.navigationController?.pushViewController(QRCodeViewController(), animated: true)
        default:
            print("")
        }
    }
}

extension UserSettingsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if infoKey == "signature" {
            textView.text = AppInfo.shared.user?.signature
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        textView.text = ""
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if WYPContain.stringContainsEmoji(text) {
            if WYPContain.isNineKeyBoard(text) {
                return true
            }
            SVProgressHUD.showError(withStatus: "暂不支持特殊字符")
            return false
        }
        
        // 判断输入的字是否是回车
        if text == "\n" {
            // 响应return事件
       
            
            if infoKey == "nickname" && textView.text.characters.count == 0 {
                SVProgressHUD.showError(withStatus: "昵称不能为空！")
                return false
            }
            
            let infoDic = [infoKey: textView.text!]
            netRequestAction(infoDic: infoDic)
            //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
            return false
        }
        return true
    }
    
}

extension UserSettingsViewController: UIActionSheetDelegate {
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        if actionSheet.tag == 100 {
            // 选择性别
            switch buttonIndex {
            case 2:
                // 男
                netRequestAction(infoDic: [infoKey: 1])
            case 1:
                // 女
                netRequestAction(infoDic: [infoKey: 0])
            default:
                // 取消
                break
            }
        } else {
            // 选择头像
            switch buttonIndex {
            case 2:
                // 相册选择
                getImageFromPhotoLib(type: .photoLibrary)
            case 1:
                // 相机拍照
                getImageFromPhotoLib(type: .camera)
            default:
                // 取消
                break
            }
        }
    }
    
    // 开启相机相册
    func getImageFromPhotoLib(type: UIImagePickerControllerSourceType) {
        imagePickerController.sourceType = type
        // 判断是否支持相册
        if UIImagePickerController.isSourceTypeAvailable(type) {
            self.present(imagePickerController, animated: true, completion: { 
                self.imagePickerController.delegate = self
            })
        }
    }
}

extension UserSettingsViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 关闭当前相册视图控制器
        picker.dismiss(animated: true, completion: nil)
        
        let image = info["UIImagePickerControllerEditedImage"] as! UIImage
        
        // 压缩图片
        let fileData = UIImageJPEGRepresentation(image, 0.4)
        
        let base64String = fileData?.base64EncodedString(options: .endLineWithCarriageReturn)
        
        let infoDic = ["baseImg": base64String ?? ""]
        netRequestAction(infoDic: infoDic)
    }
}
