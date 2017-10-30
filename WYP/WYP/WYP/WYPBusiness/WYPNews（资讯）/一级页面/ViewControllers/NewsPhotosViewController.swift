//
//  NewsPhotosViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/14.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class NewsPhotosViewController: BaseViewController {

    // 图集数据
    var newsData = [InfoModel]()
    // 一级页面二级页面的标记
    var flag: Int = 1
    // 搜索关键字
    var keyword: String?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfig()
        layoutPageSubviews()
    
        // 获取数据
        loadNewsData(requestType: .update)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        KRefreshDataCount().label.isHidden = true
    }
    
    // MARK: - private method
    func viewConfig() {
        view.addSubview(photosTableView)
    }
    func layoutPageSubviews() {
        if flag == 2 {
            photosTableView.snp.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 108, right: 0))
            }
        } else {
            photosTableView.snp.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 157, right: 0))
            }
        }
    }
    func loadNewsData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        if flag == 2 {  // 搜索数据
            NetRequest.newsSearchNetRequest(title: keyword ?? "", categoryId: "3", page: "\(pageNumber)") { (success, info, result) in
                if success {
                    let array = result!.value(forKey: "data")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    if requestType == .update {
                        self.newsData = [InfoModel].deserialize(from: jsonString) as! [InfoModel]
                    } else {
                        // 把新数据添加进去
                        let news = [InfoModel].deserialize(from: jsonString) as! [InfoModel]
                        self.newsData = self.newsData + news
                    }
                    // 先移除再添加
                    self.noDataLabel.text = "内容已飞外太空"
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
                    self.photosTableView.reloadData()
                    self.photosTableView.mj_header.endRefreshing()
                    self.photosTableView.mj_footer.endRefreshing()
                } else {
                    self.photosTableView.mj_header.endRefreshing()
                    self.photosTableView.mj_footer.endRefreshing()
                }
            }
        } else {
            NetRequest.newsNetRequest(page: "\(pageNumber)",  type_id: "3", uid: AppInfo.shared.user?.userId ?? "", userId: AppInfo.shared.user?.userId ?? "") { (success, info, result) in
                if success {
                    
                    let array = result!.value(forKey: "ziXun")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    if requestType == .update {
                        self.newsData = [InfoModel].deserialize(from: jsonString) as! [InfoModel]
                        
                        KRefreshDataCount().showNewDataCountAlert(count: self.newsData.count, alertFrame: CGRect(x: 0, y: -30, width: kScreen_width, height: 30), view: self.view)
                    } else {
                        // 把新数据添加进去
                        let newsArray = [InfoModel].deserialize(from: jsonString) as! [InfoModel]
                        self.newsData = self.newsData + newsArray
                    }
                    
                    // 先移除再添加
                    self.noDataImageView.removeFromSuperview()
                    self.noDataLabel.removeFromSuperview()
                    // 没有数据的时候
                    self.view.addSubview(self.noDataImageView)
                    self.view.addSubview(self.noDataLabel)
                    self.noDataImageView.snp.makeConstraints { (make) in
                        if deviceTypeIphone5() || deviceTypeIPhone4() {
                            make.top.equalTo(self.view).offset(150)
                        }
                        make.top.equalTo(self.view).offset(200)
                        make.centerX.equalTo(self.view)
                        make.size.equalTo(CGSize(width: 100, height: 147))
                    }
                    self.noDataLabel.snp.makeConstraints { (make) in
                        make.top.equalTo(self.noDataImageView.snp.bottom).offset(10)
                        make.centerX.equalTo(self.view)
                        make.height.equalTo(11)
                    }
                    
                    self.photosTableView.mj_header.endRefreshing()
                    self.photosTableView.mj_footer.endRefreshing()
                    self.photosTableView.reloadData()
                } else {
                    self.photosTableView.mj_header.endRefreshing()
                    self.photosTableView.mj_footer.endRefreshing()
                }
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
        
        print(changeText)
        
        for i in 0..<nsText.length {
            let textRange = NSMakeRange(i, 1)
            for char in changeText {
                
                nsText.enumerateSubstrings(in: textRange, options: .byLines, using: {
                    (substring, substringRange, _, _) in
                    print("\(char)\(i)\(String(describing: substring))")
                    if (substring == char) {
                        print("执行了")
                        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: substringRange)
                    }
                })
            }
        }
        return attributedString
    }
    
    // MARK: - setter and getter
    lazy var photosTableView: WYPTableView = {
        let photosTableView = WYPTableView()
        photosTableView.backgroundColor = UIColor.white
        photosTableView.rowHeight = 280 * width_height_ratio
        photosTableView.delegate = self
        photosTableView.dataSource = self
        photosTableView.tableFooterView = UIView()
        photosTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadNewsData(requestType: .loadMore)
        })
        photosTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadNewsData(requestType: .update)
        })
        photosTableView.register(VideoInfoTableViewCell.self, forCellReuseIdentifier: "photosCell")
        return photosTableView
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

extension NewsPhotosViewController: UITableViewDelegate,UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "photosCell", for: indexPath) as! VideoInfoTableViewCell
        cell.infoModel = newsData[indexPath.row]
        // 判断是不是搜索页面
        if flag == 2 {
            let attributeString = changeTextColor(text: cell.infoTitleLabel.text ?? "")
            cell.infoTitleLabel.attributedText = attributeString
        }
        cell.playImageView.isHidden = true
        cell.infoLabel.text = String.init(format: "%d图", newsData[indexPath.row].infoImageArr?.count ?? 0)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photos = NewsPhotosDetailViewController()
        photos.newsId = newsData[indexPath.row].newsId
        photos.newsTitle = newsData[indexPath.row].infoTitle
        photos.isFollow = newsData[indexPath.row].isFollow
        photos.imageArray = newsData[indexPath.row].infoImageArr
        photos.contentArray = newsData[indexPath.row].contentArray
        photos.commentNumber = newsData[indexPath.row].infoComment
        photos.currentIndex = 0
        self.navigationController?.pushViewController(photos, animated: false)
    }
}
