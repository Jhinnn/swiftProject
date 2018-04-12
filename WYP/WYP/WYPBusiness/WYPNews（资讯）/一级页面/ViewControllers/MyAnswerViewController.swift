//
//  MyAnswerViewController.swift
//  WYP
//
//  Created by aLaDing on 2018/4/2.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class MyAnswerViewController: UIViewController {
    
    var type: NSInteger = 0
    
    var gamitCount: String?
    
    // 数据源
    var newsData = [MineTopicsModel]()

    // 加载页数
    var pageNumber: Int = 1
    
    var btn: UIButton? = nil
    var bgView: UIView? = nil
    
    
    var topicID: String?
    
    // 刷新加载
    enum RequestType {
        case update
        case loadMore
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        self.navigationItem.titleView = searchTitleView
        
        viewConfig()
       
        loadNetData(requestType: .update)
    }
    
    
 
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func viewConfig() {
       
        let leftBarBtn = UIBarButtonItem(image: UIImage(named: "common_blackback_button_normal_iPhone"), style: .done, target: self, action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        view.addSubview(tableView)
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
        
        NetRequest.anwerQusetionListNetRequest(page: "\(pageNumber)") { (success, info, dataArr) in
            if success {
                
                var news = [MineTopicsModel]()
                
                if dataArr?.count != 0 {
                    let data = try! JSONSerialization.data(withJSONObject: dataArr!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    news = [MineTopicsModel].deserialize(from: jsonString)! as! [MineTopicsModel]
                }else {
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                    
                }
                if requestType == .update {
                    self.newsData = news
                }else {
                    self.newsData = self.newsData + news
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
        newsTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadNetData(requestType: .update)
        })

        newsTableView.register(UINib.init(nibName: "AnswerQuesTableViewCell", bundle: nil), forCellReuseIdentifier: "onePicCell")
        return newsTableView
    }()
    
  
    

    func backToPrevious() {
        self.navigationController?.popViewController(animated: true)
    }

    
    // 导航栏上的view
    lazy var searchTitleView: qusesearchView = {
        let searchTitleView = qusesearchView(frame: CGRect(x: 0, y: 0, width: 260 * width_height_ratio, height: 25))
        
        // 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchNews))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        searchTitleView.addGestureRecognizer(tap)
        
        return searchTitleView
    }()
    
    
    func searchNews() {
        self.navigationController?.pushViewController(MyAqSearchViewController(), animated: true)
    }
}

extension MyAnswerViewController: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "onePicCell", for: indexPath) as! AnswerQuesTableViewCell
        cell.delegate = self
        cell.infoModel = newsData[indexPath.row]
        return cell
    }
 
  
    // 选中单元格
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let newsDetail = TalkNewsDetailsViewController()
        newsDetail.newsTitle = newsData[indexPath.row].title
        newsDetail.newsId = newsData[indexPath.row].topicId
        newsDetail.commentNumber = newsData[indexPath.row].commentCount
        navigationController?.pushViewController(newsDetail, animated: true)
        
        
    }
    
}

extension MyAnswerViewController: AnswerQuesTableViewCellDelegate {
    func answerActionCell(_ answerQuesTableViewCell: AnswerQuesTableViewCell, infoModel model: MineTopicsModel) {
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        
        let vc = TalkNewsDetailsReplyViewController()
        vc.newsId = model.topicId
        vc.newsTitle = model.title
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ingoreActionCell(_ answerQuesTableViewCell: AnswerQuesTableViewCell, infoModel model: MineTopicsModel) {
        let btn = UIButton()
        btn.setTitle("忽略", for: .normal)
        btn.backgroundColor = UIColor.init(hexColor: "FB5959")
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 13
        btn.addTarget(self, action: #selector(ingoreAction), for: .touchUpInside)
        self.btn = btn
        self.topicID = model.topicId
        answerQuesTableViewCell.contentView.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 58, height: 26))
            make.right.equalTo(answerQuesTableViewCell.ingoreBton.left).offset(-50)
            make.centerY.equalTo(answerQuesTableViewCell.ingoreBton)
        }
        
        let bgView = UIScrollView.init(frame: UIScreen.main.bounds)
        self.bgView = bgView
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.2
        let tapBg = UITapGestureRecognizer.init(target: self, action: #selector(tapBgView(tapBgRecognizer:)))
        bgView.addGestureRecognizer(tapBg)
        
        UIApplication.shared.keyWindow?.addSubview(bgView)
    }
    
    func tapBgView(tapBgRecognizer:UITapGestureRecognizer)
    {
        
        let point = tapBgRecognizer.location(in: self.btn)
        
        if point.x >= 0 || point.y >= 0 {
            self.ingoreAction()
            return
        }
        
        UIView.animate(withDuration: 0.5, animations: {
           
        }) { (finished:Bool) in
            self.btn?.removeFromSuperview()
            self.bgView?.removeFromSuperview()
        }
    }
    
    func ingoreAction() {
        NetRequest.ingoreTopicNetRequest(id: self.topicID ?? "", type: "1", reson: "1", tag: "") { (success, info) in
            if success {
                
                var flag: Int = 0
                for model in self.newsData {
                    if model.topicId == self.topicID {
                        self.newsData.remove(at: flag)
                    }
                    flag = flag + 1
                    
                }

                UIView.animate(withDuration: 0.5, animations: {
                    
                }) { (finished:Bool) in
                    self.tableView.reloadData()
                    self.btn?.removeFromSuperview()
                    self.bgView?.removeFromSuperview()
                }
            }
        }
    }
    
    
}


