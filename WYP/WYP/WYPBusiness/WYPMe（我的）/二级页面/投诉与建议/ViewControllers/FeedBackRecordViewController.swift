//
//  FeedBackRecordViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/9.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class FeedBackRecordViewController: BaseViewController {

    var recordData: [RecordModel]?
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfig()
        loadRecordData(requestType: .update)
    }
    
    func viewConfig() {
        self.title = "反馈记录"
        view.addSubview(recordTableView)
        recordTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }

    // MARK: - private method
    func loadRecordData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.feedBackRecordNetRequest(page: "\(pageNumber)", openId: AppInfo.shared.user?.token ?? "") { (success, info, result) in
            if success {
                
                let array = result!.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                if requestType == .update {
                    self.recordData = [RecordModel].deserialize(from: jsonString) as? [RecordModel]
                } else {
                    // 把新数据添加进去
                    let recordArray = [RecordModel].deserialize(from: jsonString) as? [RecordModel]
                    
                    self.recordData = self.recordData! + recordArray!
                }
                self.recordTableView.reloadData()
                self.recordTableView.mj_header.endRefreshing()
                self.recordTableView.mj_footer.endRefreshing()
            } else {
                self.recordTableView.mj_header.endRefreshing()
                self.recordTableView.mj_footer.endRefreshing()
            }
        }
    }
    
    // MARK: - setter and getter
    lazy var recordTableView: UITableView = {
        let recordTableView = UITableView()
        recordTableView.delegate = self
        recordTableView.dataSource = self
        recordTableView.rowHeight = 60
        recordTableView.tableFooterView = UIView()
        recordTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadRecordData(requestType: .loadMore)
        })
        recordTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadRecordData(requestType: .update)
        })
        recordTableView.register(RecordsTableViewCell.self, forCellReuseIdentifier: "recordCell")
        return recordTableView
    }()
    

}

extension FeedBackRecordViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recordData != nil {
            return recordData?.count ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! RecordsTableViewCell
        if recordData != nil {
            print(recordData!)
            cell.records = recordData?[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recordDetail = RecordsDeatilViewController()
        recordDetail.recordId = recordData?[indexPath.row].recordId ?? ""
        recordDetail.recordCode = recordData?[indexPath.row].recordCode ?? ""
        navigationController?.pushViewController(recordDetail, animated: true)
    }
}
