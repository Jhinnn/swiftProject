//
//  AttentionRoomViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class AttentionRoomViewController: BaseViewController {
    
    var roomListData = [AttentionRoomModel]()
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        layoutPageSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadRoomsList(requestType: .update)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - private method
    private func viewConfig() {
        view.addSubview(showRoomTableView)
    }
    private func layoutPageSubviews() {
        showRoomTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 108, 0))
        }
    }
    func loadRoomsList(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.attentionRoomsNetRequest(page: "\(pageNumber)", openId: AppInfo.shared.user?.token ?? "") { (success, info, result) in
            if success {
                let array = result!.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                
                if requestType == .update {
                    self.roomListData = ([AttentionRoomModel].deserialize(from: jsonString) as? [AttentionRoomModel])!
                } else {
                    // 把新数据添加进去
                    let roomList = [AttentionRoomModel].deserialize(from: jsonString) as? [AttentionRoomModel]
                    
                    self.roomListData = self.roomListData + roomList!
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
                
                self.showRoomTableView.mj_header.endRefreshing()
                self.showRoomTableView.mj_footer.endRefreshing()
                self.showRoomTableView.reloadData()
            } else {
                self.showRoomTableView.mj_header.endRefreshing()
                self.showRoomTableView.mj_footer.endRefreshing()
            }

        }
    }
    
    // MARK: - Setter
    lazy var showRoomTableView: UITableView = {
        let showRoomTableView = UITableView(frame: .zero, style: .plain)
        showRoomTableView.rowHeight = 97
        showRoomTableView.delegate = self
        showRoomTableView.dataSource = self
        showRoomTableView.tableFooterView = UIView()
        showRoomTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadRoomsList(requestType: .loadMore)
        })
        showRoomTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadRoomsList(requestType: .update)
        })
        //注册
        showRoomTableView.register(AttentionRoomTableViewCell.self, forCellReuseIdentifier: "showRoomCell")
        
        return showRoomTableView
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
        label.text = "暂无关注的展厅"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
}

extension AttentionRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if roomListData.count == 0 {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
        }
        return roomListData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "showRoomCell") as! AttentionRoomTableViewCell
        cell.roomModel = roomListData[indexPath.row]
        return cell
    }
    
    // 选中单元格
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 跳转
        let showRoom = roomListData[indexPath.row]
        var board: UIStoryboard
        if showRoom.isFree == "0" {
            // 免费
            board = UIStoryboard.init(name: "FreeShowroomDetails", bundle: nil)
            let showroomFreeDetailsViewController = board.instantiateInitialViewController() as! ShowroomFreeDetailsViewController
            
            showroomFreeDetailsViewController.roomId = showRoom.roomId
            
            showroomFreeDetailsViewController.isFree = true
            
            navigationController?.pushViewController(showroomFreeDetailsViewController, animated: true)
        } else {
            // 收费
            board = UIStoryboard.init(name: "ShowroomDetails", bundle: nil)
            
            let showroomDetailsViewController = board.instantiateInitialViewController() as! ShowroomDetailsViewController
            
            showroomDetailsViewController.roomId = showRoom.roomId
            
            showroomDetailsViewController.isFree = false
        
            navigationController?.pushViewController(showroomDetailsViewController, animated: true)
        }
        
       
       
        

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
            let roomId = roomListData[indexPath.row].roomId ?? ""
            
            //1.从数据库将数据移除
            NetRequest.roomCancelAttentionNetRequest(openId: AppInfo.shared.user?.token ?? "", groupId: roomId, complete: { (success, info) in
                if success {
                    self.roomListData.remove(at: indexPath.row)
                    // 刷新单元格
                    tableView.reloadData()
                    SVProgressHUD.showSuccess(withStatus: info!)
                    SVProgressHUD.showSuccess(withStatus: info!)
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            })
            //2.刷新单元格
            tableView.reloadData()
        }
    }
}
