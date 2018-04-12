//
//  TopicsViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class TopicAnswerViewController: BaseViewController {
    
    var titleName: String?
    
    var targId: String?
    
    var dataList = [TopicsFrameModel]()
    
    var newsData = [MineTopicsModel]()
    
    var headerView: TopicHeaderView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        self.setupUIFrame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 加载网络数据
        loadNetData(requestType: .update)
    }
    
    
    
    
    
    // 设置控件frame
    fileprivate func setupUIFrame() {
        // 设置tableView的布局
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    
    
    
    // 设置tableView
    lazy var tableView: UITableView = {
        let tableView = WYPTableView()
        tableView.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        
        
        
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadNetData(requestType: .loadMore)
        })
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadNetData(requestType: .update)
        })
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TopicsCellIdentifier")
        tableView.register(TalkOnePictureTableViewCell.self, forCellReuseIdentifier: "onePicCell")
        tableView.register(TalkTravelTableViewCell.self, forCellReuseIdentifier: "textCell")
        tableView.register(TalkThreePictureTableViewCell.self, forCellReuseIdentifier: "threeCell")
        tableView.register(TalkVideoInfoTableViewCell.self, forCellReuseIdentifier: "videoCell")
        
        
        
        return tableView
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
        label.text = "暂无话题"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
    // 没有数据时跳转到抽奖模块
    lazy var noDataButton: UIButton = {
        let noDataButton = UIButton()
        noDataButton.setTitle("我要发话/抢发话题", for: .normal)
        noDataButton.setTitleColor(UIColor.themeColor, for: .normal)
        noDataButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        noDataButton.layer.masksToBounds = true
        noDataButton.layer.cornerRadius = 5.0
        noDataButton.layer.borderWidth = 1
        noDataButton.layer.borderColor = UIColor.themeColor.cgColor
        noDataButton.addTarget(self, action: #selector(releaseDynamic ), for: .touchUpInside)
        return noDataButton
    }()
    
    func releaseDynamic() {
        UserDefaults.standard.set(AppInfo.shared.user?.token ?? "", forKey: "token")
        var releaseVC = PublicGroupViewController()
        releaseVC = PublicGroupViewController.init()
        releaseVC.userToken = AppInfo.shared.user?.token ?? ""
        releaseVC.uid = AppInfo.shared.user?.userId ?? ""
        releaseVC.post_topic = "1"
        print(releaseVC.post_topic)
        navigationController?.pushViewController(releaseVC, animated: true)
    }
    
    func loadNetData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        
        NetRequest.myAnswerTopicListNetRequest(page: "\(pageNumber)", token: AppInfo.shared.user?.token ?? "",uid: self.targId!) { (success, info, dataArr,gambitCount) in
            
            if success {
                
                var news = [MineTopicsModel]()
                if dataArr?.count != 0 {
                    let data = try! JSONSerialization.data(withJSONObject: dataArr!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    news = [MineTopicsModel].deserialize(from: jsonString)! as! [MineTopicsModel]
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
                self.noDataButton.removeFromSuperview()
                // 没有数据的情况
                self.view.addSubview(self.noDataImageView)
                self.view.addSubview(self.noDataLabel)
                self.view.addSubview(self.noDataButton)
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
                self.noDataButton.snp.makeConstraints { (make) in
                    make.centerX.equalTo(self.view)
                    make.top.equalTo(self.noDataLabel.snp.bottom).offset(10)
                    make.size.equalTo(CGSize(width: 100, height: 20))
                }
                
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
            } else {
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
            }
        }
    }
    
}

extension TopicAnswerViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newsData.count == 0 {
            noDataLabel.isHidden = false
            noDataButton.isHidden = false
            noDataImageView.isHidden = false
        } else {
            noDataLabel.isHidden = true
            noDataButton.isHidden = true
            noDataImageView.isHidden = true
        }
        return newsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if newsData[indexPath.row].new_type == "1" {  //文字
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! TalkTravelTableViewCell
            cell.mineTopicsModel = newsData[indexPath.row]
            return cell
        }else if newsData[indexPath.row].new_type == "2"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! TalkVideoInfoTableViewCell
            cell.mineTopicsModel = newsData[indexPath.row]
            return cell
        }else if newsData[indexPath.row].new_type == "3"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "onePicCell", for: indexPath) as! TalkOnePictureTableViewCell
            cell.mineTopicsModel = newsData[indexPath.row]
            return cell
        }else if newsData[indexPath.row].new_type == "4"{ //三图
            let cell = tableView.dequeueReusableCell(withIdentifier: "threeCell", for: indexPath) as! TalkThreePictureTableViewCell
            cell.mineTopicsModel = newsData[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if newsData[indexPath.row].new_type == "1" {
            return 87.5 * width_height_ratio
        }else if newsData[indexPath.row].new_type == "2" {
            return 275 * width_height_ratio
        }else if newsData[indexPath.row].new_type == "3" {
            return 109 * width_height_ratio
        }else if newsData[indexPath.row].new_type == "4" {
            return 160 * width_height_ratio
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newsDetail = TalkNewsDetailsViewController()
        
        newsDetail.newsId = newsData[indexPath.row].topicId
        navigationController?.pushViewController(newsDetail, animated: true)
    }
//    // 修改删除按钮的文字
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "删除"
//    }
//    // 设置侧滑删除
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .delete
//    }
//    // 删除cell
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete{
//            let topicId = self.newsData[indexPath.row].topicId ?? ""
//
//            NetRequest.deleteMyTopicNetRequest(token: AppInfo.shared.user?.token ?? "", topicId: topicId, complete: { (success, info) in
//                if success {
//                    // 删除成功
//                    SVProgressHUD.showSuccess(withStatus: info)
//                    self.newsData.remove(at: indexPath.row)
//                    tableView.reloadData()
//                    // 删除成功
//                    SVProgressHUD.showSuccess(withStatus: info)
//
//                } else {
//                    // 删除失败
//                    SVProgressHUD.showError(withStatus: info)
//                }
//            })
//            //2.刷新单元格
//            tableView.reloadData()
//        }
//    }
}

extension TopicAnswerViewController: TopicsCellDelegate {
    func clickImageAction(sender: UIButton, topics: TopicsModel) {
        let personalInformationVC = PersonalInformationViewController()
        personalInformationVC.targetId = topics.peopleId ?? ""
        personalInformationVC.name = topics.nickName ?? ""
        navigationController?.pushViewController(personalInformationVC, animated: true)
    }
    
    func starDidSelected(sender: UIButton, topics: TopicsModel) {
        NetRequest.topicStarNetRequest(openId: AppInfo.shared.user?.token ?? "", newsId: topics.topicId ?? "", typeId: "1", cid: "") { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info!)
                sender.isSelected = true
                topics.isStar = "1"
                topics.starCount = "\(Int(topics.starCount!)! + 1)"
                self.tableView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
}

extension TopicAnswerViewController: TopicsDetailsViewControllerDelegate {
    
    func starBtnAction(topicId: String, topicsFrame: TopicsFrameModel) {
        for i in 0..<dataList.count {
            let frameModel = dataList[i]
            if frameModel.topics.topicId == topicId {
                dataList[i] = topicsFrame
            }
        }
    }
}
