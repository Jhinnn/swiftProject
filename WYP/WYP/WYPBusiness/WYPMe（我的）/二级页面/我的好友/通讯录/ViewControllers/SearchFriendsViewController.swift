//
//  SearchFriendsViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/4.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class SearchFriendsViewController: BaseViewController {

    // 搜索结果
    var searchResult: [AttentionPeopleModel]?
    
    // MARK: - setter and geter
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfig()
        layoutPagesSubviews()
    }
    
    //MARK: - private method
    func viewConfig() {
        self.title = "添加通讯录成员"
        view.backgroundColor = UIColor.init(hexColor: "efefef")
        view.addSubview(infoLabel)
        view.addSubview(textFieldView)
        textFieldView.addSubview(textField)
        view.addSubview(submitButton)
    }
    func layoutPagesSubviews() {
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(9)
            make.left.equalTo(view).offset(13)
            make.right.equalTo(view).offset(-13)
            make.height.equalTo(13)
        }
        textFieldView.snp.makeConstraints { (make) in
            make.top.equalTo(infoLabel.snp.bottom).offset(9)
            make.left.right.equalTo(view)
            make.height.equalTo(55)
        }
        textField.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 14, 0, 0))
        }
        submitButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(textField.snp.bottom).offset(50)
            make.size.equalTo(CGSize(width: 276.5, height: 47))
        }
    }
    // 搜索好友
    func loadFriendsData() {
        if !(textField.text?.isMobileTelephoneNumber())! {
            SVProgressHUD.showError(withStatus: "手机号格式有误")
            return
        }
        NetRequest.addSearchFriendsNetRequest(openId: AppInfo.shared.user?.token ?? "", keyword: textField.text ?? "") { (success, info, result) in
            if success {
                if info == "没有此用户" {
                    SVProgressHUD.showError(withStatus: info!)
                } else {
                    let array = result!.value(forKey: "data")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    print(jsonString)
                    self.searchResult = [AttentionPeopleModel].deserialize(from: jsonString) as? [AttentionPeopleModel]
                    let searchVC = SearchFriendsResultViewController()
                    searchVC.friends = self.searchResult
                    searchVC.phoneNumber = self.textField.text
                    self.navigationController?.pushViewController(searchVC, animated: true)
                }
                
            } else {
                print(info!)
            }
        }
    }
    
    // MARK: - event response
    func submitAddFriends(sender: UIButton) {
        loadFriendsData()
    }
    
    // MARK: - setter and getter
    lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.text = "通过手机号码添加好友"
        infoLabel.textColor = UIColor.init(hexColor: "333333")
        infoLabel.font = UIFont.systemFont(ofSize: 13)
        return infoLabel
    }()
    lazy var textFieldView: UIView = {
        let textFieldView = UIView()
        textFieldView.backgroundColor = UIColor.white
        return textFieldView
    }()
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = UIColor.white
        textField.placeholder = "请输入对方手机号/阿拉丁号"
        return textField
    }()
    lazy var submitButton: UIButton = {
        let submitButton = UIButton()
        submitButton.setTitle("提交", for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.backgroundColor = UIColor.themeColor
        submitButton.layer.masksToBounds = true
        submitButton.layer.cornerRadius = 5.0
        submitButton.addTarget(self, action: #selector(submitAddFriends(sender:)), for: .touchUpInside)
        return submitButton
    }()

}

extension SearchFriendsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        loadFriendsData()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if WYPContain.stringContainsEmoji(string) {
            if WYPContain.isNineKeyBoard(string) {
                return true
            }
            SVProgressHUD.showError(withStatus: "暂不支持特殊字符")
            return false
        }
        return true
    }
}
