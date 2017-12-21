//
//  GroupNoteViewController.swift
//  WYP
//
//  Created by 曾雪峰 on 2017/12/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class GroupNoteViewController: BaseViewController {
    
    var groupId : String?
    var page : Int = 1
    var dataSource : [GroupNoteModel] = []
    var rank : String?
    
    lazy var rightBtn: UIButton = {
        let rightBtn = UIButton()
        rightBtn.setImage(UIImage.init(named: "notice_icon_edit_normal"), for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBtnClicked(sender:)), for: .touchUpInside)
        return rightBtn
    }()
    
    func rightBtnClicked(sender: UIButton?) -> Void {
        let pubLishGroupNoteVC = PublishGroupNoticeViewController()
        pubLishGroupNoteVC.groupId = self.groupId
        self.navigationController?.pushViewController(pubLishGroupNoteVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        self.tableView.mj_header = MJRefreshHeader.init(refreshingBlock: {
            self.page = 1
            self.sendNetRequest()
            self.tableView.mj_header.endRefreshing()
        })
        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.sendNetRequest()
            self.tableView.mj_footer.endRefreshing()
        })
        self.tableView.mj_header.beginRefreshing()
    }
    
    
    
    func setupUI(){
        
        self.title = "群公告"
//        if Int(self.rank!) != 1 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.rightBtn)
//        }
        view.addSubview(tableView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: kScreen_height), style: .grouped)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        //        tableView.rowHeight = UITableViewAutomaticDimension
        //        tableView.estimatedRowHeight = 200
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "groupNoteCellIdentifier")
        return tableView
        
    }()
    
    func sendNetRequest() {
        NetRequest.getGroupNoteListNetRequest(page: "\(self.page)", groupId: "317") { (success, info, result) in
            if success {
                let array = [GroupNoteModel].deserialize(from: result) as? [GroupNoteModel]
                if self.page != 1 {
                    self.dataSource = self.dataSource + array!
                }else {
                    self.dataSource = array!
                }
                self.tableView.reloadData()
            }else {
                print(info!)
            }
        }
    }
    
}

extension GroupNoteViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = GroupNoteTableViewCell(style: .default, reuseIdentifier: "groupNoteCellIdentifier")
        let model = self.dataSource[indexPath.section]
        cell.noteTitle.text = model.title
        cell.people.text = model.author
        cell.pubTime.text = "时间（" + getFormotterTime(time: model.create_time) + "）"
        cell.contentLabel.text = model.content
        cell.numberLabel.text = model.view! + "人阅读"
        cell.imageUrls = model.path
        cell.moreBtn.addTarget(self, action: #selector(moreBtnClicked(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func moreBtnClicked(sender: UIButton?) -> Void {
        print("moreBtn被点击")
    }
    
    func getFormotterTime(time : String?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日 HH:mm"
        let date : Date = Date.init(timeIntervalSince1970: (time! as NSString).doubleValue)
        return formatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}

