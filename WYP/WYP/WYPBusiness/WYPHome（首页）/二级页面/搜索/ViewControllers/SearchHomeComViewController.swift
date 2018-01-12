//
//  SearchHomeComViewController.swift
//  WYP
//
//  Created by Arthur on 2018/1/11.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchHomeComViewController: BaseViewController {
    
    // 数据源
    var newsData = [StatementFrameModel]()
    var newsDataAll = [StatementFrameModel]()
    // 关键字
    var keyword: String?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        layoutPageSubviews()
        
        loadSearchResult(requestType: .update)
    }
    
    // MARK: - private method
    private func viewConfig() {
        view.addSubview(newsTableView)
    }
    private func layoutPageSubviews() {
        newsTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 108, 0))
        }
    }
    
    // 获取搜索结果
    func loadSearchResult(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.homeSearchMoreCommNetRquest(page: "\(pageNumber)", keyword: keyword ?? "") { (success, info, result) in
            if success {

                var models = [StatementFrameModel]()
                for optDic in result! {
                    let statement = StatementModel(contentDic: optDic as! [AnyHashable : Any])
                    let statementFrame = StatementFrameModel()
                    let statementFrameAll = StatementFrameModel()
                    statementFrame.isSeachResult = true
                    statementFrame.statement = statement
                    statementFrameAll.statement = statement
                    
                    models.append(statementFrame)
                    
                    self.newsDataAll.append(statementFrameAll)
                    self.newsData.append(statementFrame)
                }
                
                if requestType == .update {
                    self.newsData = models
                } else {
                    // 把新数据添加进去
                    self.newsData = self.newsData + models
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
                
                self.newsTableView.reloadData()
                self.newsTableView.mj_header.endRefreshing()
                self.newsTableView.mj_footer.endRefreshing()
            } else {
                self.newsTableView.reloadData()
                self.newsTableView.mj_header.endRefreshing()
                self.newsTableView.mj_footer.endRefreshing()
            }
 
            
        }
    }
    
    // MARK: - event response
    // 自定义属性
    func changeTextColor(text: String) -> NSMutableAttributedString{
        let nsText = text as NSString
        
        let attributedString = NSMutableAttributedString(string: text)
        
        var changeText = [String]()
        
        for i in 0..<(keyword! as NSString).length {
            let string = (keyword! as NSString).substring(with: NSMakeRange(i, 1))
            changeText.append(string)
        }
        
        
        
        for i in 0..<nsText.length {
            let textRange = NSMakeRange(i, 1)
            for char in changeText {
                
                nsText.enumerateSubstrings(in: textRange, options: .byLines, using: {
                    (substring, substringRange, _, _) in
                    
                    if (substring == char) {
                        
                        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: substringRange)
                    }
                })
            }
        }
        return attributedString
    }
    
    // MARK: - setter and getter
    lazy var newsTableView: WYPTableView = {
        let newsTableView = WYPTableView(frame: .zero, style: .plain)
        newsTableView.estimatedRowHeight = 100
        newsTableView.rowHeight = UITableViewAutomaticDimension
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.tableFooterView = UIView()
        newsTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadSearchResult(requestType: .loadMore)
        })
        newsTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadSearchResult(requestType: .update)
        })
        
        newsTableView.register(StatementCell.self, forCellReuseIdentifier: "StatementCellIdentifier")
        return newsTableView
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
        label.text = "内容已飞外太空"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
    
}

extension SearchHomeComViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
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
        let cell = StatementCell(style: .default, reuseIdentifier: "StatementCellIdentifier")
        let attributeString = changeTextColor(text: cell.messageLabel.text ?? "")
        cell.messageLabel.attributedText = attributeString
        cell.statementFrame = newsData[indexPath.row]
        cell.selectionStyle = .none;
        cell.selectImgBlock = {(index, imageUrlArray) in
           return
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let statementFrame = newsData[indexPath.row]
        return statementFrame.cellHeight
    }
    
    // 选中单元格
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let moreCommenityVC = MoreCommunityViewController()
        
        let statement = self.newsDataAll[indexPath.row]
        
        moreCommenityVC.statementFrame = statement
        
        navigationController?.pushViewController(moreCommenityVC, animated: true)
       
    }
}
