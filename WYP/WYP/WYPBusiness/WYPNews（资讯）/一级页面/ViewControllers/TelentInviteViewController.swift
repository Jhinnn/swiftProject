//
//  TelentInviteViewController.swift
//  WYP
//
//  Created by Arthur on 2018/2/2.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class TelentInviteViewController: BaseViewController {

    var new_id: String?
    
    var dataSource = [IntelligentModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        setupUI()
        loadIntelligentData()
        
    }
    
    // MARK: 加载达人数据
    func loadIntelligentData() {
        NetRequest.getIntelligentListNetRequest(page: "\(pageNumber)",new_id: self.new_id ?? "") { (success, info, result) in
            if success {
                self.dataSource.removeAll()
                for dic in result! {
                    let model = IntelligentModel.deserialize(from: dic)
                    self.dataSource.append(model!)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            if deviceTypeIPhoneX() {
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 34 + 50, 0))
            }else {
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 50, 0))
            }
            
        }
    }
    
    
    lazy var tableView: WYPTableView = {
        let newAllTableView = WYPTableView()
        newAllTableView.backgroundColor = UIColor.white
        newAllTableView.delegate = self
        newAllTableView.dataSource = self
        newAllTableView.rowHeight = 58
        newAllTableView.tableFooterView = UIView()
        newAllTableView.register(UINib(nibName: "InviteTableViewCell", bundle: nil), forCellReuseIdentifier: "inteCell")
        return newAllTableView
    }()

}

extension TelentInviteViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inteCell", for: indexPath) as! InviteTableViewCell
        cell.delegate = self
        cell.model =  self.dataSource[indexPath.row]
        return cell
    }
}

extension TelentInviteViewController: InviteTableViewCellDelegate{
    func pushToPersonInfo(_ IntelligentCell: InviteTableViewCell, intelligentModel model: IntelligentModel) {
        let personalInformationVC = PersonalInformationViewController()
        personalInformationVC.targetId = model.uid ?? ""
        personalInformationVC.name = model.nickname ?? ""
        self.navigationController?.pushViewController(personalInformationVC, animated: true)
    }
    
    func inviteActionCell(_ IntelligentCell: InviteTableViewCell, intelligentModel model: IntelligentModel) {
        
        
        NetRequest.inviteFriendsNetRequest(uid: model.uid ?? "", new_id: self.new_id ?? "") { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info)
                self.loadIntelligentData()
            }
        }
    }
 
}


