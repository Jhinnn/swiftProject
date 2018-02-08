//
//  GroupsViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class GroupsViewController: BaseViewController {
    
    //新增--start
    var myManageGroupTableView:UITableView?
    var myJoinGroupTableView:UITableView?
    var myJoinGroupViewGlobal:UIView?
    var myManageGroupViewGlobal:UIView?
    var myManageGroupViewLetfImage:UIImageView?
    var myJoinGroupViewLetfImage:UIImageView?
    
    
    //我管理的群tableview的高度
    var ManagerTableViewHeight = 200
    //我加入的群tableview的高度
    var JoinTableViewHeight = 400
    
    //记录 我管理的群 点击View的转态: 0--未点开 1--点开
    var ManagerGroupClickStatus:NSInteger = 0
    //记录 我加入的群 点击View的转态: 0--未点开 1--点开
    var JoinGroupClickStatus:NSInteger = 0
    //新增--end
    
    var dataSource: [GroupsModel]?
    
    var dataSource0: [GroupsModel]?

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfig()
        layoutPageSubviews()
        loadGroupsInData(requestType: .update)
        loadGroupsChangeData(requestType: .update)
    }
    
    // MARK: - private method
    func viewConfig() {
        self.setupUI()
        //暂且注释，但会要用到
//        view.addSubview(groupTableview)
        
    }
    
    func layoutPageSubviews() {
        myManageGroupViewGlobal?.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(14)
            make.left.right.equalTo(view)
            make.height.equalTo(50)
        }
        myManageGroupTableView?.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo((myManageGroupViewGlobal?.snp.bottom)!)
            make.height.equalTo(0)
        }
        myJoinGroupViewGlobal?.snp.makeConstraints { (make) in
            make.top.equalTo((myManageGroupTableView?.snp.bottom)!)
            make.left.right.equalTo(view)
            make.height.equalTo(50)
        }
        myJoinGroupTableView?.snp.makeConstraints { (make) in
                make.left.right.equalTo(view)
                make.top.equalTo((myJoinGroupViewGlobal?.snp.bottom)!)
                make.height.equalTo(0)
        }

        //更新之前代码
