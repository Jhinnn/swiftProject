//
//  AttentionTicketViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class AttentionTicketViewController: BaseViewController {
    
    // 票务数据
    var ticketData: ScrambleForTicketModel?
    // 首页搜索关键字
    var keyword: String?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        layoutPageSubviews()
        loadDataSource(requestType: .update)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
        NetRequest.attentionTicketNetRequest(page: "\(pageNumber)", openId: AppInfo.shared.user?.token ?? "", longitude: "116.440273", latitude: "39.947302") { (success, info, result) in
            if success {
                if requestType == .update {
                    self.ticketData = ScrambleForTicketModel.deserialize(from: result)
                } else {
                    // 把新数据添加进去
                    
                    let dic = ScrambleForTicketModel.deserialize(from: result)
                    
                    self.ticketData?.ticketInfo = self.ticketData?.ticketInfo ?? [TicketModel]() + (dic?.ticketInfo)!
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
                
                self.ticketTableView.mj_header.endRefreshing()
                self.ticketTableView.mj_footer.endRefreshing()
                self.ticketTableView.reloadData()
            } else {
                self.ticketTableView.mj_header.endRefreshing()
                self.ticketTableView.mj_footer.endRefreshing()
            }
        }
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
        imageView.image = UIImage(named: "common_noData_icon_normal_iPhone")
        return imageView
    }()
    // 没有数据时的提示文字
    lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "暂无关注的票务"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
}

extension AttentionTicketViewController: UITableViewDelegate, UITableViewDataSource {
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
        cell.ticketModel = ticketData?.ticketInfo?[indexPath.row]
        cell.delegate = self
        cell.ticketButton.tag = indexPath.row + 240
        return cell
    }
    
    // 选中单元格
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let board = UIStoryboard.init(name: "LotteryDetails", bundle: nil)
        let lotteryDetailsViewController = board.instantiateInitialViewController() as! LotteryDetailsViewController
        lotteryDetailsViewController.ticketId = ticketData?.ticketInfo?[indexPath.row].ticketId ?? ""
        navigationController?.pushViewController(lotteryDetailsViewController, animated: true)
        
        ticketTableView.deselectRow(at: indexPath, animated: true)
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
            let ticketId = ticketData?.ticketInfo?[indexPath.row].ticketId ?? ""
            //1.从数据库将数据移除
            NetRequest.ticketCancelAttentionNetRequest(openId: AppInfo.shared.user?.token ?? "", ticketId: ticketId, complete: { (success, info) in
                if success {
                    self.ticketData?.ticketInfo?.remove(at: indexPath.row)
                    // 刷新单元格
                    tableView.reloadData()
                    SVProgressHUD.showSuccess(withStatus: info!)
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            })
            //2.刷新单元格
            tableView.reloadData()
        }
    }

}

extension AttentionTicketViewController: ScrambleForTicketCellDelegate {
    func clickGrabTicket(sender: UIButton) {
        let ticketType = ticketData?.ticketInfo?[sender.tag - 240].ticketType ?? 0
        switch ticketType {
        case 1:
            let question = QuestionsViewController()
            question.ticketTimeId = ticketData?.ticketInfo?[sender.tag - 240].ticketTimeId ?? ""
            question.ticketName = ticketData?.ticketInfo?[sender.tag - 240].ticketTitle ?? ""
            navigationController?.pushViewController(question, animated: true)
            break
        case 2:
            let vote = VoteViewController()
            vote.ticketTimeId = ticketData?.ticketInfo?[sender.tag - 240].ticketTimeId ?? ""
            vote.ticketName = ticketData?.ticketInfo?[sender.tag - 240].ticketTitle ?? ""
            navigationController?.pushViewController(vote, animated: true)
            break
        case 3:
            let lottery = LotteryViewController()
            lottery.ticketTimeId = ticketData?.ticketInfo?[sender.tag - 240].ticketTimeId ?? ""
            lottery.ticketName = ticketData?.ticketInfo?[sender.tag - 240].ticketTitle ?? ""
            navigationController?.pushViewController(lottery, animated: true)
            break
        default:
            break
        }
    }
}
