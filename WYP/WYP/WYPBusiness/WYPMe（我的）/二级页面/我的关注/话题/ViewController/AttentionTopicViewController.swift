//
//  AttentionNewsViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class AttentionTopicViewController: BaseViewController {
    
    // 数据源
    var newsData = [InfoModel]()
    
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
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 108, 0))
        }
    }
    
    // 获取搜索结果
    private func loadSearchResult(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.attentionTopicNetRequest(page: "\(pageNumber)", openId: AppInfo.shared.user?.token ?? "") { (success, info, result) in
            if success {
                
                let array = result!.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                if requestType == .update {
                    self.newsData = ([InfoModel].deserialize(from: jsonString) as? [InfoModel])!
                } else {
                    // 把新数据添加进去
                    let newsArray = [InfoModel].deserialize(from: jsonString) as? [InfoModel]
                    self.newsData = self.newsData + newsArray!
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
                
                self.newsTableView.mj_header.endRefreshing()
                self.newsTableView.mj_footer.endRefreshing()
                self.newsTableView.reloadData()
            } else {
                
                self.newsTableView.mj_header.endRefreshing()
                self.newsTableView.mj_footer.endRefreshing()
            }
        }
    }
    
    // MARK: - setter and getter
    lazy var newsTableView: UITableView = {
        let newsTableView = UITableView(frame: .zero, style: .plain)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.tableFooterView = UIView()
        newsTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadSearchResult(requestType: .loadMore)
        })
        newsTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadSearchResult(requestType: .update)
        })
        newsTableView.register(TalkOnePictureTableViewCell.self, forCellReuseIdentifier: "onePicCell")
        newsTableView.register(TalkTravelTableViewCell.self, forCellReuseIdentifier: "textCell")
        newsTableView.register(TalkThreePictureTableViewCell.self, forCellReuseIdentifier: "threeCell")
        newsTableView.register(TalkVideoInfoTableViewCell.self, forCellReuseIdentifier: "videoCell")
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
        label.text = "暂无关注的资讯"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
}

extension AttentionTopicViewController: UITableViewDelegate,UITableViewDataSource {

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
        switch newsData[indexPath.section].showType ?? 6 {
        case 0: // 视频
            let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! TalkVideoInfoTableViewCell
            
            cell.infoModel = newsData[indexPath.section]
            // 判断是不是搜索页面
//            if flag == 2 {
//                let attributeString = changeTextColor(text: cell.infoTitleLabel.text ?? "")
//                cell.infoTitleLabel.attributedText = attributeString
//            }
            return cell
        case 1: //只有文字
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! TalkTravelTableViewCell
            cell.infoModel = newsData[indexPath.section]
            // 判断是不是搜索页面
//            if flag == 2 {
//                let attributeString = changeTextColor(text: cell.travelTitleLabel.text ?? "")
//                cell.travelTitleLabel.attributedText = attributeString
//            }
//            return cell
        case 2: //上图下文
            let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! TalkVideoInfoTableViewCell
            cell.infoModel = newsData[indexPath.section]
            // 判断是不是搜索页面
//            if flag == 2 {
//                let attributeString = changeTextColor(text: cell.infoTitleLabel.text ?? "")
//                cell.infoTitleLabel.attributedText = attributeString
//            }
            return cell
        case 3: //左文右图
            let cell = tableView.dequeueReusableCell(withIdentifier: "onePicCell", for: indexPath) as! TalkOnePictureTableViewCell
            cell.infoModel = newsData[indexPath.section]
            // 判断是不是搜索页面
//            if flag == 2 {
//                let attributeString = changeTextColor(text: cell.infoLabel.text ?? "")
//                cell.infoLabel.attributedText = attributeString
//            }
            return cell
        case 4: //三张图
            let cell = tableView.dequeueReusableCell(withIdentifier: "threeCell", for: indexPath) as! TalkThreePictureTableViewCell
            cell.infoModel = newsData[indexPath.section]
            // 判断是不是搜索页面
//            if flag == 2 {
//                let attributeString = changeTextColor(text: cell.infoLabel.text ?? "")
//                cell.infoLabel.attributedText = attributeString
//            }
            return cell
        case 5: // 大图
            let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! TalkVideoInfoTableViewCell
            cell.infoLabel.isHidden = true
            cell.playImageView.isHidden = true
            cell.infoModel = newsData[indexPath.section]
            // 判断是不是搜索页面
//            if flag == 2 {
//                let attributeString = changeTextColor(text: cell.infoTitleLabel.text ?? "")
//                cell.infoTitleLabel.attributedText = attributeString
//            }
            return cell
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if newsData.count > 0 {
            print(newsData[indexPath.row].showType ?? "")
            switch newsData[indexPath.row].showType ?? 0 {
            case 0:
                return 280 * width_height_ratio
            case 1:
                return 87.5 * width_height_ratio
            case 2:
                return 280 * width_height_ratio
            case 3:
                return 109 * width_height_ratio
            case 4:
                return 160 * width_height_ratio
            case 5:
                return 280 * width_height_ratio
            default:
                return 0
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    // 选中单元格
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if newsData[indexPath.row].status == "0" {
            // 对已关闭资讯处理
            SYAlertController.showAlertController(view: self, title: "提示", message: "该数据已失效")
            
        } else if newsData[indexPath.row].status == "1" {
            let newsDetail = TalkNewsDetailsViewController()
            newsDetail.newsTitle = newsData[indexPath.section].infoTitle
            newsDetail.newsId = newsData[indexPath.section].newsId
            newsDetail.commentNumber = newsData[indexPath.section].infoComment
            navigationController?.pushViewController(newsDetail, animated: true)
        }
        
    }
    // 设置侧滑删除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    // 修改删除按钮的文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "取消关注"
    }
    // 删除cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            let newsId = newsData[indexPath.row].newsId ?? ""
//            newsData?.remove(at: indexPath.row)
            //1.从数据库将数据移除
            NetRequest.cancelAttentionNetRequest(openId: (AppInfo.shared.user?.token)!, newsId: newsId, complete: { (success, info) in
                if success {
                    self.newsData.remove(at: indexPath.row)
                    // 刷新单元格
                    tableView.reloadData()
                    SVProgressHUD.showSuccess(withStatus: info!)
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            })
        }
    }
}