//        groupTableview.snp.makeConstraints { (make) in
//            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 64, 0))
//        }
    }
    
    func loadGroupsChangeData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        
        NetRequest.myGroupsListChangeNetRequest(openId: AppInfo.shared.user?.token ?? "", page: "\(pageNumber)") { (success, info, result) in
            if success {
                let array = result!.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                
                
                if requestType == .update {
                    self.dataSource0 = [GroupsModel].deserialize(from: jsonString) as? [GroupsModel]
                } else {
                    let group = [GroupsModel].deserialize(from: jsonString) as? [GroupsModel]
                    self.dataSource0 = self.dataSource0! + group!
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
                
//                self.groupTableview.reloadData()
                self.myManageGroupTableView?.reloadData()
//                self.myJoinGroupTableView?.reloadData()
            } else {
                print(info!)
            }
            
            
        }
    }
    
    
    
    
    
    func loadGroupsInData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
    
        NetRequest.myGroupsListNetRequest(openId: AppInfo.shared.user?.token ?? "", page: "\(pageNumber)") { (success, info, result) in
            if success {
               let array = result!.value(forKey: "data")
               let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
               let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
               
                
                if requestType == .update {
                    self.dataSource = [GroupsModel].deserialize(from: jsonString) as? [GroupsModel]
                } else {
                    let group = [GroupsModel].deserialize(from: jsonString) as? [GroupsModel]
                    self.dataSource = self.dataSource! + group!
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
                
//               self.groupTableview.reloadData()
//                self.myManageGroupTableView?.reloadData()
                self.myJoinGroupTableView?.reloadData()
            } else {
                print(info!)
            }
            

        }
    }
    
    // MARK: - setter
    lazy var groupTableview: WYPTableView = {
        let groupTableView = WYPTableView(frame: .zero, style: .plain)
        groupTableView.backgroundColor = UIColor.white
        groupTableView.rowHeight = 60
        groupTableView.delegate = self
        groupTableView.dataSource = self
        groupTableView.tableFooterView = UIView()
        
        groupTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadGroupsChangeData(requestType: .loadMore)
            
        })
        groupTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadGroupsChangeData(requestType: .update)
        })
        
        //注册
        groupTableView.register(GroupsTableViewCell.self, forCellReuseIdentifier: "groupsCell")
        return  groupTableView
    }()
    //懒加载我加入群的tableView
    lazy var secondGroupTableView:WYPTableView = {
        let secondGroupTableView = WYPTableView(frame: .zero, style: .plain)
        secondGroupTableView.backgroundColor = UIColor.white
        secondGroupTableView.rowHeight = 60
        secondGroupTableView.delegate = self
        secondGroupTableView.dataSource = self
        secondGroupTableView.tableFooterView = UIView()
        
        secondGroupTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadGroupsInData(requestType: .loadMore)
        })
        secondGroupTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadGroupsInData(requestType: .update)
        })
        
        //注册
        secondGroupTableView.register(GroupsTableViewCell.self, forCellReuseIdentifier: "groupsCell")
        return  secondGroupTableView
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
        label.text = "暂无群组"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
    
    //新增--start
    func setupUI(){
        //我管理的群
        let myManageGroupView = UIView()
        myManageGroupView.backgroundColor = UIColor.white
        let leftImageView = UIImageView()
        myManageGroupViewLetfImage = leftImageView
        leftImageView.image = UIImage(named: "chat_icon_advance_normalmore")
        myManageGroupView.addSubview(leftImageView)
        leftImageView.snp.makeConstraints { (make) in
            make.left.equalTo(myManageGroupView).offset(10)
            make.centerY.equalTo(myManageGroupView)
            make.height.width.equalTo(13)
        }
        let myManageGroupViewNameLabel = UILabel()
        myManageGroupViewNameLabel.text = "我管理的群"
        myManageGroupViewNameLabel.textColor = UIColor.black
        myManageGroupView.addSubview(myManageGroupViewNameLabel)
        myManageGroupViewNameLabel.snp.makeConstraints { (make) in
            make.center.equalTo(myManageGroupView.snp.center)
            make.left.equalTo(leftImageView.snp.right).offset(10)
        }
        view.addSubview(myManageGroupView)
        myManageGroupViewGlobal = myManageGroupView
        //我管理的群--添加手势
        let clickMyManageGroupGesture = UITapGestureRecognizer(target: self, action: #selector(clickMyManageGroupViewTap))
        myManageGroupView.addGestureRecognizer(clickMyManageGroupGesture)
        //我管理的群--添加tableView
        
        let tableView = groupTableview
        view.addSubview(tableView)
        myManageGroupTableView = tableView
        
        
        //我加入的群
        let myJionGroupView = UIView()
        myJionGroupView.backgroundColor = UIColor.white
        let leftImageView2 = UIImageView()
        myJoinGroupViewLetfImage = leftImageView2
        leftImageView2.image = UIImage(named: "chat_icon_advance_normalmore")
        myJionGroupView.addSubview(leftImageView2)
        leftImageView2.snp.makeConstraints { (make) in
            make.left.equalTo(myJionGroupView).offset(10)
            make.centerY.equalTo(myJionGroupView)
            make.height.width.equalTo(13)
        }
        let myJoingroupViewNameLabel = UILabel()
        myJoingroupViewNameLabel.text = "我加入的群"
        myJoingroupViewNameLabel.textColor = UIColor.black
        myJionGroupView.addSubview(myJoingroupViewNameLabel)
        myJoingroupViewNameLabel.snp.makeConstraints { (make) in
            make.center.equalTo(myJionGroupView.snp.center)
            make.left.equalTo(leftImageView2.snp.right).offset(10)
        }
        view.addSubview(myJionGroupView)
        myJoinGroupViewGlobal = myJionGroupView
        
        //我加入的群--添加手势
        let clickMyJoinGroupGesture = UITapGestureRecognizer(target: self, action: #selector(clickMyJoinGroupViewTap))
        myJionGroupView.addGestureRecognizer(clickMyJoinGroupGesture)
        
        
        //我加入的群--添加tableView
        let JoinTableView = secondGroupTableView
        view.addSubview(JoinTableView)
        myJoinGroupTableView = JoinTableView
        
    }
    
    //我管理的群--展开
    @objc func clickMyManageGroupViewTap(sender: UITapGestureRecognizer) {
        if ManagerGroupClickStatus == 0 {
            ManagerGroupClickStatus = 1
            //计算我管理群组tableView的高度
            let myManageGroupTableViewHeight = (dataSource0?.count)! * 60
            let referenceHeight1 = view.frame.maxY
            let referenceHeight2 = myManageGroupViewGlobal?.frame.maxY
            let referenceHeight = referenceHeight1 - referenceHeight2!
            if (CGFloat(myManageGroupTableViewHeight) > referenceHeight) {
                myManageGroupTableView?.snp.updateConstraints({ (make) in
                    make.height.equalTo(referenceHeight)
                })
            }else{
                myManageGroupTableView?.snp.updateConstraints({ (make) in
                    make.height.equalTo(myManageGroupTableViewHeight)
                })
            }
            myManageGroupViewLetfImage?.transform = CGAffineTransform(rotationAngle: 1.57)
            view.layoutIfNeeded()
            return
        }
        if ManagerGroupClickStatus == 1 {
            ManagerGroupClickStatus = 0
            myManageGroupTableView?.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            myManageGroupViewLetfImage?.transform = CGAffineTransform(rotationAngle: .pi*2*360/360)
            view.layoutIfNeeded()
            return
        }
    }
    
    //我加入的群--展开
    @objc func clickMyJoinGroupViewTap(sener:UITapGestureRecognizer) {
        if JoinGroupClickStatus == 0 && dataSource?.count != nil {
            JoinGroupClickStatus = 1
            //计算我管理群组tableView的高度
            let myJoinGroupTableViewHeight = (dataSource?.count)! * 60;
            let referenceHeight1 = view.frame.maxY
            let referenceHeight2 = myJoinGroupViewGlobal?.frame.maxY
            let referenceHeight = referenceHeight1 - referenceHeight2!
            if CGFloat(myJoinGroupTableViewHeight) > referenceHeight {
                myJoinGroupTableView?.snp.updateConstraints({ (make) in
                    make.height.equalTo(referenceHeight)
                })
            }else{
                myJoinGroupTableView?.snp.updateConstraints({ (make) in
                    make.height.equalTo(myJoinGroupTableViewHeight)
                })
            }
            myJoinGroupViewLetfImage?.transform = CGAffineTransform(rotationAngle: 1.57)
            view.layoutIfNeeded()
            return
        }
        if JoinGroupClickStatus == 1 {
            JoinGroupClickStatus = 0
            myJoinGroupTableView?.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            myJoinGroupViewLetfImage?.transform = CGAffineTransform(rotationAngle: .pi*2*360/360)
            view.layoutIfNeeded()
            return
            
        }
    }

    
}

extension GroupsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if dataSource?.count == 0 && dataSource0?.count == 0 {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
        }else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
        }
        
        
        if tableView.isEqual(myManageGroupTableView) {
                return dataSource0?.count ?? 0
        }
        return dataSource?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupsCell", for: indexPath) as! GroupsTableViewCell
        if tableView.isEqual(myManageGroupTableView) {
            cell.groupsModel = dataSource0?[indexPath.row]
        }else if tableView.isEqual(myJoinGroupTableView) {
            cell.groupsModel = dataSource?[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let groupsModel = dataSource?[indexPath.row]
        
        let conversationVC = ChatDeatilViewController()
        conversationVC.conversationType = RCConversationType.ConversationType_GROUP
        conversationVC.targetId = groupsModel?.groupId
        conversationVC.roomName = groupsModel?.roomName ?? ""
        conversationVC.groupName = groupsModel?.groupTitleName ?? ""
        navigationController?.pushViewController(conversationVC, animated: true)
    }
}



