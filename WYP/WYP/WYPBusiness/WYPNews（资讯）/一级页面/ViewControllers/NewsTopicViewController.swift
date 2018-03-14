//
//  NewsTopicViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/10.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class NewsTopicViewController: BaseViewController {

    var dataList = [TopicsFrameModel]()
    // 标记是否是搜索页
    var flag = 1
    // 搜索关键字
    var keyword: String?
    
    //设置刷新次数
    var upnumb: Int = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的话题"
        
        setupUI()
        
        // 加载网络数据
        loadNewsData(requestType: .update)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        KRefreshDataCount().label.isHidden = true
    }
    
    // MARK: - Private Methods
    // 设置所有控件
    fileprivate func setupUI() {
        view.addSubview(tableView)
        view.addSubview(commentView)
        commentView.addSubview(commentButton)
        setupUIFrame()
    }
    
    // 设置控件frame
    fileprivate func setupUIFrame() {
        // 设置tableView的布局
        if flag == 2 {
            tableView.snp.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 108, 0))
            }
        } else {
            tableView.snp.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 167, 0))
            }
        }
        
        commentView.snp.makeConstraints { (make) in
            make.bottom.equalTo(tableView.snp.bottom)
            make.size.equalTo(CGSize(width: kScreen_width / 2, height: 30))
            make.centerX.equalTo(view)
        }
        commentButton.snp.makeConstraints { (make) in
            make.left.equalTo(commentView)
            make.right.equalTo(commentView)
            make.centerY.equalTo(commentView)
            make.height.equalTo(30)
        }
    }
    
    func loadNewsData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        if flag == 2 { // 资讯搜索话题
            NetRequest.newsSearchNetRequest(title: keyword ?? "", categoryId: "12", page: "\(pageNumber)") { (success, info, result) in
                if success {
                    let array = result!.value(forKey: "data")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    let topicModel = [TopicsModel].deserialize(from: jsonString) as? [TopicsModel]
                    var models = [TopicsFrameModel]()
                    for topics in topicModel! {
                        let topicsFrame = TopicsFrameModel()
                        topicsFrame.topics = topics
                        models.append(topicsFrame)
                    }
                    if requestType == .update {
                        self.dataList = models
                    } else {
                        // 把新数据添加进去
                        self.dataList = self.dataList + models
                    }
                    // 先移除再添加
                    self.noDataImageView.removeFromSuperview()
                    self.noDataLabel.removeFromSuperview()
                    // 没有数据的时候
                    self.noDataLabel.text = "内容已飞外太空"
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
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                    self.tableView.reloadData()
                } else {
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                }
            }
        } else {
            NetRequest.newsNetRequest(page: "\(pageNumber)", type_id: "12", uid: AppInfo.shared.user?.userId ?? "", userId: AppInfo.shared.user?.userId ?? "",  upParams: upnumb) { (success, info, result) in
                if success {
                    self.upnumb = self.upnumb + 1
                    print(self.upnumb)
                    let array = result!.value(forKey: "ziXun")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    
                    let topicModel = [TopicsModel].deserialize(from: jsonString) as? [TopicsModel]
                    var models = [TopicsFrameModel]()
                    for topics in topicModel! {
                        let topicsFrame = TopicsFrameModel()
                        topicsFrame.topics = topics
                        models.append(topicsFrame)
                    }
                    if requestType == .update {
                        self.dataList = models
                        KRefreshDataCount().showNewDataCountAlert(count: self.dataList.count, alertFrame: CGRect(x: 0, y: -30, width: kScreen_width, height: 30), view: self.view)
                    } else {
                        // 把新数据添加进去
                        self.dataList = self.dataList + models
                    }
                    
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
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                    self.tableView.reloadData()
                    
                } else {
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                }
            }
        }
        
    }

    // MARK: - event response
    func issueTopic(sender: UIButton) {
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        } else {
            let board = UIStoryboard.init(name: "Main", bundle: nil)
            let issue = board.instantiateViewController(withIdentifier: "issueTopics") as! IssueTopicViewController
            issue.delegate = self
            navigationController?.pushViewController(issue, animated: true)
        }
    }
    
    // MARK: - setter and getter
    // 设置tableView
    lazy var tableView: WYPTableView = {
        let tableView = WYPTableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        // 刷新
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadNewsData(requestType: .loadMore)
        })
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadNewsData(requestType: .update)
        })
        tableView.rowHeight = 110
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TopicsCellIdentifier")
        return tableView
    }()
    
    // 底部的view
    lazy var commentView: UIView = {
        let commentView = UIView()
        commentView.backgroundColor = UIColor.white
        return commentView
    }()
    
    // 评论框
    lazy var commentButton: UIButton = {
        let commentButton = UIButton()
        commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        commentButton.setTitle("发布话题", for: .normal)
        commentButton.setTitleColor(UIColor.white, for: .normal)
        commentButton.backgroundColor = UIColor.themeColor
        commentButton.layer.borderColor = UIColor.init(hexColor: "f1f2f4").cgColor
        commentButton.layer.borderWidth = 1
        commentButton.layer.cornerRadius = 5.0
        commentButton.layer.masksToBounds = true
        commentButton.addTarget(self, action: #selector(issueTopic(sender:)), for: .touchUpInside)
        return commentButton
    }()
    
    // 没有数据时的图片
    lazy var noDataImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "common_noResult_icon_normal_iPhone")
        return imageView
    }()
    // 没有找到结果
    lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "没有找到结果"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
}

extension NewsTopicViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataList.count == 0 {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
        }
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TopicsCell(style: .default, reuseIdentifier: "TopicsViewIdentifier")
        cell.topicsFrame = dataList[indexPath.row]
        cell.starCountButton.tag = 120 + indexPath.row
        cell.delegate = self
    
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let topicsFrame = dataList[indexPath.row]
        return topicsFrame.cellHeight!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let topicsDetail = TopicsDetailsViewController()
        topicsDetail.delegate = self
        topicsDetail.topicId = dataList[indexPath.row].topics.topicId ?? ""
        topicsDetail.contentData = dataList[indexPath.row].topics
        navigationController?.pushViewController(topicsDetail, animated: true)
    }
}

extension NewsTopicViewController: TopicsCellDelegate {
    func clickImageAction(sender: UIButton, topics: TopicsModel) {
        let personalInformationVC = PersonalInformationViewController()
        personalInformationVC.targetId = topics.peopleId ?? ""
        personalInformationVC.name = topics.nickName ?? ""
        navigationController?.pushViewController(personalInformationVC, animated: true)
    }
    
    func starDidSelected(sender: UIButton, topics: TopicsModel) {
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        NetRequest.topicStarNetRequest(openId: token, newsId: topics.topicId ?? "", typeId: "1", cid: "") { (success, info) in
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

extension NewsTopicViewController: TopicsDetailsViewControllerDelegate {
    
    func starBtnAction(topicId: String, topicsFrame: TopicsFrameModel) {
        for i in 0..<dataList.count {
            let frameModel = dataList[i]
            if frameModel.topics.topicId == topicId {
                dataList[i] = topicsFrame
                tableView.reloadData()
            }
        }
    }
}

extension NewsTopicViewController: IssueTopicViewControllerDelegate {
    func issueTopicsSuccess() {
        loadNewsData(requestType: .update)
    }
}
