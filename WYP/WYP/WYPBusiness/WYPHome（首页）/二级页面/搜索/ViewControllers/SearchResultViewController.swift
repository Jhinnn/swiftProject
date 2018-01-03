//
//  SearchResultViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/7.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol SearchResultViewControllerDelegate: NSObjectProtocol {
    func showMoreNews(sender: UIButton)
}

class SearchResultViewController: BaseViewController {

    weak var delegate: SearchResultViewControllerDelegate?
    
    // 搜索关键字
    var keyword: String?
    // 搜索结果
    var homeSearch: HomeSearcModel?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfig()
        layoutPageSubviews()
        loadData()
        
        if #available(iOS 11, *) {
            print(resultTableView.safeAreaInsets)
            print(resultTableView.contentInset)
            print(resultTableView.adjustedContentInset)
        }
    }
    
    // MARK: - private method
    private func viewConfig() {
        view.addSubview(resultTableView)
    }
    private func layoutPageSubviews() {
        resultTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 108, 0))
        }
    }
    
    func loadData() {
        let longitude = String.init(format: "%lf", LocationManager.shared.longitude ?? 0)
        let latitude = String.init(format: "%lf", LocationManager.shared.latitude ?? 0)
        NetRequest.homeSearchNetRequest(keyword: keyword ?? "", longitude: longitude, latitude: latitude) { (success, info, result) in
            if success {
                self.homeSearch = HomeSearcModel.deserialize(from: result)
                
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
                self.resultTableView.reloadData()
            } else {
                print(info!)
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
    
    // MARK: - event response
    func clickMoreButton(sender: UIButton) {
        delegate?.showMoreNews(sender: sender)
    }

    // MARK: - setter and getter
    lazy var resultTableView: WYPTableView = {
        let resultTableView = WYPTableView(frame: .zero, style: .grouped)
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.register(ScrambleForTicketCell.self, forCellReuseIdentifier: "searchTicketCell")
        resultTableView.register(ThreePictureTableViewCell.self, forCellReuseIdentifier: "searchThreeCell")
        resultTableView.register(OnePictureTableViewCell.self, forCellReuseIdentifier: "searchOneCell")
        resultTableView.register(VideoInfoTableViewCell.self, forCellReuseIdentifier: "searchVideoCell")
        resultTableView.register(TravelTableViewCell.self, forCellReuseIdentifier: "searchTextCell")
        resultTableView.register(ShowroomCell.self, forCellReuseIdentifier: "searchShowRoomCell")
        if #available(iOS 11.0, *) {
//            resultTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            self.automaticallyAdjustsScrollViewInsets = true
        } else {
            // Fallback on earlier version
        }
        return resultTableView
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


extension SearchResultViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var tag = 0
        if homeSearch?.news != nil {
            tag = tag + 1
        }
        if homeSearch?.rooms != nil {
            tag = tag + 1
        }
        if homeSearch?.tickets != nil {
            tag = tag + 1
        }
        print(tag)
        return tag
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 没有搜索结果
        if homeSearch?.tickets?.count == 0 && homeSearch?.news?.count == 0 && homeSearch?.rooms?.count == 0 {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
        }
        // 有搜索结果
        switch section {
        case 0:
            if homeSearch?.tickets != nil {
                return homeSearch?.tickets?.count ?? 0
            } else {
                return 0
            }
        case 1:
            if homeSearch?.news != nil {
                return homeSearch?.news?.count ?? 0
            } else {
                return 0
            }
        case 2:
            if homeSearch?.rooms != nil {
                return homeSearch?.rooms?.count ?? 0
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchTicketCell", for: indexPath) as! ScrambleForTicketCell
            cell.ticketModel = homeSearch?.tickets?[indexPath.row]
            // 关键字标红
            let attributeString = changeTextColor(text: cell.ticketTitleLabel.text ?? "")
            cell.ticketTitleLabel.attributedText = attributeString
            return cell
            
        case 1:
            if homeSearch?.news != nil {
            
                switch homeSearch!.news![indexPath.row].showType! {
                case 0: // 视频
                    let cell = tableView.dequeueReusableCell(withIdentifier: "searchVideoCell", for: indexPath) as! VideoInfoTableViewCell
                    cell.infoModel = homeSearch?.news?[indexPath.row]
                    // 关键字标红
                    let attributeString = changeTextColor(text: cell.infoTitleLabel.text ?? "")
                    cell.infoTitleLabel.attributedText = attributeString
                    return cell
                    
                case 1: //只有文字
                    let cell = tableView.dequeueReusableCell(withIdentifier: "searchTextCell", for: indexPath) as! TravelTableViewCell
                    cell.infoModel = homeSearch?.news?[indexPath.row]
                    // 关键字标红
                    let attributeString = changeTextColor(text: cell.travelTitleLabel.text ?? "")
                    cell.travelTitleLabel.attributedText = attributeString
                    return cell
                    
                case 2: //上图下文
                    let cell = tableView.dequeueReusableCell(withIdentifier: "searchVideoCell", for: indexPath) as! VideoInfoTableViewCell
                    cell.infoModel = homeSearch?.news?[indexPath.row]
                    // 关键字标红
                    let attributeString = changeTextColor(text: cell.infoTitleLabel.text ?? "")
                    cell.infoTitleLabel.attributedText = attributeString
                    return cell
                    
                case 3: //左文右图
                    let cell = tableView.dequeueReusableCell(withIdentifier: "searchOneCell", for: indexPath) as! OnePictureTableViewCell
                    cell.infoModel = homeSearch?.news?[indexPath.row]
                    // 关键字标红
                    let attributeString = changeTextColor(text: cell.infoLabel.text ?? "")
                    cell.infoLabel.attributedText = attributeString
                    return cell
                    
                case 4: //三张图
                    let cell = tableView.dequeueReusableCell(withIdentifier: "searchThreeCell", for: indexPath) as! ThreePictureTableViewCell
                    cell.infoModel = homeSearch?.news?[indexPath.row]
                    // 关键字标红
                    let attributeString = changeTextColor(text: cell.infoLabel.text ?? "")
                    cell.infoLabel.attributedText = attributeString
                    return cell
                    
                case 5: // 大图
                    let cell = tableView.dequeueReusableCell(withIdentifier: "searchVideoCell", for: indexPath) as! VideoInfoTableViewCell
                    cell.infoLabel.isHidden = true
                    cell.playImageView.isHidden = true
                    cell.infoModel = homeSearch?.news?[indexPath.row]
                    // 关键字标红
                    let attributeString = changeTextColor(text: cell.infoTitleLabel.text ?? "")
                    cell.infoTitleLabel.attributedText = attributeString
                    return cell
                    
                default:
                    return UITableViewCell()
                }
            }
            return UITableViewCell()
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchShowRoomCell", for: indexPath) as! ShowroomCell
            cell.showRoomModel = homeSearch?.rooms?[indexPath.row]
            // 关键字标红
            let attributeString = changeTextColor(text: cell.showRoomTitleLabel.text ?? "")
            cell.showRoomTitleLabel.attributedText = attributeString
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if (homeSearch?.tickets?.count)! > 0 {
                return 165 * width_height_ratio
            }
            return 0
        case 1:
            if (homeSearch?.news?.count)! > 0 {
                switch homeSearch!.news![indexPath.row].showType! {
                case 0:
                    return 275 * width_height_ratio
                case 1:
                    return 87.5 * width_height_ratio
                case 2:
                    return 275 * width_height_ratio
                case 3:
                    return 109 * width_height_ratio
                case 4:
                    return 160 * width_height_ratio
                case 5:
                    return 275 * width_height_ratio
                default:
                    return 0
                }
            }
            return 0
        case 2:
            if (homeSearch?.rooms?.count)! > 0 {
                return 340 * width_height_ratio
            }
            return 0
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 30))
        footerView.backgroundColor = UIColor.white
        
        let moreLabel = UILabel()
        switch section {
        case 0:
            moreLabel.text = "查看更多抢票结果"
        case 1:
            moreLabel.text = "查看更多资讯结果"
        case 2:
            moreLabel.text = "查看更多发现结果"
        default:
            break
        }
        moreLabel.textColor = UIColor.init(hexColor: "bcbbbb")
        moreLabel.font = UIFont.systemFont(ofSize: 10)
        footerView.addSubview(moreLabel)
        
        let moreButton = UIButton()
        moreButton.tag = section
        moreButton.setImage(UIImage(named: "common_more_button_normal_iPhone"), for: .normal)
        moreButton.addTarget(self, action: #selector(clickMoreButton(sender:)), for: .touchUpInside)
        footerView.addSubview(moreButton)
        
        moreLabel.snp.makeConstraints { (make) in
            make.left.equalTo(footerView).offset(13)
            make.centerY.equalTo(footerView)
            make.height.equalTo(10)
        }
        moreButton.snp.makeConstraints { (make) in
            make.left.equalTo(moreLabel.snp.right).offset(13)
            make.centerY.equalTo(footerView)
            make.size.equalTo(CGSize(width: 25, height: 12))
        }
        
        switch section {
        case 0:
            if homeSearch?.tickets != nil && homeSearch?.tickets?.count != 0 {
                return footerView
            }
            return nil
        case 1:
            if homeSearch?.news != nil && homeSearch?.news?.count != 0 {
                return footerView
            }
            return nil
        case 2:
            if homeSearch?.rooms != nil && homeSearch?.rooms?.count != 0 {
                return footerView
            }
            return nil
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if homeSearch?.tickets != nil && homeSearch?.tickets?.count != 0 {
                return 25
            }
            return 0.01
        case 1:
            if homeSearch?.news != nil && homeSearch?.news?.count != 0 {
                return 25
            }
            return 0.01
        case 2:
            if homeSearch?.rooms != nil && homeSearch?.rooms?.count != 0 {
                return 25
            }
            return 0.01
        default:
            return 0.01
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if homeSearch?.tickets != nil {
                let cell = tableView.cellForRow(at: indexPath) as! ScrambleForTicketCell
                if cell.ticketButton.isUserInteractionEnabled == false {
                    // 抢票截止，不能跳到详情页
                } else if AppInfo.shared.user?.userId == nil {
                    // 未登录也不能跳转到详情页
                    SVProgressHUD.showError(withStatus: "请登录")
                } else {
                    switch homeSearch?.tickets?[indexPath.row].ticketType ?? 0 {
                    case 1:
                        let question = QuestionsViewController()
                        question.ticketTimeId = homeSearch?.tickets?[indexPath.row].ticketTimeId ?? ""
                        navigationController?.pushViewController(question, animated: true)
                    case 2:
                        let vote = VoteViewController()
                        vote.ticketTimeId = homeSearch?.tickets?[indexPath.row].ticketTimeId ?? ""
                        navigationController?.pushViewController(vote, animated: true)
                    case 3:
                        let lottery = LotteryViewController()
                        lottery.ticketTimeId = homeSearch?.tickets?[indexPath.row].ticketTimeId ?? ""
                        navigationController?.pushViewController(lottery, animated: true)
                    default:
                        break
                    }
                }
            }
        case 1:
            if homeSearch?.news != nil {
                
                if homeSearch?.news![indexPath.row].infoType! == 4 {
                    let newsDetail = NewsPhotosDetailViewController()
                    newsDetail.currentIndex = 0
                    newsDetail.imageArray = homeSearch?.news![indexPath.row].infoImageArr
                    newsDetail.contentArray = homeSearch?.news![indexPath.row].contentArray
                    newsDetail.newsId = homeSearch?.news![indexPath.row].newsId ?? ""
                    newsDetail.commentNumber = homeSearch?.news![indexPath.row].infoComment
                    navigationController?.pushViewController(newsDetail, animated: true)
                }
//
//                if newsData![indexPath.row].infoType! == 4 { // 图集
//                    let newsDetail = NewsPhotosDetailViewController()
//                    newsDetail.currentIndex = 0
//                    newsDetail.imageArray = newsData?[indexPath.row].infoImageArr
//                    newsDetail.contentArray = newsData?[indexPath.row].contentArray
//                    newsDetail.newsId = newsData?[indexPath.row].newsId ?? ""
//                    newsDetail.commentNumber = newsData?[indexPath.row].infoComment
//                    navigationController?.pushViewController(newsDetail, animated: true)
//
                else if homeSearch?.news![indexPath.row].infoType! == 2 { // 视频
                    let newsDetail = VideoDetailViewController()
                    newsDetail.newsId = homeSearch?.news![indexPath.row].newsId ?? ""
                    navigationController?.pushViewController(newsDetail, animated: true)

                } else { // web
                    let newsDetail = NewsDetailsViewController()
                    newsDetail.newsId = homeSearch?.news![indexPath.row].newsId
                    newsDetail.commentNumber = homeSearch?.news![indexPath.row].infoComment
                    navigationController?.pushViewController(newsDetail, animated: true)
                
            
                }
//                let news = NewsDetailsViewController()
//                news.newsId = homeSearch?.news?[indexPath.row].newsId
//                news.commentNumber = homeSearch?.news?[indexPath.row].infoComment
//                navigationController?.pushViewController(news, animated: true)
            }
        case 2:
            if homeSearch?.rooms != nil {
                // 跳转
                let showRoom = homeSearch?.rooms?[indexPath.row]
                var board: UIStoryboard
                if showRoom?.isFree == "0" {
                    // 免费
                    board = UIStoryboard.init(name: "FreeShowroomDetails", bundle: nil)
                } else {
                    // 收费
                    board = UIStoryboard.init(name: "ShowroomDetails", bundle: nil)
                }
                let showroomDetailsViewController = board.instantiateInitialViewController() as! ShowroomDetailsViewController
                showroomDetailsViewController.roomId = showRoom?.groupId
                if showRoom?.isFree == "0" {
                    // 免费
                    showroomDetailsViewController.isFree = true
                } else {
                    // 收费
                    showroomDetailsViewController.isFree = false
                }
                navigationController?.pushViewController(showroomDetailsViewController, animated: true)
            }
        default:
            break
        }
    }
}
