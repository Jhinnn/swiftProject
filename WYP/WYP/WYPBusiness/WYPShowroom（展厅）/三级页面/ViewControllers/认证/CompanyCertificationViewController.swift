//
//  CompanyCertificationViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/18.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class CompanyCertificationViewController: BaseViewController {

    let titleArray = ["企业名称：","营业执照编号："]
    var contentArray: [String]?

    // 展厅id
    var roomId: String?
    // 企业认证证书
    var imageUrl: URL?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        layoutPageSubviews()
        
        // 获取数据
        loadCertificationData()
    }
    
    // MARK: - private method
    private func viewConfig() {
        self.title = "企业认证"
        view.addSubview(companyTableView)
    }
    
    private func layoutPageSubviews() {
        companyTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    private func loadCertificationData() {
        NetRequest.comanyCertificationNetRequest(roomId: roomId ?? "") { (success, info, result) in
            if success {
                self.contentArray = [String]()
                self.contentArray?.append(result?.value(forKey: "title") as! String)
                self.contentArray?.append(result?.value(forKey: "number") as! String)
                self.contentArray?.append(result?.value(forKey: "address") as! String)
                self.contentArray?.append(result?.value(forKey: "person") as! String)
                self.contentArray?.append(result?.value(forKey: "business_scope") as! String)
                self.contentArray?.append(result?.value(forKey: "term_of_validity") as! String)
                
                self.imageUrl = URL(string: result?.value(forKey: "pic") as! String)
                
                self.companyTableView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
            
        }
    }
    
    // MARK: - Setter
    lazy var companyTableView: UITableView = {
        let companyTableView = UITableView()
        companyTableView.rowHeight = 105
        companyTableView.delegate = self
        companyTableView.dataSource = self
        //注册
        companyTableView.register(CompanyCertificationTableViewCell.self, forCellReuseIdentifier: "companyCertificationCell")
        companyTableView.register(CertificationTableViewCell.self, forCellReuseIdentifier: "certificationImageCell")
        
        return companyTableView
    }()
}

extension CompanyCertificationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return titleArray.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if contentArray != nil {
                let cell  = tableView.dequeueReusableCell(withIdentifier: "companyCertificationCell") as! CompanyCertificationTableViewCell
                let companyModel = CompanyCertificationModel()
                companyModel.title = titleArray[indexPath.row]
                companyModel.content = contentArray?[indexPath.row]
                let companyFrameModel = CompanyCertificationFrameModel()
                companyFrameModel.companyModel = companyModel
                cell.companyFrame = companyFrameModel
                return cell
            } 
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "certificationImageCell", for: indexPath) as! CertificationTableViewCell
            cell.certificationImageView.kf.setImage(with: imageUrl)
            return cell
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && contentArray != nil {
            let companyModel = CompanyCertificationModel()
            companyModel.title = titleArray[indexPath.row]
            companyModel.content = contentArray?[indexPath.row]
            let companyFrameModel = CompanyCertificationFrameModel()
            companyFrameModel.companyModel = companyModel
            return companyFrameModel.cellHeight!
        }
        return 200
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        } else {
            return 0.01
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 30))
            let label = UILabel(frame: CGRect(x: 13, y: 10.5, width: 100, height: 13))
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = UIColor.init(hexColor: "333333")
            label.text = "资质认证"
            headerView.addSubview(label)
            
            return headerView
        }
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        return 30
    }
}
