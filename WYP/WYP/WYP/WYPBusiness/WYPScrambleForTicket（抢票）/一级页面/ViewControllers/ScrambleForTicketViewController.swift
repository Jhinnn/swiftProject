//
//  ScrambleForTicketViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/31.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ScrambleForTicketViewController: BaseViewController {

    // 是否显示banner
    var isShowBanner: Bool = true
    // 票务数据
    var ticketData: ScrambleForTicketModel?
    // 活动类型
    var ticketType: String?
    
    // banner数据
    var bannerData: [BannerModel]?
    // banner图片
    var bannerImages: [String]? {
        willSet {
            syBanner.imagePaths = newValue!
        }
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfig()
        layoutPageSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadBannerData()
        
        // 获取数据
        loadTicketData(requestType: .update)
        self.ticketTableView.reloadData()
    }

    // MARK: - private method
    private func viewConfig() {
        view.addSubview(ticketTableView)

        // 只有全部页面显示banner
        if isShowBanner == true {
            ticketTableView.tableHeaderView = syBanner
        }
    }
    private func layoutPageSubviews() {
        ticketTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 157, right: 0))
        }
    }
    
    // 轮播图
    func loadBannerData() {
        switch ticketType ?? "" {
        case "1":
            NetRequest.questionAdv { (success, info, result) in
                if success {
                    let array = result!.value(forKey: "banner")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    self.bannerData = [BannerModel].deserialize(from: jsonString) as? [BannerModel]
                    
                    self.bannerImages = [String]()
                    for i in 0..<self.bannerData!.count {
                        self.bannerImages?.append(self.bannerData?[i].bannerImage ?? "")
                    }
                    
                }
            }
        case "2":
            NetRequest.voteAdv { (success, info, result) in
                if success {
                    let array = result!.value(forKey: "banner")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    self.bannerData = [BannerModel].deserialize(from: jsonString) as? [BannerModel]
                    
                    self.bannerImages = [String]()
                    for i in 0..<self.bannerData!.count {
                        self.bannerImages?.append(self.bannerData?[i].bannerImage ?? "")
                    }
                    
                }
            }
        case "3":
            NetRequest.lotteryAdv { (success, info, result) in
                if success {
                    let array = result!.value(forKey: "banner")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    self.bannerData = [BannerModel].deserialize(from: jsonString) as? [BannerModel]
                    
                    self.bannerImages = [String]()
                    for i in 0..<self.bannerData!.count {
                        self.bannerImages?.append(self.bannerData?[i].bannerImage ?? "")
                    }
                    
                }
            }
        default:
            break
        }
        
    }
    
    private func loadTicketData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        let cityId = UserDefaults.standard.value(forKey: "cityId") as? String
        let longitude = String.init(format: "%lf", LocationManager.shared.longitude ?? 0)
        let latitude = String.init(format: "%lf", LocationManager.shared.latitude ?? 0)
        NetRequest.ticketListNetRequest(cityId: cityId ?? "110100", page: "\(pageNumber)", type: ticketType ?? "", classPid: "", classId: "", longitude: longitude, latitude: latitude, keywords: "") {  (success, info, result) in
            if success {

                if requestType == .update {
                    self.ticketData = ScrambleForTicketModel.deserialize(from: result)
                } else {
                    // 把新数据添加进去
                    
                    let dic = ScrambleForTicketModel.deserialize(from: result)
                    let moreTicket = dic?.ticketInfo ?? [TicketModel]()
                    
                    self.ticketData?.ticketInfo = self.ticketData?.ticketInfo ?? [TicketModel]() + moreTicket
                }
                
                // 没有数据的情况显示
                if !deviceTypeIPhone4() {
                    self.view.addSubview(self.noDataLabel)
                }
                
                self.ticketTableView.reloadData()
                self.ticketTableView.mj_header.endRefreshing()
                self.ticketTableView.mj_footer.endRefreshing()
            } else {
                self.ticketTableView.mj_header.endRefreshing()
                self.ticketTableView.mj_footer.endRefreshing()
            }
        }
    }
    
    // MARK: - stter and getter
    lazy var ticketTableView: WYPTableView = {
        let ticketTableView = WYPTableView(frame: CGRect.zero, style: .plain)
        ticketTableView.rowHeight = 165
        ticketTableView.delegate = self
        ticketTableView.dataSource = self
        ticketTableView.tableFooterView = UIView()
        ticketTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadTicketData(requestType: .loadMore)
        })
        ticketTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadTicketData(requestType: .update)
        })
        
        //注册
        ticketTableView.register(ScrambleForTicketCell.self, forCellReuseIdentifier: "ticketCell")
        ticketTableView.register(TicketCategoryTableViewCell.self, forCellReuseIdentifier: "ticketCategoryCell")
        
        return ticketTableView
    }()
    
    // 设置表视图头视图
    lazy var syBanner: SYBannerView = {
        let banner = SYBannerView(frame: CGRect(x: 0, y: 70, width: kScreen_width, height: 180 * width_height_ratio))
        banner.delegate = self
        return banner
    }()
    
    // 没有找到结果
    lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: kScreen_height - 250, width: kScreen_width, height: 15)
        label.text = "当前地区抢票活动已结束"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
}

