//
//  SearchFriendsResultViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/3.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class SearchFriendsResultViewController: BaseViewController {

    // 数组
    var friends: [AttentionPeopleModel]?
    // 电话号码
    var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfig()
    }
    
    // MARK: - private method
    func viewConfig() {
        view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }

    // MARK: - setter and getter
    lazy var resultTableView: WYPTableView = {
        let resultTableView = WYPTableView()
        resultTableView.rowHeight = 60
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.tableFooterView = UIView()
        resultTableView.register(AddFriendsTableViewCell.self, forCellReuseIdentifier: "searchCell")
        return resultTableView
    }()
}

extension SearchFriendsResultViewController: UITableViewDelegate, UITableViewDataSource, AddFriendsTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if friends != nil {
            return friends?.count ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! AddFriendsTableViewCell
        cell.addModel = friends?[indexPath.row]
        cell.addAttentionButton.tag = 160 + indexPath.row
        cell.delegate = self
        return cell
    }
    func applyAddFriends(sender: UIButton) {
        let vc = VerifyApplicationViewController()
        vc.applyMobile = phoneNumber
        navigationController?.pushViewController(vc, animated: true)
    }
}
