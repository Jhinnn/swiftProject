
//
//  ZanListViewController.swift
//  WYP
//
//  Created by aLaDing on 2018/3/20.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class ZanListViewController: BaseViewController {

    var zanListArray: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "点赞列表"
        
        self.view.addSubview(tableView)
    }

    
    
    // 表视图
    lazy var tableView: WYPTableView = {
        
        let tableView = WYPTableView(frame:CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height), style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(StatementCell.self, forCellReuseIdentifier: "StatementCellIdentifier")
        tableView.rowHeight = 60
        tableView.backgroundColor = UIColor.white
        tableView.register(AddFriendsTableViewCell.self, forCellReuseIdentifier: "contactsCell")
        return tableView
    }()
   

}

extension ZanListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.zanListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell", for: indexPath) as! AddFriendsTableViewCell
        cell.addAttentionButton.isHidden = true
        let model = self.zanListArray[indexPath.row] as! StarAndCommentModel
        cell.friendsTitleLabel.text = model.nickName
        let url = URL(string: model.imageUrl)
        cell.friendsImageView.kf.setImage(with: url)
        return cell
    }
}