extension ScrambleForTicketViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ticketData?.ticketInfo != nil {
            if ticketData?.ticketInfo?.count == 0 {
                noDataLabel.isHidden = false
            } else {
                noDataLabel.isHidden = true
            }
        } else {
            noDataLabel.isHidden = false
        }
        
        
        if section == 0 {
            return 1
        } else {
            return ticketData?.ticketInfo?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        }
        return 165
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "ticketCategoryCell") as! TicketCategoryTableViewCell
            if ticketData?.ticketNumber != nil {
                cell.ticketCategory = ticketData?.ticketNumber
            }
            cell.ticketCategoryCollection.reloadData()
            cell.delegate = self
            return cell
        } else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "ticketCell") as! ScrambleForTicketCell
            cell.ticketModel = ticketData?.ticketInfo?[indexPath.row]
            cell.ticketButton.tag = indexPath.row + 220
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! ScrambleForTicketCell
        if cell.ticketButton.isUserInteractionEnabled == false {
            // 抢票截止，不能跳到详情页
        } else if AppInfo.shared.user?.userId == nil {
            // 未登录也不能跳转到详情页
            SVProgressHUD.showError(withStatus: "请登录")
        } else {
            switch ticketType! {
            case "1":
                let question = QuestionsViewController()
                question.ticketId = ticketData?.ticketInfo?[indexPath.row].ticketId ?? ""
                question.ticketTimeId = ticketData?.ticketInfo?[indexPath.row].ticketTimeId ?? ""
                question.ticketName = ticketData?.ticketInfo?[indexPath.row].ticketTitle ?? ""
                navigationController?.pushViewController(question, animated: true)
                break
            case "2":
                let vote = VoteViewController()
                vote.ticketId = ticketData?.ticketInfo?[indexPath.row].ticketId ?? ""
                vote.ticketTimeId = ticketData?.ticketInfo?[indexPath.row].ticketTimeId ?? ""
                vote.ticketName = ticketData?.ticketInfo?[indexPath.row].ticketTitle ?? ""
                navigationController?.pushViewController(vote, animated: true)
                break
            case "3":
                let lottery = LotteryViewController()
                lottery.ticketId = ticketData?.ticketInfo?[indexPath.row].ticketId ?? ""
                lottery.ticketTimeId = ticketData?.ticketInfo?[indexPath.row].ticketTimeId ?? ""
                lottery.ticketName = ticketData?.ticketInfo?[indexPath.row].ticketTitle ?? ""
                navigationController?.pushViewController(lottery, animated: true)
                break
            default:
                break
            }
        }        
    }
    
}

