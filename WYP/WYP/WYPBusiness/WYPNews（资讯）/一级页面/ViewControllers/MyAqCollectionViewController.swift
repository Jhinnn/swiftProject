//
//  AttentionNewsViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class MyAqCollectionViewController: BaseViewController {
    
    var type: NSInteger = 0
    
    var gamitCount: String?
    
    // 数据源
    var newsData = [NewTopicModel]()
    
    //
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        layoutPageSubviews()
        
        loadSearchResult(requestType: .update)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    // MARK: - private method
    private func viewConfig() {
        view.addSubview(newsTableView)
    }
    private func layoutPageSubviews() {
        newsTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
  
        }
    }
    
    // 获取搜索结果
    private func loadSearchResult(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.attentionTopicNewNetRequest(page: "\(pageNumber)", openId: AppInfo.shared.user?.token ?? "") { (success, info, result) in
            if success {
                
                var newsArray = [NewTopicModel]()
                
                let dic = result!.value(forKey: "data") as! NSDictionary
                self.gamitCount = dic["gambit_num"] as? String
                
                let array = dic["gambit"]
                
                
                
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                
                
                if requestType == .update {
                    self.newsData = ([NewTopicModel].deserialize(from: jsonString) as? [NewTopicModel])!
                } else {
                    // 把新数据添加进去
                    newsArray = ([NewTopicModel].deserialize(from: jsonString) as? [NewTopicModel])!
                    
                    if newsArray.count == 0 {
                        
                        self.newsTableView.mj_footer.endRefreshing()
//                        self.newsTableView.mj_header.endRefreshing()
                        return
                    }else {
                        self.newsData = self.newsData + newsArray
                    }
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
                
//                self.newsTableView.mj_header.endRefreshing()
                self.newsTableView.mj_footer.endRefreshing()
                self.newsTableView.reloadData()
            } else {
                
//                self.newsTableView.mj_header.endRefreshing()
                self.newsTableView.mj_footer.endRefreshing()
            }
        }
    }
    
    // MARK: - setter and getter
    lazy var newsTableView: UITableView = {
        let newsTableView = WYPTableView()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.tableFooterView = UIView()
        newsTableView.estimatedRowHeight = 500
        newsTableView.rowHeight = UITableViewAutomaticDimension
        
        newsTableView.separatorStyle = .none
        newsTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadSearchResult(requestType: .loadMore)
        })
//        newsTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
//            self.loadSearchResult(requestType: .update)
//        })
        
//        newsTableView.register(TalkTravelTableViewCell.self, forCellReuseIdentifier: "textCell")
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

extension MyAqCollectionViewController: UITableViewDelegate,UITableViewDataSource {
    
    
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
        cell.infoModel = newsData[indexPath.row]
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        switch newsData[indexPath.row].showType ?? 0 {
//        case 1:
//            return 87.5 * width_height_ratio
//        case 2:
//            return 280 * width_height_ratio
//        case 3:
//            return 109 * width_height_ratio
//        case 4:
//            return 160 * width_height_ratio
//        default:
//            return 0
//        }
//
//
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: 35))
        view.backgroundColor = UIColor.init(hexString: "F4F8FB")
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: 35))
        label.text = "    收藏问题(\(self.gamitCount ?? "0"))"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(label)
        return view
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    // 选中单元格
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        let newsDetail = TalkNewsDetailsViewController()
        newsDetail.newsTitle = newsData[indexPath.row].description
        newsDetail.newsId = newsData[indexPath.row].id
        newsDetail.commentNumber = newsData[indexPath.row].comment
        navigationController?.pushViewController(newsDetail, animated: true)
        
        
    }
    // 设置侧滑删除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    // 修改删除按钮的文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "取消关注"
    }
//    // 删除cell
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete{
////            let newsId = newsData[indexPath.row].newsId ?? ""
//            //            newsData?.remove(at: indexPath.row)
//            //1.从数据库将数据移除
//            NetRequest.cancelAttentionNetRequest(openId: (AppInfo.shared.user?.token)!, newsId: newsId, complete: { (success, info) in
//                if success {
//                    self.newsData.remove(at: indexPath.row)
//                    // 刷新单元格
//                    tableView.reloadData()
//                    SVProgressHUD.showSuccess(withStatus: info!)
//                } else {
//                    SVProgressHUD.showError(withStatus: info!)
//                }
//            })
//        }
//    }
}



