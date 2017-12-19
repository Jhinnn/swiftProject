//
//  TicketsShowViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class TicketsShowViewController: BaseViewController {
    
    // 二级分类数据
    var ticketData: ScrambleForTicketModel?
    // classPid
    var classPid: String?
    // classId
    var classId: String?
    // 类型 1.问答 2.抽奖 3.投票
    var typeId: String?
    // 标识 1：一般   2：搜索
    var flag = 1
    // 搜索关键字
    var keyword: String?
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        layoutPageSubviews()
        
        // 获取数据
        loadTicketData(requestType: .update)
    }
    
    // MARK: - private method
    private func viewConfig() {
        view.addSubview(ticketTableView)
    }
    private func layoutPageSubviews() {
        ticketTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 20, left: 0, bottom: 100, right: 0))
        }
    }
    // 获取数据
    func loadTicketData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        // 获取经纬度
        let longitude = String.init(format: "%lf", LocationManager.shared.longitude ?? 0)
        let latitude = String.init(format: "%lf", LocationManager.shared.latitude ?? 0)
        if flag == 2 {  // 一级搜索
            // 城市Id
            let cityId = UserDefaults.standard.value(forKey: "cityId") as? String
            NetRequest.ticketListNetRequest(cityId: cityId ?? "", page: "\(pageNumber)", type: typeId ?? "", classPid: "", classId: "", longitude: longitude, latitude: latitude, keywords: keyword ?? "") {  (success, info, result) in
                if success {
                    
                    if requestType == .update {
                        self.ticketData = ScrambleForTicketModel.deserialize(from: result)
                    } else {
                        let dic = ScrambleForTicketModel.deserialize(from: result)
                        let moreTicket = dic?.ticketInfo ?? [TicketModel]()
                        
                        self.ticketData?.ticketInfo = self.ticketData?.ticketInfo ?? [TicketModel]() + moreTicket
                    }
                    
                    // 先移除再添加
                    self.noDataLabel.text = "内容已飞外太空"
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
                    
                    self.ticketTableView.reloadData()
                    self.ticketTableView.mj_header.endRefreshing()
                    self.ticketTableView.mj_footer.endRefreshing()
                } else {
                    self.ticketTableView.mj_header.endRefreshing()
                    self.ticketTableView.mj_footer.endRefreshing()
                }
            }
        } else if flag == 3 { // 二级分类搜索
            NetRequest.ticketSecondSearchNetRequest(page: "\(pageNumber)", type: typeId ?? "", keyword: keyword ?? "", classPid: classPid ?? "", classId: classId ?? "", longitude: longitude, latitude: latitude) { (success, info, result) in
                if success {
                    
                    if requestType == .update {
                        self.ticketData = ScrambleForTicketModel.deserialize(from: result)
                    } else {
                        // 把新数据添加进去
                        let dic = ScrambleForTicketModel.deserialize(from: result)
                        let moreTicket = dic?.ticketInfo ?? [TicketModel]()
                        
                        self.ticketData?.ticketInfo = self.ticketData?.ticketInfo ?? [TicketModel]() + moreTicket
                    }
                    
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
                    
                    self.ticketTableView.reloadData()
                    self.ticketTableView.mj_header.endRefreshing()
                    self.ticketTableView.mj_footer.endRefreshing()
                } else {
                    self.ticketTableView.mj_header.endRefreshing()
                    self.ticketTableView.mj_footer.endRefreshing()
                }
            }
        } else {
            let cityId = UserDefaults.standard.value(forKey: "cityId") as? String
            NetRequest.ticketListNetRequest(cityId: cityId ?? "", page: "\(pageNumber)", type: typeId ?? "", classPid: classPid ?? "", classId: classId ?? "", longitude: longitude, latitude: latitude, keywords: "") {  (success, info, result) in
                if success {
                    
                    if requestType == .update {
                        self.ticketData = ScrambleForTicketModel.deserialize(from: result)
                    } else {
                        // 把新数据添加进去
                        let dic = ScrambleForTicketModel.deserialize(from: result)
                        let moreTicket = dic?.ticketInfo ?? [TicketModel]()
                        
                        self.ticketData?.ticketInfo = self.ticketData?.ticketInfo ?? [TicketModel]() + moreTicket
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
                    
                    self.ticketTableView.reloadData()
                    self.ticketTableView.mj_header.endRefreshing()
                    self.ticketTableView.mj_footer.endRefreshing()
                } else {
                    self.ticketTableView.mj_header.endRefreshing()
                    self.ticketTableView.mj_footer.endRefreshing()
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
        
        if keyword != "" && keyword != nil {
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
        }
        
        return attributedString
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
        
        return ticketTableView
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

extension TicketsShowViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if ticketData?.ticketInfo == nil {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
        }
        return ticketData?.ticketInfo?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ticketCell") as! ScrambleForTicketCell
        cell.delegate = self
        cell.ticketModel = ticketData?.ticketInfo?[indexPath.row]
        cell.ticketButton.tag = indexPath.row + 220
        // 关键字标红
        if keyword != "" && keyword != nil {
            let attributeString = changeTextColor(text: cell.ticketTitleLabel.text ?? "")
            cell.ticketTitleLabel.attributedText = attributeString
        }
        
        return cell
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
            switch typeId ?? "100" {
            case "1":
                // 问答
                let question = QuestionsViewController()
                question.ticketTimeId = ticketData?.ticketInfo?[indexPath.row].ticketTimeId ?? ""
                navigationController?.pushViewController(question, animated: true)
                break
            case "2":
                // 投票
                let vote = VoteViewController()
                vote.ticketTimeId = ticketData?.ticketInfo?[indexPath.row].ticketTimeId ?? ""
                navigationController?.pushViewController(vote, animated: true)
                break
            case "3":
                // 抽奖
                let lottery = LotteryViewController()
                lottery.ticketTimeId = ticketData?.ticketInfo?[indexPath.row].ticketTimeId ?? ""
                navigationController?.pushViewController(lottery, animated: true)
                break
            default:
                break
            }
        }
    }
}

extension TicketsShowViewController: ScrambleForTicketCellDelegate {
    func clickGrabTicket(sender: UIButton) {
        print(typeId ?? "")
        switch typeId! {
        case "1":
            let question = QuestionsViewController()
            question.ticketTimeId = ticketData?.ticketInfo?[sender.tag - 220].ticketTimeId ?? ""
            navigationController?.pushViewController(question, animated: true)
            break
        case "2":
            let vote = VoteViewController()
            vote.ticketTimeId = ticketData?.ticketInfo?[sender.tag - 220].ticketTimeId ?? ""
            navigationController?.pushViewController(vote, animated: true)
            break
        case "3":
            let lottery = LotteryViewController()
            lottery.ticketTimeId = ticketData?.ticketInfo?[sender.tag - 220].ticketTimeId ?? ""
            navigationController?.pushViewController(lottery, animated: true)
            break
        default:
            break
        }
    }
}