extension ScrambleForTicketViewController: ScrambleForTicketCellDelegate, TicketCategoryTableViewCellDelegate {
    func clickGrabTicket(sender: UIButton) {
        if AppInfo.shared.user?.userId != nil {
            switch ticketType! {
            case "1":
                let question = QuestionsViewController()
                question.ticketId = ticketData?.ticketInfo?[sender.tag - 220].ticketId ?? ""
                question.ticketTimeId = ticketData?.ticketInfo?[sender.tag - 220].ticketTimeId ?? ""
                question.ticketName = ticketData?.ticketInfo?[sender.tag - 220].ticketTitle ?? ""
                navigationController?.pushViewController(question, animated: true)
                break
            case "2":
                let vote = VoteViewController()
                vote.ticketId = ticketData?.ticketInfo?[sender.tag - 220].ticketId ?? ""
                vote.ticketTimeId = ticketData?.ticketInfo?[sender.tag - 220].ticketTimeId ?? ""
                vote.ticketName = ticketData?.ticketInfo?[sender.tag - 220].ticketTitle ?? ""
                navigationController?.pushViewController(vote, animated: true)
                break
            case "3":
                let lottery = LotteryViewController()
                lottery.ticketId = ticketData?.ticketInfo?[sender.tag - 220].ticketId ?? ""
                lottery.ticketTimeId = ticketData?.ticketInfo?[sender.tag - 220].ticketTimeId ?? ""
                lottery.ticketName = ticketData?.ticketInfo?[sender.tag - 220].ticketTitle ?? ""
                navigationController?.pushViewController(lottery, animated: true)
                break
            default:
                break
            }
        }
    }
    func ticketCategoryTableViewDidSelected(item: Int, title: String) {
        let ticket = TicketShowNaviViewController()
        ticket.type = ticketType
        ticket.title = title
        navigationController?.pushViewController(ticket, animated: true)
    }
}

extension ScrambleForTicketViewController: SYBannerViewDelegate {
    
    // MARK: - LBBannerDelegate
    
    func cycleScrollView(_ scrollView: SYBannerView, didSelectItemAtIndex index: Int) {
        NetRequest.clickAdvNetRequest(advId: bannerData?[index].bannerId ?? "")
        switch bannerData?[index].bannerType ?? "0" {
        case "0": // 默认广告
            let adv = AdvViewController()
            let link = String.init(format: "mob/adv/advdetails/id/%@", bannerData?[index].bannerId ?? "")
            adv.advLink = kApi_baseUrl(path: link)
            navigationController?.pushViewController(adv, animated: false)
            break
        case "1": // 跳转url
            let adv = AdvViewController()
            adv.advLink = bannerData?[index].url
            navigationController?.pushViewController(adv, animated: false)
            break
        case "2": // 跳转展厅
            // 跳转
            let showRoom = bannerData?[index]
            var board: UIStoryboard
            if showRoom?.isFree == "0" {
                board = UIStoryboard.init(name: "FreeShowroomDetails", bundle: nil)
            } else {
                board = UIStoryboard.init(name: "ShowroomDetails", bundle: nil)
            }
            let showroomDetailsViewController = board.instantiateInitialViewController() as! ShowroomDetailsViewController
            showroomDetailsViewController.roomId = showRoom?.roomId
            showroomDetailsViewController.isTicket = bannerData?[index].isTicket ?? 0
            if showRoom?.isFree == "0" {
                showroomDetailsViewController.isFree = true
            } else {
                showroomDetailsViewController.isFree = false
            }
            navigationController?.pushViewController(showroomDetailsViewController, animated: false)
            break
        case "3": // 跳转活动
            switch bannerData?[index].ticketType ?? "" {
            case "1":
                let question = QuestionsViewController()
                question.ticketId = bannerData?[index].ticketId ?? ""
                question.ticketTimeId = bannerData?[index].ticketTimeId ?? ""
                navigationController?.pushViewController(question, animated: false)
                break
            case "2":
                let vote = VoteViewController()
                vote.ticketId = bannerData?[index].ticketId ?? ""
                vote.ticketTimeId = bannerData?[index].ticketTimeId ?? ""
                navigationController?.pushViewController(vote, animated: false)
                break
            case "3":
                let lottery = LotteryViewController()
                lottery.ticketId = bannerData?[index].ticketId ?? ""
                lottery.ticketTimeId = bannerData?[index].ticketTimeId ?? ""
                navigationController?.pushViewController(lottery, animated: false)
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
}
