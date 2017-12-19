//
//  TheaterGroupViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/5.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class TheaterGroupViewController: BaseViewController {

    // 数据源
    var theaterGroupsData: [TheaterGroupModel]?
    // 筛选类型
    var typeId: String = ""
    // 展厅id
    var roomId: String?
    // 筛选类型
    var titles = ["全部", "演出", "旅游", "会展" ,"赛事", "电影", "栏目"]
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        layoutPageSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 获取数据
        loadTeatherGroupData(requestType: .update)
    }
    
    // MARK: - private method
    private func viewConfig() {
        self.title = "群组"
        theaterGroupsData = [TheaterGroupModel]()
        
        view.addSubview(theaterGroupTableView)
        view.addSubview(searchView)
        searchView.addSubview(sortButton)
        searchView.addSubview(searchButton)
        searchView.addSubview(searchTextField)
        
    }
    private func layoutPageSubviews() {
        theaterGroupTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(46, 0, 0, 0))
        }
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(0)
            make.left.right.equalTo(view)
            make.height.equalTo(36)
        }
        sortButton.snp.makeConstraints { (make) in
            make.left.equalTo(searchView).offset(13)
            make.centerY.equalTo(searchView)
            make.size.equalTo(CGSize(width: 65, height: 30))
        }
        searchButton.snp.makeConstraints { (make) in
            make.right.equalTo(searchView).offset(-13)
            make.centerY.equalTo(searchView)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        searchTextField.snp.makeConstraints { (make) in
            make.right.equalTo(searchButton.snp.left).offset(-10)
            make.centerY.equalTo(searchView)
            make.size.equalTo(CGSize(width: 217.5 * width_height_ratio, height: 29))
        }
    }
    func loadTeatherGroupData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.groupListNetRequest(page: "\(pageNumber)", uid: AppInfo.shared.user?.userId ?? "", gid: roomId ?? "") { (success, info, result) in
    
            if success {
                let array = result?.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                
                if requestType == .update {
                    self.theaterGroupsData = [TheaterGroupModel].deserialize(from: jsonString) as? [TheaterGroupModel]
                } else {
                    // 把新数据添加进去
                    let theaterGroup = [TheaterGroupModel].deserialize(from: jsonString) as? [TheaterGroupModel]
                    self.theaterGroupsData = self.theaterGroupsData! + theaterGroup!
                }
                
                // 先移除再添加
                self.noDataImageView.removeFromSuperview()
                self.noDataLabel.removeFromSuperview()
                // 没有数据的情况
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
                
                self.theaterGroupTableView.reloadData()
                self.theaterGroupTableView.mj_header.endRefreshing()
                self.theaterGroupTableView.mj_footer.endRefreshing()
            } else {
                SVProgressHUD.showError(withStatus: info!)
                self.theaterGroupTableView.mj_header.endRefreshing()
                self.theaterGroupTableView.mj_footer.endRefreshing()
            }
        }
    }
    func searchGroup(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }

        NetRequest.groupSearchNetRequest(page: "\(pageNumber)", keyword: searchTextField.text ?? "", typeId: typeId) { (success, info, result) in
            if success {
                let array = result?.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                
                if requestType == .update {
                    self.theaterGroupsData = [TheaterGroupModel].deserialize(from: jsonString) as? [TheaterGroupModel]
                } else {
                    // 把新数据添加进去
                    let theaterGroup = [TheaterGroupModel].deserialize(from: jsonString) as? [TheaterGroupModel]
                    self.theaterGroupsData = self.theaterGroupsData! + theaterGroup!
                }
                
                // 先移除再添加
                self.noDataImageView.removeFromSuperview()
                self.noDataLabel.removeFromSuperview()
                // 没有数据的情况
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
                
                self.theaterGroupTableView.reloadData()
                self.theaterGroupTableView.mj_header.endRefreshing()
                self.theaterGroupTableView.mj_footer.endRefreshing()
            } else {
                SVProgressHUD.showError(withStatus: info!)
                self.theaterGroupTableView.mj_header.endRefreshing()
                self.theaterGroupTableView.mj_footer.endRefreshing()
            }
            
        }
    }
    
    // MARK: - event response
    func searchClick(sender: UIButton) {
        searchGroup(requestType: .update)
    }
    
    // MARK: - Setter
    lazy var theaterGroupTableView: WYPTableView = {
        let theaterGroupTableView = WYPTableView(frame: .zero, style: .grouped)
        theaterGroupTableView.rowHeight = 105
        theaterGroupTableView.delegate = self
        theaterGroupTableView.dataSource = self
        theaterGroupTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            if self.searchTextField.text == "" && self.typeId == "" { // 刷新群组列表
                self.loadTeatherGroupData(requestType: .loadMore)
            } else if self.searchTextField.text != "" || self.typeId != ""{ // 刷新搜索后或筛选后的群组列表
                self.searchGroup(requestType: .loadMore)
            }
            
        })
        theaterGroupTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            if self.searchTextField.text == "" && self.typeId == "" { // 刷新群组列表
                self.loadTeatherGroupData(requestType: .update)
            } else if self.searchTextField.text != "" || self.typeId != "" { // 刷新搜索后或筛选后的群组列表
                self.searchGroup(requestType: .update)
            }
        })
        //注册
        theaterGroupTableView.register(TheaterGroupTableViewCell.self, forCellReuseIdentifier: "showRoomCell")
        
        return theaterGroupTableView
    }()
    
    // 搜索
    lazy var searchView: UIView = {
        let searchView = UIView()
        searchView.backgroundColor = UIColor.white
        return searchView
    }()
    lazy var sortButton: UIButton = {
        let sortButton = UIButton(type: .custom)
        sortButton.setTitle("全部", for: .normal)
        sortButton.setTitleColor(UIColor.black, for: .normal)
        sortButton.setImage(UIImage(named: "common_allType_button_normal_iPhone"), for: .normal)
        sortButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 40, bottom: 0, right: 0)
        sortButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        sortButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sortButton.addTarget(self, action: #selector(sortButtonAction), for: .touchUpInside)
        
        return sortButton
    }()
    
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.placeholder = "搜索展厅名称和群组名称"
        searchTextField.delegate = self
        let attributeString = NSMutableAttributedString(string: searchTextField.placeholder!)
        attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14),range: NSMakeRange(0,(searchTextField.placeholder?.characters.count)!))
        searchTextField.attributedPlaceholder = attributeString
        searchTextField.borderStyle = .roundedRect
        searchTextField.returnKeyType = .search
        return searchTextField
    }()
    lazy var searchButton: UIButton = {
        let searchButton = UIButton()
        searchButton.setImage(UIImage(named: "common_search_button_normal_iPhone"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchClick(sender:)), for: .touchUpInside)
        return searchButton
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
        label.text = "没有找到结果"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
    
    func sortButtonAction(button: UIButton) {
        let popupMenu = YBPopupMenu.showRely(on: button, titles: titles, icons: nil, menuWidth: 80, delegate: self as YBPopupMenuDelegate)
        popupMenu?.dismissOnSelected = true
        popupMenu?.type = .default
    }
}


