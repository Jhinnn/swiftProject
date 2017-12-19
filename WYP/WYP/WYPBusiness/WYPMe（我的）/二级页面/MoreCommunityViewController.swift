//
//  MoreCommunityViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/6/15.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD


//定义一个名字为学生协议
protocol MoreCommunityViewControllerDelegate {
    
    func changeStatementFrameModel(statementFrame: StatementFrameModel)
}

class MoreCommunityViewController: BaseViewController {

    var dataId: String!
    
    var currentStatement: StatementModel!
    
    var statementFrame: StatementFrameModel!
    
    var delegate: MoreCommunityViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared().isEnabled = true
        
        statementFrame.isShowAllMessage = false
        statementFrame.statement = statementFrame.statement
        
        delegate?.changeStatementFrameModel(statementFrame: statementFrame)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        view.addSubview(commentInputView)
        
        setupUIFrame()
    }
    
    func setupUIFrame() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        commentInputView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(0)
        }
    }
    
    // 表视图
    lazy var tableView: WYPTableView = {
        let tableView = WYPTableView(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(StatementCell.self, forCellReuseIdentifier: "StatementCellIdentifier")
        
        tableView.backgroundColor = UIColor.white
        
        return tableView
    }()
    
    // 表视图的头视图
    lazy var tableViewHeaderView: UIImageView = {
        let tableViewHeaderView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 180))
        tableViewHeaderView.backgroundColor = UIColor.yellow
        tableViewHeaderView.image = UIImage(named: "grzy_porfile_bg")
        
        return tableViewHeaderView
    }()
    
    
    // 评论文本输入框
    lazy var commentInputView: CMInputView = {
        let commentInputView = CMInputView()
        commentInputView.delegate = self
        commentInputView.placeholderColor = UIColor.gray
        commentInputView.placeholderFont = UIFont.systemFont(ofSize: 14)
        commentInputView.isHidden = true
        commentInputView.returnKeyType = .send
        commentInputView.font = UIFont.systemFont(ofSize: 14)
        commentInputView.backgroundColor = UIColor.white
        
        return commentInputView
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        
        return bgView
    }()
    
    func keyboardWillShow(note: NSNotification) {
        let userInfo = note.userInfo!
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {
            //键盘的偏移量
            self.commentInputView.isHidden = false
            self.commentInputView.transform = CGAffineTransform(translationX: 0 , y: -deltaY)
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else{
            animations()
        }
    }
    
    
    func keyboardWillHidden(note: NSNotification) {
        
        commentInputView.isHidden = true
    }
}

extension MoreCommunityViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StatementCell(style: .default, reuseIdentifier: "StatementCellIdentifier")
        
        cell.statementFrame = self.statementFrame
        cell.selectionStyle = .none;
        cell.delegate = self
        cell.selectImgBlock = {(index, imageUrlArray) in
            let albumVC = AlbumViewController()
            albumVC.dataList = imageUrlArray
            albumVC.selectedIndex = index
            self.navigationController?.pushViewController(albumVC, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.statementFrame.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension MoreCommunityViewController: StatementCellDelegate {
    // 点赞按钮点击事件
    func statementCell(_ statementCell: StatementCell!, starButtonAction button: UIButton!, statement: StatementModel!) {
        
        currentStatement = statement
        let parameters: Parameters = ["access_token": "4170fa02947baeed645293310f478bb4",
                                      "method": "POST",
                                      "dynamic_id": statement._id,
                                      "uid": AppInfo.shared.user?.userId ?? ""]
        let url = kApi_baseUrl(path: "api/community_fabulous")
        buttonActionRequestNetData(URLString: url, parameters: parameters)
    }
    
    func statementCell(_ statementCell: StatementCell!, moreButtonAction button: UIButton!, statement: StatementModel!) {
        print("删除")
    }
    
    // 分享按钮点击事件
    func statementCell(_ statementCell: StatementCell!, shareButtonAction button: UIButton!, statement: StatementModel!) {
        
        let messageObject = UMSocialMessageObject()
        
        // 缩略图
        let thumbURL = ""
        // 分享对象
        let shareObject: UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: statement.message ?? "", descr: "在这里，总会找到你喜欢的话题，点进来看看吧", thumImage: thumbURL)
        // 网址
        let url = String.init(format: "Mob/SheQu/index.html?dynamic_id=%@", statement._id)
        shareObject.webpageUrl = kApi_baseUrl(path: url)
        messageObject.shareObject = shareObject
        
        // 传相关参数
        ShareManager.shared.loadShareAdv()
        ShareManager.shared.complaintId = statement._id ?? ""
        ShareManager.shared.type = "6"
        
        ShareManager.shared.messageObject = messageObject
        ShareManager.shared.viewController = self
        ShareManager.shared.show()
    }
    // 删除按钮点击事件
    func statementCell(_ statementCell: StatementCell!, deleteButtonAction button: UIButton!, statement: StatementModel!) {
        
    }
    // 评论按钮点击事件
    func statementCell(_ statementCell: StatementCell!, commentButtonAction button: UIButton!, statement: StatementModel!) {
        
        currentStatement = statement
        dataId = statement._id
        
        commentInputView.becomeFirstResponder()
        commentInputView.isHidden = false
    }
    
    func buttonActionRequestNetData(URLString: String, parameters: [String: Any]) {
        Alamofire.request(URLString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                // 获取code码
                let code = json["code"].intValue
                let info = json["info"].stringValue
                if code == 200 {
                    SVProgressHUD.showSuccess(withStatus: info)
                    self.commentInputView.resignFirstResponder()
                    
                    let dic = json.dictionary?["data"]?.rawValue as? NSDictionary
                    
                    let statement = StatementModel(contentDic: dic as! [AnyHashable : Any])
                    self.currentStatement = statement
                    let frameModel = StatementFrameModel()
                    frameModel.isShowAllMessage = true
                    frameModel.statement = statement
                    
                    self.statementFrame = frameModel
                    
                    if self.statementFrame.statement == self.currentStatement {
                        self.statementFrame.statement = statement
                    }

                    self.tableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MoreCommunityViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //在这里做你响应return键的代码
        if text == "\n" {
            //判断输入的字是否是回车，即按下return
            // 获取用户token
            let userId = AppInfo.shared.user?.userId ?? "1"
            let parameters: Parameters = ["access_token": "4170fa02947baeed645293310f478bb4",
                                          "method": "POST",
                                          "uid": userId,
                                          "dynamic_id": dataId,
                                          "content": commentInputView.text]
            let url = kApi_baseUrl(path: "api/community_comment")
            buttonActionRequestNetData(URLString: url, parameters: parameters)
            commentInputView.resignFirstResponder
            return false //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        }
        return true
    }
    
}
