//
//  MyAqSearchViewController.swift
//  WYP
//
//  Created by aLaDing on 2018/4/2.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class MyAqSearchViewController: UIViewController {
    
    // 数据源
    var newsData = [SearchGambitModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        self.navigationItem.titleView = searchTitleView
        
        viewConfig()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.init(hexColor: "3994C1")
    }
    
    func viewConfig() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        let leftBarBtn = UIBarButtonItem.init(title: "取消", style: .done, target: self, action: #selector(backAction))
        self.navigationItem.rightBarButtonItem = leftBarBtn
    }

    // 导航栏上的view
    lazy var searchTitleView: quseesearchView = {
        let searchTitleView = quseesearchView(frame: CGRect(x: 0, y: 0, width: 240 * width_height_ratio, height: 25))
        searchTitleView.searchView.searchLabel.delegate = self
        return searchTitleView
    }()
    
    lazy var tableView: UITableView = {
        let newsTableView = WYPTableView()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.isHidden = true
        newsTableView.tableFooterView = UIView()
        newsTableView.estimatedRowHeight = 500
        newsTableView.rowHeight = UITableViewAutomaticDimension
        newsTableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        newsTableView.register(UINib.init(nibName: "GambitSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "onePicCell")
        return newsTableView
    }()
    
    
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    func searchNews() {
        self.navigationController?.pushViewController(MyAqSearchViewController(), animated: true)
    }

    
    func loadData(keyWord: String) {
        NetRequest.qusetionSearchListNetRequest(keyword: keyWord) { (success, info, dataArr) in
            if success {
                var news = [SearchGambitModel]()
                
                if dataArr?.count != 0 {
                    let data = try! JSONSerialization.data(withJSONObject: dataArr!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    news = [SearchGambitModel].deserialize(from: jsonString)! as! [SearchGambitModel]
                }
                self.newsData = news
                
                
                
                self.tableView.reloadData()
            }
         }
    }
    
   
}

extension MyAqSearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        if currentText != "" {
            self.tableView.isHidden = false
            self.loadData(keyWord: currentText)
        }else {
            self.tableView.isHidden = true
        }
        return true
    }
}
extension MyAqSearchViewController: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "onePicCell", for: indexPath) as! GambitSearchTableViewCell
        cell.infoModel = newsData[indexPath.row]
        return cell
    }
    
    
    // 选中单元格
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let newsDetail = TalkNewsDetailsViewController()
        newsDetail.newsTitle = newsData[indexPath.row].title
        newsDetail.newsId = newsData[indexPath.row].id
//        newsDetail.commentNumber = newsData[indexPath.row].commentCount
        navigationController?.pushViewController(newsDetail, animated: true)
        
        
    }
    
}
