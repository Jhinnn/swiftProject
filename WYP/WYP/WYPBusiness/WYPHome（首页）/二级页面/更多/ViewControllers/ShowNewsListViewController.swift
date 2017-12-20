//
//  ShowNewsListViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/5.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ShowNewsListViewController: BaseViewController {
    
    // 数据源
    var newsData: [InfoModel]?
    // 展厅Id
    var roomId: String?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        layoutPageSubviews()
        
        // 获取数据
        loadRoomNewsData(requestType: .update)
        
    }
    
    // MARK: - private method
    private func viewConfig() {
        title = "最新动态"
        view.addSubview(newsTableView)
    }
    private func layoutPageSubviews() {
        newsTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    private func loadRoomNewsData(requestType: RequestType) {
        
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        
        NetRequest.roomDetailNewsNetRequest(page: "\(pageNumber)", id: roomId ?? "") { (success, info, result) in
            if success {
                
                let array = result!.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                if requestType == .update {
                    self.newsData = [InfoModel].deserialize(from: jsonString) as? [InfoModel]
                } else {
                    // 把新数据添加进去
                    let newsArray = [InfoModel].deserialize(from: jsonString) as! [InfoModel]
                    
                    self.newsData = self.newsData! + newsArray
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
    lazy var newsTableView: WYPTableView = {
        let newsTableView = WYPTableView(frame: .zero, style: .plain)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.register(OnePictureTableViewCell.self, forCellReuseIdentifier: "onePicCell")
        newsTableView.register(TravelTableViewCell.self, forCellReuseIdentifier: "textCell")
        newsTableView.register(ThreePictureTableViewCell.self, forCellReuseIdentifier: "threeCell")
        newsTableView.register(VideoInfoTableViewCell.self, forCellReuseIdentifier: "videoCell")
        newsTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadRoomNewsData(requestType: .loadMore)
        })
        newsTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadRoomNewsData(requestType: .update)
        })
        newsTableView.tableFooterView = UIView()
        return newsTableView
    }()
    
    // 没有数据时的图片
    lazy var noDataImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "common_noData_icon_normal_iPhone")
        return imageView
    }()
    // 没有找到结果
    lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "暂无最新动态"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
}
    
extension ShowNewsListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newsData?.count == 0 {
            noDataLabel.isHidden = false
            noDataImageView.isHidden = false
        } else {
            noDataLabel.isHidden = true
            noDataImageView.isHidden = true
        }
        return newsData?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch newsData![indexPath.row].showType! {
        case 0: // 视频
            let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoInfoTableViewCell
            
            cell.infoModel = newsData?[indexPath.row]
            return cell
        case 1: //只有文字
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! TravelTableViewCell
            cell.infoModel = newsData?[indexPath.row]
            return cell
        case 2: //上图下文
            let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoInfoTableViewCell
            cell.infoModel = newsData?[indexPath.row]
            return cell
        case 3: //左文右图
            let cell = tableView.dequeueReusableCell(withIdentifier: "onePicCell", for: indexPath) as! OnePictureTableViewCell
            cell.infoModel = newsData?[indexPath.row]
            return cell
        case 4: //三张图
            let cell = tableView.dequeueReusableCell(withIdentifier: "threeCell", for: indexPath) as! ThreePictureTableViewCell
            cell.infoModel = newsData?[indexPath.row]
            return cell
        case 5: // 大图
            let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoInfoTableViewCell
            cell.infoLabel.isHidden = true
            cell.playImageView.isHidden = true
            cell.infoModel = newsData?[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch newsData![indexPath.row].showType! {
        case 0:
            return 280 * width_height_ratio
        case 1:
            return 87.5 * width_height_ratio
        case 2:
            return 280 * width_height_ratio
        case 3:
            return 115 * width_height_ratio
        case 4:
            return 160 * width_height_ratio
        case 5:
            return 280 * width_height_ratio
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if newsData![indexPath.row].infoType! == 4 { // 图集
            let newsDetail = NewsPhotosDetailViewController()
            newsDetail.currentIndex = 0
            newsDetail.isFollow = newsData?[indexPath.row].isFollow
            newsDetail.imageArray = newsData?[indexPath.row].infoImageArr
            newsDetail.contentArray = newsData?[indexPath.row].contentArray
            newsDetail.newsId = newsData?[indexPath.row].newsId ?? ""
            newsDetail.newsTitle = newsData?[indexPath.row].infoTitle
            newsDetail.commentNumber = newsData?[indexPath.row].infoComment
            navigationController?.pushViewController(newsDetail, animated: true)
            
        } else if newsData![indexPath.row].infoType! == 2 { // 视频
            let newsDetail = VideoDetailViewController()
            newsDetail.newsId = newsData?[indexPath.row].newsId ?? ""
            newsDetail.newsTitle = newsData?[indexPath.row].infoTitle
            navigationController?.pushViewController(newsDetail, animated: true)
            
        } else { // web
            let newsDetail = RoomNewsDetailViewController()
            newsDetail.newsPhoto = newsData?[indexPath.row].infoImageArr?[0]
            newsDetail.newsTitle = newsData?[indexPath.row].infoTitle
            newsDetail.newsId = newsData?[indexPath.row].newsId
            newsDetail.commentNumber = newsData?[indexPath.row].infoComment
            navigationController?.pushViewController(newsDetail, animated: true)
        }
    }

}
