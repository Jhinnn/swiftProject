//
//  SearchHomeTicketsViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/6/7.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class SearchHomeTicketsViewController: BaseViewController {

    // 票务数据
    var ticketData: [TicketModel]?
    // 首页搜索关键字
    var keyword: String?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        layoutPageSubviews()
        loadDataSource(requestType: .update)
    }
    
    // MARK: - private method
    func viewConfig() {
        view.addSubview(ticketTableView)
    }
    func layoutPageSubviews() {
        ticketTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 108, right: 0))
        }
    }
    func loadDataSource(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.homeSearchMoreTicketNetRquest(page: "\(pageNumber)", keyword: keyword ?? "", longitude: "116.440273", latitude: "39.947302", complete: { (success, info, result) in
            if success {
                
                let array = result?.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                
                if requestType == .update {
                    self.ticketData = [TicketModel].deserialize(from: jsonString) as? [TicketModel]
                } else {
                    // 把新数据添加进去
                    let ticketArray = [TicketModel].deserialize(from: jsonString) as? [TicketModel]
                    self.ticketData = self.ticketData! + ticketArray!
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
                self.ticketTableView.reloadData()
                self.ticketTableView.mj_header.endRefreshing()
                self.ticketTableView.mj_footer.endRefreshing()
            }
        })
            
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
    
    // MARK: - stter and getter
    lazy var ticketTableView: UITableView = {
        let ticketTableView = UITableView(frame: CGRect.zero, style: .plain)
        ticketTableView.rowHeight = 165
        ticketTableView.delegate = self
        ticketTableView.dataSource = self
        ticketTableView.tableFooterView = UIView()
        ticketTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadDataSource(requestType: .loadMore)
        })
        ticketTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadDataSource(requestType: .update)
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
        label.text = "内容已飞外太空"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
}

extension SearchHomeTicketsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ticketData?.count == 0 {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
        }
        return ticketData?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ticketCell") as! ScrambleForTicketCell
        cell.ticketModel = ticketData?[indexPath.row]
        cell.delegate = self
        cell.ticketButton.tag = indexPath.row + 240
        // 关键字标红
        let attributeString = changeTextColor(text: cell.ticketTitleLabel.text ?? "")
        cell.ticketTitleLabel.attributedText = attributeString
        
        return cell
    }
    
    // 选中单元格
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ScrambleForTicketCell
        if cell.ticketButton.isUserInteractionEnabled == false {
            // 抢票截止，不能跳到详情页
        } else if AppInfo.shared.user?.userId == nil {
            // 未登录也不能跳转到详情页
            SVProgressHUD.showError(withStatus: "请登录")
        } else {
            let board = UIStoryboard.init(name: "LotteryDetails", bundle: nil)
            let lotteryDetailsViewController = board.instantiateInitialViewController() as! LotteryDetailsViewController
            lotteryDetailsViewController.ticketId = ticketData?[indexPath.row].ticketId ?? ""
            navigationController?.pushViewController(lotteryDetailsViewController, animated: true)
            
            ticketTableView.deselectRow(at: indexPath, animated: true)
        }
        
        
    }
    
}

extension SearchHomeTicketsViewController: ScrambleForTicketCellDelegate {
    func clickGrabTicket(sender: UIButton) {
        let ticketType = ticketData?[sender.tag - 240].ticketType ?? 0
        switch ticketType {
        case 1:
            let question = QuestionsViewController()
            question.ticketTimeId = ticketData?[sender.tag - 240].ticketTimeId ?? ""
            question.ticketName = ticketData?[sender.tag - 240].ticketTitle ?? ""
            navigationController?.pushViewController(question, animated: true)
            break
        case 2:
            let vote = VoteViewController()
            vote.ticketTimeId = ticketData?[sender.tag - 240].ticketTimeId ?? ""
            vote.ticketName = ticketData?[sender.tag - 240].ticketTitle ?? ""
            navigationController?.pushViewController(vote, animated: true)
            break
        case 3:
            let lottery = LotteryViewController()
            lottery.ticketTimeId = ticketData?[sender.tag - 240].ticketTimeId ?? ""
            lottery.ticketName = ticketData?[sender.tag - 240].ticketTitle ?? ""
            navigationController?.pushViewController(lottery, animated: true)
            break
        default:
            break
        }
    }
}
