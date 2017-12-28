//
//  AddFriendsViewController.swift
//  WYP
//
//  Created by 赵玉忠 on 2017/11/5.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class AddFriendsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func viewConfig() {
        navigationItem.title = "添加好友"
        view.addSubview(searchView)
        searchView.addSubview(searchImageView)
        searchView.addSubview(searchLabel)
        
        view.addSubview(categoryTableView)
        
        //计算tableView的高度
        let height = 60 * 2
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(15)
            make.left.right.equalTo(view)
            make.height.equalTo(50)
        }
        searchImageView.snp.makeConstraints { (make) in
            make.left.equalTo(searchView).offset(25)
            make.centerY.equalTo(searchView)
            make.width.height.equalTo(15)
        }
        searchLabel.snp.makeConstraints { (make) in
                make.left.equalTo(searchImageView.snp.right).offset(22)
                make.centerY.equalTo(searchImageView)
        }
        categoryTableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchView.snp.bottom).offset(60)
            make.left.right.equalTo(view)
            make.height.equalTo(height)
        }
        
        
        
        
    }
    lazy var searchView:UIView = {
        let searchView = UIView()
        searchView.backgroundColor = UIColor.white
        return searchView
    }()
    lazy var searchImageView:UIImageView = {
         let searchImageView = UIImageView()
         searchImageView.image = UIImage(named: "common_search_button_normal_iPhone")
         return searchImageView
    }()
    lazy var searchLabel:UILabel = {
        let searchLabel:UILabel = UILabel()
        searchLabel.text = "阿拉丁号/手机号"
        searchLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(pushNextPage))
        searchLabel.addGestureRecognizer(tap)
        searchLabel.textColor = UIColor(red: 192/250, green: 192/250, blue: 192/250, alpha: 1)
        return searchLabel
    }()
    lazy var categoryTableView:WYPTableView = {
        let categoryTableView = WYPTableView()
        categoryTableView.rowHeight = 60
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.register(CategoryAddFriendsTableViewCell.self, forCellReuseIdentifier: "CategoryAddFriendsTableViewCell")
        return categoryTableView
    }()
    
    
    func pushNextPage() {
        navigationController?.pushViewController(SearchFriendsViewController(), animated: true)
    }

}


extension AddFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryAddFriendsTableViewCell") as! CategoryAddFriendsTableViewCell
        cell.backgroundColor = UIColor.white
        if indexPath.row == 0 {
            cell.leftImageView.image = UIImage(named: "datum_icon_dimension_normal")
            cell.labelUp.text = "扫一扫"
            cell.labelDown.text = "扫描二维码名片"
            cell.rightImageView.image = UIImage(named: "chat_icon_advance_normalmore")
        }else{
            cell.leftImageView.image = UIImage(named: "mine_addContacts_icon_normal_iPhone")
            cell.labelUp.text = "手机联系人"
            cell.labelDown.text = "添加通讯录中的朋友"
            cell.rightImageView.image = UIImage(named: "chat_icon_advance_normalmore")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
          navigationController?.pushViewController(ScanOneScanViewController(), animated: true)
        }else{
         navigationController?.pushViewController(ContactsFriendsViewController(), animated: true)
        }
    }

    
    
}
