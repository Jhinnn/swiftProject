//
//  InviteFriendsViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/4/1.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class InviteFriendsViewController: BaseViewController {
    
    var inviteFriends: [InviteFriendsModel]?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        layoutPageSubviews()
        loadInviteFriends(requestType: .update)
    }
    
    // MARK: - private method
    private func viewConfig() {
        self.title = "活动邀请"
        view.addSubview(warningLabel)
        view.addSubview(inviteTableView)
    }
    private func layoutPageSubviews() {
        warningLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.left.equalTo(view).offset(10)
            make.size.equalTo(CGSize(width: kScreen_width - 20, height: 40))
        }
        inviteTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(40, 0, 0, 0))
        }
    }
    func loadInviteFriends(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.inviteFriendsNetRequest(page: "\(pageNumber)",uid: AppInfo.shared.user?.userId ?? "") { (success, info, result) in
            if success {
                let array = result!.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                if requestType == .update {
                    self.inviteFriends = [InviteFriendsModel].deserialize(from: jsonString) as? [InviteFriendsModel]
                } else {
                    // 把新数据添加进去
                    
                    let inviteFriendsArray = [InviteFriendsModel].deserialize(from: jsonString) as? [InviteFriendsModel]
                    
                    self.inviteFriends = self.inviteFriends! + inviteFriendsArray!
                }
                
                // 先移除再添加
                self.noDataImageView.removeFromSuperview()
                self.noDataLabel.removeFromSuperview()
                // 没有数据时
                self.view.addSubview(self.noDataImageView)
                self.view.addSubview(self.noDataLabel)
                self.view.addSubview(self.noDataButton)
                self.noDataImageView.snp.makeConstraints { (make) in
                    if deviceTypeIphone5() || deviceTypeIPhone4() {
                        make.top.equalTo(self.view).offset(130)
                    }
                    make.top.equalTo(self.view).offset(180)
                    make.centerX.equalTo(self.view)
                    make.size.equalTo(CGSize(width: 100, height: 147))
                }
                self.noDataLabel.snp.makeConstraints({ (make) in
                    make.centerX.equalTo(self.view)
                    make.top.equalTo(self.noDataImageView.snp.bottom).offset(10)
                    make.height.equalTo(11)
                })
                self.noDataButton.snp.makeConstraints({ (make) in
                    make.centerX.equalTo(self.view)
                    make.top.equalTo(self.noDataLabel.snp.bottom).offset(10)
                    make.size.equalTo(CGSize(width: 100, height: 20))
                })
                
                self.inviteTableView.reloadData()
                self.inviteTableView.mj_header.endRefreshing()
                self.inviteTableView.mj_footer.endRefreshing()
            } else {
                self.inviteTableView.mj_header.endRefreshing()
                self.inviteTableView.mj_footer.endRefreshing()
                SVProgressHUD.showError(withStatus: info)
            }
        }
    }
    
    // MARK: - event response
    func whenNoDataGoToTicket(sender: UIButton) {
        self.tabBarController?.selectedIndex = 3
        ticketsCurrentIndex = 1
    }
    
    // MARK: - setter and getter
    lazy var warningLabel: UILabel = {
        let warningLabel = UILabel()
        warningLabel.text = "邀请好友可获得宣传口号中的一个字，集齐5个字可以获得一张兑换券，兑换券可在我的-钱包中进行查看"
        warningLabel.font = UIFont.systemFont(ofSize: 11)
        warningLabel.numberOfLines = 2
        warningLabel.textColor = UIColor.init(hexColor: "a1a1a1")
        return warningLabel
    }()
    lazy var inviteTableView: UITableView = {
        let inviteTableView = UITableView(frame: .zero, style: .plain)
        inviteTableView.rowHeight = 150
        inviteTableView.delegate = self
        inviteTableView.dataSource = self
        inviteTableView.tableFooterView = UIView()
        inviteTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadInviteFriends(requestType: .loadMore)
        })
        inviteTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadInviteFriends(requestType: .update)
        })
        //注册
        inviteTableView.register(InviteFriendsTableViewCell.self, forCellReuseIdentifier: "inviteCell")
        
        return inviteTableView
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
        label.text = "暂无参与活动"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
    // 没有数据时跳转到抽奖模块
    lazy var noDataButton: UIButton = {
        let noDataButton = UIButton()
        noDataButton.setTitle("立即抢票", for: .normal)
        noDataButton.setTitleColor(UIColor.themeColor, for: .normal)
        noDataButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        noDataButton.layer.masksToBounds = true
        noDataButton.layer.cornerRadius = 5.0
        noDataButton.layer.borderWidth = 1
        noDataButton.layer.borderColor = UIColor.themeColor.cgColor
        noDataButton.addTarget(self, action: #selector(whenNoDataGoToTicket(sender:)), for: .touchUpInside)
        return noDataButton
    }()
}

