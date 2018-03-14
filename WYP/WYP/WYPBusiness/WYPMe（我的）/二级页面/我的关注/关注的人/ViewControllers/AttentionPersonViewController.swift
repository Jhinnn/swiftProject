//
//  AttentionPersonViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class AttentionPersonViewController: BaseViewController {
    
    var dataSource = [AttentionPeopleModel]()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBaseViewLayout()
        layoutPageSubviews()
        loadDataSource(requestType: .update)
        
    }
    
    // MARK: - private method
    func initBaseViewLayout() {
        view.addSubview(attentionTableview)
    }
    
    func layoutPageSubviews() {
        attentionTableview.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 108, 0))
        }
    }
    
    func loadDataSource(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.attentionPeopleNetRequest(page: "\(pageNumber)", openId: AppInfo.shared.user?.token ?? "") { (success, info, result) in
            if success {
                let array = result!.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                if requestType == .update {
                    self.dataSource = [AttentionPeopleModel].deserialize(from: jsonString)! as! [AttentionPeopleModel]
                } else {
                    // 把新数据添加进去
                    let personArray = [AttentionPeopleModel].deserialize(from: jsonString) as? [AttentionPeopleModel]
                    
                    self.dataSource = self.dataSource + personArray!
                }
                
                // 先移除再添加
                self.noDataImageView.removeFromSuperview()
                self.noDataLabel.removeFromSuperview()
                // 没有数据的时候
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
                
                self.attentionTableview.mj_header.endRefreshing()
                self.attentionTableview.mj_footer.endRefreshing()
                self.attentionTableview.reloadData()
            } else {
                self.attentionTableview.mj_header.endRefreshing()
                self.attentionTableview.mj_footer.endRefreshing()
            }
        }
    }
    
    // MARK: - setter
    lazy var attentionTableview: UITableView = {
        let attentionTableview = UITableView(frame: .zero, style: .plain)
        attentionTableview.backgroundColor = UIColor.white
        attentionTableview.rowHeight = 65
        attentionTableview.delegate = self
        attentionTableview.dataSource = self
        attentionTableview.tableFooterView = UIView()
        attentionTableview.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadDataSource(requestType: .loadMore)
        })
        attentionTableview.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadDataSource(requestType: .update)
        })
        //注册
        attentionTableview.register(AttentionPeopleTableViewCell.self, forCellReuseIdentifier: "attentionCell")
        return  attentionTableview
    }()
    
    // 没有数据时的图片
    lazy var noDataImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "common_noData_icon_normal_iPhone")
        return imageView
    }()
    // 没有数据时的提示文字
    lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "暂无关注的人"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
}

extension AttentionPersonViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count == 0 {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
        }
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attentionCell", for: indexPath) as! AttentionPeopleTableViewCell
            cell.peoplesModel = dataSource[indexPath.row]
        return cell
    }
    
    // 选中单元格
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        attentionTableview.deselectRow(at: indexPath, animated: true)
        
        /*
         // 关注的人的头像
         var icon: String?
         // 昵称
         var nickName: String?
         // 个性签名
         var signature: String?
         // 真实姓名
         var realName: String?
         // 关注的人的id
         var peopleId: String?
         // 是否添加关注
         var isFollow: String?
         // 电话
         var phoneNumber: String?
         */
        let peoplesModel = dataSource[indexPath.row]
        
        let community = MyCommunityViewController()
        community.title = "个人社区"
        community.headImageUrl = peoplesModel.icon
        community.userId = peoplesModel.peopleId
        community.nickName = peoplesModel.nickName
        community.fansCount = "粉丝:\(peoplesModel.fans ?? "0")人"
        community.friendsCountLabel.text = "好友:\(peoplesModel.friends ?? "0")人"
        community.type = "2"
        community.isFollowed = true
        if peoplesModel.peopleId == AppInfo.shared.user?.userId {
            community.userType = "200"
        }
        
        navigationController?.pushViewController(community, animated: true)
    }
    // 设置侧滑删除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    // 修改删除按钮的文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "取消关注"
    }
    // 删除cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            let peopleId = dataSource[indexPath.row].peopleId
            NetRequest.peopleCancelAttentionNetRequest(openId: AppInfo.shared.user?.token ?? "", peopleId: peopleId!, complete: { (success, info) in
                if success {
                    self.dataSource.remove(at: indexPath.row)
                    tableView.reloadData()
                    // 删除成功
                    SVProgressHUD.showSuccess(withStatus: info)
                } else {
                    // 删除失败
                    SVProgressHUD.showError(withStatus: info)
                }
            })
            //2.刷新单元格
            tableView.reloadData()
        }
    }

}

