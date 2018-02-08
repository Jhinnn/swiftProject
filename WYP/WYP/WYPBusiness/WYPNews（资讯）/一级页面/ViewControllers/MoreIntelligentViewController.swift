//
//  MoreIntelligentViewController.swift
//  WYP
//
//  Created by Arthur on 2018/2/2.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class MoreIntelligentViewController: BaseViewController {
    
    var dataSource = [IntelligentModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "达人榜"
        view.backgroundColor = UIColor.white
        
        setupUI()
        loadIntelligentData(requestType: .update)
    }
    
    
    
    
    // MARK: 加载达人数据
    func loadIntelligentData(requestType: RequestType) {
        
//        if requestType == .update {
//            pageNumber = 1
//        } else {
//            pageNumber = pageNumber + 1
//        }
        
        NetRequest.getIntelligentListNetRequest(page: "\(pageNumber)",new_id: "") { (success, info, result) in
            if success {
                self.dataSource.removeAll()
                for dic in result! {
                    let model = IntelligentModel.deserialize(from: dic)
                    self.dataSource.append(model!)
                }
                
                self.tableView.reloadData()
//                self.tableView.mj_header.endRefreshing()
//                self.tableView.mj_footer.endRefreshing()
                
            }
        }
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }

    
    lazy var tableView: WYPTableView = {
        let newAllTableView = WYPTableView()
        newAllTableView.backgroundColor = UIColor.white
        newAllTableView.delegate = self
        newAllTableView.dataSource = self
        newAllTableView.rowHeight = 58
        newAllTableView.tableFooterView = UIView()
        // 刷新
//        newAllTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
//            self.loadIntelligentData(requestType: .loadMore)
//        })
//        newAllTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
//            self.loadIntelligentData(requestType: .update)
//        })
        
        newAllTableView.register(UINib(nibName: "IntelligentListTableViewCell", bundle: nil), forCellReuseIdentifier: "inteCell")
        return newAllTableView
    }()
    
   
    
    
}

extension MoreIntelligentViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inteCell", for: indexPath) as! IntelligentListTableViewCell
        cell.delegate = self
        let model = self.dataSource[indexPath.row]
        cell.model = model
        return cell
    }
}

extension MoreIntelligentViewController: IntellListTabelViewDelegate {
    func pushToPersonInfo(_ IntelligentCell: IntelligentListTableViewCell, intelligentModel model: IntelligentModel) {
        let personalInformationVC = PersonalInformationViewController()
        personalInformationVC.targetId = model.uid ?? ""
        personalInformationVC.name = model.nickname ?? ""
        self.navigationController?.pushViewController(personalInformationVC, animated: true)
    }
    

    
    func attentionActionCell(_ IntelligentCell: IntelligentListTableViewCell, intelligentModel model: IntelligentModel) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "IntelligentNotifaction"), object: nil)
        
        if !IntelligentCell.attentionButton.isSelected {    //normal  已关注  //未关注
            NetRequest.addOrCancelAttentionNetRequest(method: "DELETE", mid: AppInfo.shared.user?.userId ?? "", follow_who: model.uid ?? "") { (success, info) in
                
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    
                    self.loadIntelligentData(requestType: .update)
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
                    self.loadIntelligentData(requestType: .update)
                    self.tableView.reloadData()
                    
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
        
        }
    }
    
    
}

