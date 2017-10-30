//
//  TopicsViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class TopicsViewController: BaseViewController {
    
    var dataList = [TopicsFrameModel]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的话题"
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 加载网络数据
        loadNetData(requestType: .update)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Public Methods
    
    
    // MARK: - Private Methods
    
    // 设置所有控件
    fileprivate func setupUI() {
        view.addSubview(tableView)
        
        setupUIFrame()
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
        let tableView = UITableView(frame: .zero, style: .plain)
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
        tableView.rowHeight = 110
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TopicsCellIdentifier")
        
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
        noDataButton.addTarget(self, action: #selector(pushToIssueTopic(sender:)), for: .touchUpInside)
        return noDataButton
    }()
    
    func pushToIssueTopic(sender: UIButton) {
        let board = UIStoryboard.init(name: "Main", bundle: nil)
        let issue = board.instantiateViewController(withIdentifier: "issueTopics") as! IssueTopicViewController
        navigationController?.pushViewController(issue, animated: true)
    }
    
    func loadNetData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.myTopicListNetRequest(page: "\(pageNumber)", token: AppInfo.shared.user?.token ?? "") { (success, info, dataArr) in
            if success {
                var models = [TopicsFrameModel]()
                for dic in dataArr! {
                    let topics = TopicsModel.deserialize(from: dic)
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
    
    // MARK: - IBActions
    
    
    // MARK: - Getter
    
    
    // MARK: - Setter
    
    
    // MARK: - UITableViewDataSource
    
    
    // MARK: - UITableViewDelegate
    
    
    // MARK: - Other Delegate
    
    
    // MARK: - NSCopying
}

extension TopicsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataList.count == 0 {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
            noDataButton.isHidden = false
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
            noDataButton.isHidden = true
        }
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TopicsCell(style: .default, reuseIdentifier: "TopicsViewIdentifier")
        cell.delegate = self
        cell.starCountButton.tag = 110 + indexPath.row
        cell.topicsFrame = dataList[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let topicsFrame = dataList[indexPath.row]
        return topicsFrame.cellHeight!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let topicDetails = TopicsDetailsViewController()
        topicDetails.delegate = self
        topicDetails.topicId = dataList[indexPath.row].topics.topicId!
        topicDetails.contentData = dataList[indexPath.row].topics
        navigationController?.pushViewController(topicDetails, animated: true)
    }
    // 修改删除按钮的文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    // 设置侧滑删除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    // 删除cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            let topicId = dataList[indexPath.row].topics.topicId ?? ""
            
            NetRequest.deleteMyTopicNetRequest(token: AppInfo.shared.user?.token ?? "", topicId: topicId, complete: { (success, info) in
                if success {
                    // 删除成功
                    SVProgressHUD.showSuccess(withStatus: info)
                    self.dataList.remove(at: indexPath.row)
                    tableView.reloadData()
                    // 删除成功
                    SVProgressHUD.showSuccess(withStatus: info)
                    
                } else {
                    // 删除失败
                    SVProgressHUD.showError(withStatus: info)
                }
            })
            //2.刷新单元格
            tableView.reloadData()
        }
    }
}

extension TopicsViewController: TopicsCellDelegate {
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

extension TopicsViewController: TopicsDetailsViewControllerDelegate {

    func starBtnAction(topicId: String, topicsFrame: TopicsFrameModel) {
        for i in 0..<dataList.count {
            let frameModel = dataList[i]
            if frameModel.topics.topicId == topicId {
                dataList[i] = topicsFrame
            }
        }
    }
}