extension TheaterGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if theaterGroupsData?.count == 0 {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
        }
        return theaterGroupsData?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "showRoomCell") as! TheaterGroupTableViewCell
        
        let groupModel = theaterGroupsData?[indexPath.row]
        
        print(groupModel ?? TheaterGroupModel())
        
        cell.groupModel = theaterGroupsData?[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let isJoin = theaterGroupsData?[indexPath.row].isJoin ?? "0"
        if isJoin == "0" {
            // 未加入
            let group = GroupMemberListViewController()
            let groupModel = theaterGroupsData?[indexPath.row]
            group.groupId = groupModel?.groupId ?? ""
            group.roomName = groupModel?.roomName ?? ""
            group.groupName = groupModel?.groupName ?? ""
            navigationController?.pushViewController(group, animated: false)
        } else {
            // 已加入
            let conversationVC = ChatDeatilViewController()
            let theaterGroup = theaterGroupsData?[indexPath.row]
            conversationVC.conversationType = RCConversationType.ConversationType_GROUP
            conversationVC.targetId = theaterGroup?.groupId ?? "0"
            conversationVC.roomName = theaterGroup?.roomName ?? ""
            conversationVC.groupName = theaterGroup?.groupName ?? ""
            navigationController?.pushViewController(conversationVC, animated: true)
        }
    }
}

extension TheaterGroupViewController: YBPopupMenuDelegate {
    func ybPopupMenuDidSelected(at index: Int, ybPopupMenu: YBPopupMenu!) {
        typeId = "\(index)"
        sortButton.setTitle(titles[index], for: .normal)
        if index == 0 {
            loadTeatherGroupData(requestType: .update)
        } else {
            searchGroup(requestType: .update)
        }
        
    }
}

extension TheaterGroupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        searchGroup(requestType: .update)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if PublicGroupViewController().stringContainsEmoji(string) {
            if PublicGroupViewController().isNineKeyBoard(string) {
                return true
            }
            SVProgressHUD.showError(withStatus: "暂不支持特殊字符")
            return false
        }
        return true
    }
}
