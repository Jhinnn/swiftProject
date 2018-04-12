//
//  ExpertListViewController.swift
//  WYP
//
//  Created by aLaDing on 2018/4/8.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class ExpertListViewController: BaseViewController {
    
    var newExpertData = [ExpertModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "专家团"
        viewConfig()
        layoutPageSubviews()
        loadData(requestType: .update)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.black]
    }
    
    private func viewConfig() {
        view.addSubview(tableView)
    }
    private func layoutPageSubviews() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
            
        }
    }

    func loadData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.findExpertListNetRequest(limit: "10",page: "\(pageNumber)") { (success, info, dataArr) in
            if success {
                let data = try! JSONSerialization.data(withJSONObject: dataArr!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                
                if requestType == .loadMore {
                    let data = [ExpertModel].deserialize(from: jsonString)! as! [ExpertModel]
                    self.newExpertData = self.newExpertData + data
                }else {
                    self.newExpertData = [ExpertModel].deserialize(from: jsonString)! as! [ExpertModel]
                }
                self.tableView.mj_footer.endRefreshing()
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    // MARK: - setter and getter
    lazy var tableView: UITableView = {
        let newsTableView = WYPTableView()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView   .tableFooterView = UIView()
        newsTableView.register(UINib.init(nibName: "FindExpTableViewCell", bundle: nil), forCellReuseIdentifier: "expCell")
        newsTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadData(requestType: .loadMore)
        })


        return newsTableView
    }()
}

extension ExpertListViewController: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newExpertData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expCell", for: indexPath) as? FindExpTableViewCell
        cell?.delegate = self
        if self.newExpertData.count != 0 {
            cell?.expertModel = self.newExpertData[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    // 选中单元格
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            let personInfoVC = PersonInfoViewController()
//            self.navigationController?.pushViewController(personInfoVC, animated: true)
    }
    
}


extension ExpertListViewController: FindExpAttentionDelegate{
    
    func attentionActionCell(_ findExpTableViewCell: FindExpTableViewCell, expertModel model: ExpertModel) {
        if !findExpTableViewCell.attentionBtn.isSelected {    //normal  已关注  //未关注
            NetRequest.addOrCancelAttentionNetRequest(method: "DELETE", mid: AppInfo.shared.user?.userId ?? "", follow_who: model.uid ?? "") { (success, info) in
                
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    
                    self.loadData(requestType: .update)
                    model.is_follow = "0"
                    self.tableView.reloadData()
                    
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
        }else {
            NetRequest.addOrCancelAttentionNetRequest(method: "POST", mid: AppInfo.shared.user?.userId ?? "", follow_who: model.uid ?? "") { (success, info) in
                
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    model.is_follow = "1"
                    self.loadData(requestType: .update)
                    self.tableView.reloadData()
                    
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
            
        }
    }
    
  
    
}
