//
//  AttentionNewsViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class MyAqAnswerViewController: BaseViewController {
    
    var type: NSInteger = 0
    
    var gamitCount: String?
    
    // 数据源
    var newsData = [MineTopicsModel]()
    
    //
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        layoutPageSubviews()
        
        loadNetData(requestType: .update)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    // MARK: - private method
    private func viewConfig() {
        view.addSubview(tableView)
    }
    private func layoutPageSubviews() {
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
     
    }
    
    
    func loadNetData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        
        NetRequest.myAnswerTopicListNetRequest(page: "\(pageNumber)", token: AppInfo.shared.user?.token ?? "",uid: AppInfo.shared.user?.userId ?? "") { (success, info, dataArr,gambitCount) in
            
            if success {
                
                var news = [MineTopicsModel]()
                if dataArr?.count != 0 {
                    let data = try! JSONSerialization.data(withJSONObject: dataArr!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    news = [MineTopicsModel].deserialize(from: jsonString)! as! [MineTopicsModel]
                    
                    self.gamitCount = gambitCount
                }else {
                    self.tableView.mj_footer.endRefreshing()
                    return
                }

                if requestType == .update {
                    self.newsData = news
                }else {
                    self.newsData = self.newsData + news
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

                
                self.tableView.reloadData()
//                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
            } else {
//                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
            }
        }
    }
    
    
    // MARK: - setter and getter
    lazy var tableView: UITableView = {
        let newsTableView = WYPTableView()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.tableFooterView = UIView()
        newsTableView.estimatedRowHeight = 500
        newsTableView.rowHeight = UITableViewAutomaticDimension
        newsTableView.separatorStyle = .none
        newsTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadNetData(requestType: .loadMore)
        })
    
        newsTableView.register(UINib.init(nibName: "QaCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "onePicCell")
        return newsTableView
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
        label.text = "暂无关注的话题"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
}

extension MyAqAnswerViewController: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newsData.count == 0 {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
        }
        return newsData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "onePicCell", for: indexPath) as! QaCollectionTableViewCell
        cell.infoModels = newsData[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: 35))
        view.backgroundColor = UIColor.init(hexString: "F4F8FB")
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: 35))
        label.text = "    我的回答(\(self.gamitCount ?? "0"))"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(label)
        return view
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    // 选中单元格
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let vc = TalkNewsDetailsCommentViewController()
        vc.newsId = newsData[indexPath.row].reply?.news_id
        vc.pid = newsData[indexPath.row].reply?.id
        vc.newsTitle = newsData[indexPath.row].title
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
  
}