extension InviteFriendsViewController: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inviteFriends?.count == 0 {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
            noDataButton.isHidden = false
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
            noDataButton.isHidden = true
        }
        return inviteFriends?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell") as! InviteFriendsTableViewCell
        cell.selectionStyle = .none
        cell.inviteModel = inviteFriends?[indexPath.row]
        cell.inviteButton.tag = indexPath.row + 210
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! InviteFriendsTableViewCell
        if cell.inviteButton.isUserInteractionEnabled == false {
            // 抢票截止，不能跳到详情页
        } else {
            let activityType = inviteFriends?[indexPath.item].activityType ?? "0"
            switch activityType {
            case "1":
                let question = QuestionsViewController()
                question.ticketTimeId = inviteFriends?[indexPath.item].ticketTimeId ?? ""
                question.ticketName = inviteFriends?[indexPath.item].ticketTitle ?? ""
                navigationController?.pushViewController(question, animated: true)
                break
            case "2":
                let vote = VoteViewController()
                vote.ticketTimeId = inviteFriends?[indexPath.item].ticketTimeId ?? ""
                vote.ticketName = inviteFriends?[indexPath.item].ticketTitle ?? ""
                navigationController?.pushViewController(vote, animated: true)
                break
            case "3":
                let lottery = LotteryViewController()
                lottery.ticketTimeId = inviteFriends?[indexPath.item].ticketTimeId ?? ""
                lottery.ticketName = inviteFriends?[indexPath.item].ticketTitle ?? ""
                navigationController?.pushViewController(lottery, animated: true)
                break
            default:
                break
            }
        }
    }
}

extension InviteFriendsViewController: InviteFriendsTableViewCellDelegate {
    func exchangeToTicketOrInviteFriends(sender: UIButton) {
        
        if sender.titleLabel?.text == "兑换" {
            let board = UIStoryboard.init(name: "Main", bundle: nil)
            let goods = board.instantiateViewController(withIdentifier: "GoodsAddressIdentity") as! GoodsAddressController
            goods.flag = 2
            goods.typeId = "2"
            goods.walletId = ""
            goods.invitationId = inviteFriends?[sender.tag - 210].ticketId
            goods.ticketTimeId = inviteFriends?[sender.tag - 210].ticketTimeId
            goods.ticketName = inviteFriends?[sender.tag - 210].ticketTitle
            navigationController?.pushViewController(goods, animated: true)
        } else {
            let messageObject = UMSocialMessageObject()
            
            // 缩略图
            let thumbURL = ""
            // 分享对象
            let shareObject: UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: inviteFriends?[sender.tag - 210].ticketTitle ?? "", descr: "在这里，有各种好玩的活动等着你，点进来看看吧", thumImage: thumbURL)
            // 网址
            let url = String.init(format: "Mob/WebActivity/adv.html?is_share=1&ticket_time_id=%@&share_uid=%@", inviteFriends?[sender.tag - 210].ticketTimeId ?? "", AppInfo.shared.user?.userId ?? "")
            shareObject.webpageUrl = kApi_baseUrl(path: url)
            
            messageObject.shareObject = shareObject
            
            // 传相关参数
            ShareManager.shared.loadShareAdv()
            ShareManager.shared.complaintId = inviteFriends?[sender.tag - 210].ticketId ?? ""
            ShareManager.shared.type = "4"
            
            ShareManager.shared.messageObject = messageObject
            ShareManager.shared.viewController = self
            ShareManager.shared.show()
        }

        
    }
}
