//
//  RecommendFriendsViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/6/1.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class RecommendFriendsViewController: UIViewController {
    
    var personSource: [PersonModel]?
    // 群组名称
    var groupName: String?
    // 群组Id
    var groupId: String?
    // 推荐好友uid数组
    var recommendArr = [String]()

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let rightButton = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(recommendToFriends(sender:)))
        navigationItem.rightBarButtonItem = rightButton
        
        title = "选择联系人"
        
        view.addSubview(friendsTableView)
        layoutPageSubviews()
        loadMyFriendsList()
    }

    // MARK: - private method
    
    func layoutPageSubviews() {
        friendsTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
    func loadMyFriendsList() {
        NetRequest.friendsListNetRequest(openId: AppInfo.shared.user?.token ?? "", page: "") { (success, info, result) in
            if success {
                let array = result!.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                self.personSource = [PersonModel].deserialize(from: jsonString) as? [PersonModel]
                
                // 没有好友时
                self.view.addSubview(self.noDataImageView)
                self.view.addSubview(self.noDataLabel)
                self.noDataImageView.snp.makeConstraints { (make) in
                    if deviceTypeIphone5() || deviceTypeIPhone4() {
                        make.top.equalTo(self.view).offset(130)
                    }
                    make.top.equalTo(self.view).offset(180)
                    make.centerX.equalTo(self.view)
                    make.size.equalTo(CGSize(width: 100, height: 147))
                }
                self.noDataLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(self.noDataImageView.snp.bottom).offset(10)
                    make.centerX.equalTo(self.view)
                    make.height.equalTo(11)
                }
                
                self.friendsTableView.reloadData()
            } else {
                print(info!)
            }
        }

    }
    
    // MARK: - event response
    func recommendToFriends(sender: UIButton) {

        NetRequest.recommendFriendsNetRequest(pushid: recommendArr, nickname: AppInfo.shared.user?.nickName ?? "", groupName: groupName ?? "", groupId: groupId ?? "", uid: AppInfo.shared.user?.userId ?? "") { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info!)
                self.navigationController?.popViewController(animated: true)
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
    
    // MARK: - setter
    lazy var friendsTableView: WYPTableView = {
        let friendsTableView = WYPTableView(frame: .zero, style: .plain)
        friendsTableView.backgroundColor = UIColor.white
        friendsTableView.rowHeight = 60
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        friendsTableView.tableFooterView = UIView()
        
        //注册
        friendsTableView.register(RecommendTableViewCell.self, forCellReuseIdentifier: "groupsCell")
        return  friendsTableView
    }()
    
    // 没有数据时的图片
    lazy var noDataImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "common_noResult_icon_normal_iPhone")
        return imageView
    }()
    // 没有找到结果
    lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "暂无好友"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
}

extension RecommendFriendsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if personSource?.count == 0 {
            noDataLabel.isHidden = false
            noDataImageView.isHidden = false
        } else {
            noDataLabel.isHidden = true
            noDataImageView.isHidden = true
        }
        return personSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupsCell", for: indexPath) as! RecommendTableViewCell
        cell.friendsModel = personSource?[indexPath.row]
        cell.recommendBtn.tag = indexPath.row + 110
        cell.delegate = self
        return cell
    }
}

extension RecommendFriendsViewController: RecommendTableViewCellDelegate {
    func chooseFriends(sender: UIButton) {
        
        self.recommendArr.append(personSource?[sender.tag - 110].peopleId ?? "")
    }
}
