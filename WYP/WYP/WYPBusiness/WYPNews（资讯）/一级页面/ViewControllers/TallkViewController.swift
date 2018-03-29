//
//  TallkViewController.swift
//  WYP
//
//  Created by 曾雪峰 on 2017/12/10.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class TallkViewController: BaseViewController {
    // 是否显示banner
    var isShowBanner: Bool = false
    
    var dataList = [TopicsFrameModel]()
    
    var dataSource = [IntelligentModel]()
    
    // 数据源
    var newsData = [InfoModel]()
    // 广告数据
    var advData: [InfoModel]?
    // 资讯类型
    var newsType: String?
    // 一级页面二级页面的标记
    var flag: Int = 1
    // 搜索关键字
    var keyword: String?
    
    //刷新次数
    var upnumb: Int = 0
    

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutPageSubviews()
        
        // 获取数据
        loadNewsData(requestType: .update)
        
        //获得达人榜
        loadIntelligentData()
        
        
        
    
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        KRefreshDataCount().label.isHidden = true
    }
    
    

    private func layoutPageSubviews() {
        
        view.addSubview(newAllTableView)
        switch flag {
        case 1:
            newAllTableView.snp.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 157, 0))
            }
            break
        case 2:   // 资讯搜索结果
            newAllTableView.snp.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 108, 0))
            }
            break
        default:
            break
        }
    }
    

    //MARK: 请求达人榜
    func loadIntelligentData() {
        NetRequest.getIntelligentListNetRequest(page: "1",new_id: "") { (success, info, result) in
            if success {
                for dic in result! {
                    let model = IntelligentModel.deserialize(from: dic)
                    self.dataSource.append(model!)
                }
                self.newAllTableView.reloadData()
            }
        }
    }
    
    func loadNewsData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        
        if flag == 2 {  // 资讯搜索
            NetRequest.newsSearchNetRequest(title: keyword ?? "", categoryId: newsType ?? "", page: "\(pageNumber)") { (success, info, result) in
                if success {
                    let array = result!.value(forKey: "data")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    if requestType == .update {
                        self.newsData = [InfoModel].deserialize(from: jsonString)! as! [InfoModel]
                    } else {
                        // 把新数据添加进去
                        let news = [InfoModel].deserialize(from: jsonString) as! [InfoModel]
                        self.newsData = self.newsData + news
                    }
                    self.newAllTableView.reloadData()
                    self.newAllTableView.mj_header.endRefreshing()
                    self.newAllTableView.mj_footer.endRefreshing()
                    
                    // 先移除再添加
                    self.noDataImageView.removeFromSuperview()
                    self.noDataLabel.removeFromSuperview()
                    
                    // 没有数据的情况
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
                    
                } else {
                    self.newAllTableView.mj_header.endRefreshing()
                    self.newAllTableView.mj_footer.endRefreshing()
                }
            }
        } else {
            NetRequest.newsNetRequest(page: "\(pageNumber)", type_id: newsType ?? "", uid: AppInfo.shared.user?.userId ?? "", userId: AppInfo.shared.user?.userId ?? "", upParams: upnumb) { (success, info, result) in
                if success {
                    self.upnumb = self.upnumb + 1
                    var news = [InfoModel]()
                    // 资讯
                    let array = result?.value(forKey: "ziXun")
                    if array != nil {
                        let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                        let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                        news = [InfoModel].deserialize(from: jsonString)! as! [InfoModel]
                    }
                    
                    if requestType == .update {
                        
                        // 广告
                        let array1 = result!.value(forKey: "adv")
                        if array1 != nil {
                            let data1 = try! JSONSerialization.data(withJSONObject: array1!, options: JSONSerialization.WritingOptions.prettyPrinted)
                            let jsonString1 = NSString(data: data1, encoding: String.Encoding.utf8.rawValue)! as String
                            self.advData = [InfoModel].deserialize(from: jsonString1) as? [InfoModel]
                            
                            // 资讯列表数据
                            if self.advData != nil {
                                if news.count >= 5 {
                                    for i in 0..<5 {
                                        self.newsData.append(news[i])
                                    }
                                }
                                // 插入广告
                                if (self.advData?.count)! >= 1 {
                                    self.newsData.append(self.advData![0])
                                }
                                
                                if news.count >= 10 {
                                    for i in 5..<10 {
                                        self.newsData.append(news[i])
                                    }
                                }
                                // 插入广告
                                if (self.advData?.count)! >= 2 {
                                    self.newsData.append(self.advData![1])
                                }
                            }
                        } else {
                            self.newsData = news
                        }
                        
                        KRefreshDataCount().showNewDataCountAlert(count: news.count, alertFrame: CGRect(x: 0, y: -30, width: kScreen_width, height: 30), view: self.view)
                    } else {
                        
                        // 把新数据添加进去
                        self.newsData = self.newsData + news
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
                    
                    self.newAllTableView.mj_header.endRefreshing()
                    self.newAllTableView.mj_footer.endRefreshing()
                    self.newAllTableView.reloadData()
                } else {
                    self.newAllTableView.mj_header.endRefreshing()
                    self.newAllTableView.mj_footer.endRefreshing()
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

        for i in 0..<nsText.length {
            let textRange = NSMakeRange(i, 1)
            for char in changeText {
                
                nsText.enumerateSubstrings(in: textRange, options: .byLines, using: {
                    (substring, substringRange, _, _) in
                    print("\(char)\(i)\(String(describing: substring))")
                    if (substring == char) {
                     
                        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: substringRange)
                    }
                })
            }
        }
        return attributedString
    }

    // MARK: - setter and getter
    lazy var newAllTableView: WYPTableView = {
        let newAllTableView = WYPTableView(frame: .zero, style: .grouped)
        newAllTableView.backgroundColor = UIColor.init(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
        newAllTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        newAllTableView.separatorColor = UIColor.init(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
        newAllTableView.delegate = self
        newAllTableView.dataSource = self
        

        // 刷新
        newAllTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadNewsData(requestType: .loadMore)
        })
        newAllTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadNewsData(requestType: .update)
        })
        newAllTableView.register(TalkOnePictureTableViewCell.self, forCellReuseIdentifier: "onePicCell")
        newAllTableView.register(TalkTravelTableViewCell.self, forCellReuseIdentifier: "textCell")
        newAllTableView.register(TalkThreePictureTableViewCell.self, forCellReuseIdentifier: "threeCell")
        newAllTableView.register(TalkVideoInfoTableViewCell.self, forCellReuseIdentifier: "videoCell")
        newAllTableView.register(IntelligentTableViewCell.self, forCellReuseIdentifier: "inteCell")
        return newAllTableView
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

extension TallkViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return newsData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newsData.count == 0 {
            noDataLabel.isHidden = false
            noDataImageView.isHidden = false
        } else {
            noDataLabel.isHidden = true
            noDataImageView.isHidden = true
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "inteCell", for: indexPath) as! IntelligentTableViewCell
            cell.intelligentModel = self.dataSource
            return cell
        }else {
            switch newsData[indexPath.section].showType ?? 6 {
            case 0: // 视频
                let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! TalkVideoInfoTableViewCell
                cell.infoModel = newsData[indexPath.section]
                // 判断是不是搜索页面
                if flag == 2 {
                    let attributeString = changeTextColor(text: cell.infoTitleLabel.text ?? "")
                    cell.infoTitleLabel.attributedText = attributeString
                }
                return cell
            case 1: //只有文字
                let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! TalkTravelTableViewCell
                cell.infoModel = newsData[indexPath.section]
                // 判断是不是搜索页面
                if flag == 2 {
                    let attributeString = changeTextColor(text: cell.travelTitleLabel.text ?? "")
                    cell.travelTitleLabel.attributedText = attributeString
                }
                return cell
            case 2: //上图下文
                let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! TalkVideoInfoTableViewCell
                cell.infoModel = newsData[indexPath.section]
                // 判断是不是搜索页面
                if flag == 2 {
                    let attributeString = changeTextColor(text: cell.infoTitleLabel.text ?? "")
                    cell.infoTitleLabel.attributedText = attributeString
                }
                return cell
            case 3: //左文右图
                let cell = tableView.dequeueReusableCell(withIdentifier: "onePicCell", for: indexPath) as! TalkOnePictureTableViewCell
                cell.infoModel = newsData[indexPath.section]
                // 判断是不是搜索页面
                if flag == 2 {
                    let attributeString = changeTextColor(text: cell.infoLabel.text ?? "")
                    cell.infoLabel.attributedText = attributeString
                }
                return cell
            case 4: //三张图
                let cell = tableView.dequeueReusableCell(withIdentifier: "threeCell", for: indexPath) as! TalkThreePictureTableViewCell
                cell.infoModel = newsData[indexPath.section]
                // 判断是不是搜索页面
                if flag == 2 {
                    let attributeString = changeTextColor(text: cell.infoLabel.text ?? "")
                    cell.infoLabel.attributedText = attributeString
                }
                return cell
            case 5: // 大图
                let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! TalkVideoInfoTableViewCell
                cell.infoLabel.isHidden = true
                cell.playImageView.isHidden = true
                cell.infoModel = newsData[indexPath.section]
                // 判断是不是搜索页面
                if flag == 2 {
                    let attributeString = changeTextColor(text: cell.infoTitleLabel.text ?? "")
                    cell.infoTitleLabel.attributedText = attributeString
                }
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 2 {
            return 190
        }else {
            
            switch newsData[indexPath.section].showType ?? 6 { //2大图  4三图  3左文右图  1文字
                
            case 0:
                
                let titleH = self.getLabHeight(labelStr: newsData[indexPath.section].infoTitle!, font: UIFont.systemFont(ofSize: 16), width: kScreen_width - 26)
                if titleH > 20 {   //两行
                    return 310 * width_height_ratio
                }
                return 275 * width_height_ratio
            case 1:  //只有文字
                let titleH = self.getLabHeight(labelStr: newsData[indexPath.section].infoTitle!, font: UIFont.systemFont(ofSize: 16), width: kScreen_width - 26)
                if titleH > 20 {
                    return 87.5 * width_height_ratio
                }
                return 74 * width_height_ratio
            case 2:  //大图下文
                let titleH = self.getLabHeight(labelStr: newsData[indexPath.section].infoTitle!, font: UIFont.systemFont(ofSize: 16), width: kScreen_width - 26)
                if titleH > 20 {   //两行
                    return 295 * width_height_ratio
                }
                return 275 * width_height_ratio
            case 3:    //左文右图
                return 100
            case 4:  //三图
                
                let titleH = self.getLabHeight(labelStr: newsData[indexPath.section].infoTitle!, font: UIFont.systemFont(ofSize: 16), width: kScreen_width - 26)
                if titleH > 20 {
                    return 180 * width_height_ratio
                }
                
                return 160 * width_height_ratio
            case 5:
                
                return 275 * width_height_ratio
            default:
                return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0.0001
        }
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 30
        }else if section == 0 {
            return 144
        }
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = Bundle.main.loadNibNamed("TalkHeadView", owner: self, options: nil)?.first as! TalkHeadView
            let answerButton = view.viewWithTag(99) as! UIButton
//            let headImage = view.viewWithTag(96) as! UIImageView
            
            answerButton.addTarget(self, action: #selector(myaqAction), for: .touchUpInside)
            return view
        }
        if section == 2 {
            let view = Bundle.main.loadNibNamed("TableHeaderView", owner: nil, options: nil)?.first as! TableHeaderView
            let moreButton = view.viewWithTag(99) as! UIButton
            moreButton.addTarget(self, action: #selector(moreGotTelent), for: .touchUpInside)
            return view
        }
        return UIView()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if newsData[indexPath.section].infoType == 4 { // 图集
            let newsDetail = NewsPhotosDetailViewController()
            newsDetail.currentIndex = 0
            newsDetail.isFollow = newsData[indexPath.row].isFollow
            newsDetail.imageArray = newsData[indexPath.row].infoImageArr
            newsDetail.contentArray = newsData[indexPath.row].contentArray
            newsDetail.newsId = newsData[indexPath.row].newsId ?? ""
            newsDetail.newsTitle = newsData[indexPath.row].infoTitle
            newsDetail.commentNumber = newsData[indexPath.row].infoComment
            navigationController?.pushViewController(newsDetail, animated: true)
            
        } else if newsData[indexPath.section].infoType == 2 { // 视频
            let newsDetail = VideoDetailViewController()
            newsDetail.newsId = newsData[indexPath.row].newsId ?? ""
            newsDetail.newsTitle = newsData[indexPath.row].infoTitle
            navigationController?.pushViewController(newsDetail, animated: true)
            
        } else { // web
            if self.advData != nil {
                if self.advData?.count == 1 && indexPath.row == 5 {
                    let adv = AdvViewController()
                    adv.advLink = self.advData?[0].advLink
                    adv.newsTitle = self.advData?[0].infoTitle
                    navigationController?.pushViewController(adv, animated: true)
                } else if self.advData?.count == 2 && indexPath.row == 5 {
                    let adv = AdvViewController()
                    adv.advLink = self.advData?[0].advLink
                    adv.newsTitle = self.advData?[0].infoTitle
                    navigationController?.pushViewController(adv, animated: true)
                } else if self.advData?.count == 2 && indexPath.row == 11 {
                    let adv = AdvViewController()
                    adv.advLink = self.advData?[1].advLink
                    adv.newsTitle = self.advData?[1].infoTitle
                    navigationController?.pushViewController(adv, animated: true)
                } else {
                    let newsDetail = NewsDetailsViewController()
                    newsDetail.newsTitle = newsData[indexPath.row].infoTitle
                    newsDetail.newsId = newsData[indexPath.row].newsId
                    newsDetail.commentNumber = newsData[indexPath.row].infoComment
                    navigationController?.pushViewController(newsDetail, animated: true)
                }
            } else {
                let newsDetail = TalkNewsDetailsViewController()
                newsDetail.newsTitle = newsData[indexPath.section].infoTitle
                newsDetail.newsId = newsData[indexPath.section].newsId
                newsDetail.commentNumber = newsData[indexPath.section].infoComment
                navigationController?.pushViewController(newsDetail, animated: true)
            }
        }
    }
    
    func getLabHeight(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width: width, height: 1000)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize.height
    }
    
    //MARK: //更多达人
    func moreGotTelent() {
        navigationController?.pushViewController(MoreIntelligentViewController(), animated: true)
    }
    
    //MARK: 我的问答
    func myaqAction() {
        navigationController?.pushViewController(MyAnswerQViewController(), animated: true)
    }
    
}

extension TallkViewController: SYBannerViewDelegate {

    
    
}


extension TallkViewController: TopicsDetailsViewControllerDelegate {
    
    func starBtnAction(topicId: String, topicsFrame: TopicsFrameModel) {
        for i in 0..<dataList.count {
            let frameModel = dataList[i]
            if frameModel.topics.topicId == topicId {
                dataList[i] = topicsFrame
//                tableView.reloadData()
            }
        }
    }
}


