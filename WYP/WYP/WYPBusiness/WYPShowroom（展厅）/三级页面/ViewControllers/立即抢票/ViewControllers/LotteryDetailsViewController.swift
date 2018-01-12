//
//  LotteryDetailsViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/4/5.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class LotteryDetailsViewController: BaseViewController {
    
    @IBOutlet var tableView: UITableView!
    
    // 封面图片
    @IBOutlet weak var headScrollView: UIScrollView!    
    
    // 票价
    @IBOutlet weak var ticketPriceLabel: UILabel!
    
    // 关注按钮
    @IBOutlet weak var followButton: UIButton!
    
    // 项目标题
    @IBOutlet weak var projectTitleLabel: UILabel!
    
    // 演出单位
    @IBOutlet weak var showCompanyLabel: UILabel!
    
    // 导演
    @IBOutlet weak var directorLabel: UILabel!
    
    // 制作人
    @IBOutlet weak var producerLabel: UILabel!
    
    // 项目类型
    @IBOutlet weak var projectTypeLabel: UILabel!
    
    // 首演时间
    @IBOutlet weak var firstShowTimeLabel: UILabel!
    
    // 时长
    @IBOutlet weak var lengthLabel: UILabel!
    
    // 国家
    @IBOutlet weak var countryLabel: UILabel!
    // 项目认证
    @IBOutlet weak var projectButton: UIButton!
    // 企业认证
    @IBOutlet weak var companyButton: UIButton!
    
    // 约束
    @IBOutlet weak var firstLineWidth: NSLayoutConstraint!
    
    @IBOutlet weak var secondLineWidth: NSLayoutConstraint!
    
    @IBOutlet weak var thirdLineWidth: NSLayoutConstraint!
    
    
    var lastIndex: Int = 0
    // 展厅id
    var roomId: String?
    // 类型id
    var typeId: Int!
    // 票务信息
    var ticketDetailData: TicketDetailModel?
    // headerView的数据
    var roomInfo: RoomInfoModel? {
        willSet {
            let imageUrl = URL(string: newValue?.background ?? "")
            self.headAImageView.kf.setImage(with: imageUrl)
            
            self.projectTitleLabel.text = newValue?.title ?? ""
            self.followButton.setTitle("  \(newValue?.followedCount ?? "")人", for: .normal)
            if newValue?.isLike == 1 {
                followButton.isSelected = true
            }
            self.typeId = newValue?.typeId
        }
    }
    // 属性数据
    var attribution: AttributionModel? {
        willSet {
            switch typeId {
            case 1:
                self.showCompanyLabel.text = String.init(format: "演出单位：%@", newValue?.first ?? "")
                self.directorLabel.text = String.init(format: "导演：%@", newValue?.second ?? "")
                self.producerLabel.text = String.init(format: "剧目类型：%@", newValue?.playType ?? "")
                self.lengthLabel.text = String.init(format: "剧长：%@分钟", newValue?.fourth ?? "")
                self.firstShowTimeLabel.text = String.init(format: "制作人：%@", newValue?.third ?? "")
                self.countryLabel.text = String.init(format: "国家：%@", newValue?.sixth ?? "")
                self.projectTypeLabel.text = String.init(format: "首演时间：%@", newValue?.fifth ?? "")
                break
                
            case 2:
                self.showCompanyLabel.text = String.init(format: "运营商：%@", newValue?.first ?? "")
                self.directorLabel.text = String.init(format: "所属地区：%@", newValue?.second ?? "")
                self.producerLabel.text = String.init(format: "开放(开团)时间：%@", newValue?.third ?? "")
                self.projectTypeLabel.text = String.init(format: "类型：%@", newValue?.playType ?? "")
                break
                
            case 3:
                self.showCompanyLabel.text = String.init(format: "主办机构：%@", newValue?.first ?? "")
                self.directorLabel.text = String.init(format: "所在地区：%@", newValue?.second ?? "")
                self.producerLabel.text = String.init(format: "展览日期：%@", newValue?.third ?? "")
                self.lengthLabel.text = String.init(format: "剧目类型：%@", newValue?.playType ?? "")
                self.firstShowTimeLabel.text = String.init(format: "展览场馆：%@", newValue?.fourth ?? "")
                break
                
            case 5:
                self.showCompanyLabel.text = String.init(format: "出品方：%@", newValue?.first ?? "")
                self.directorLabel.text = String.init(format: "导演：%@", newValue?.second ?? "")
                self.producerLabel.text = String.init(format: "主演：%@", newValue?.third ?? "")
                self.lengthLabel.text = String.init(format: "影片时长：%@", newValue?.fourth ?? "")
                self.firstShowTimeLabel.text = String.init(format: "首演时间：%@", newValue?.fifth ?? "")
                self.countryLabel.text = String.init(format: "国家：%@", newValue?.sixth ?? "")
                self.projectTypeLabel.text = String.init(format: "看点/类型：%@", newValue?.playType ?? "")
                break
                
            case 4:
                self.showCompanyLabel.text = String.init(format: "主办方：%@", newValue?.first ?? "")
                self.directorLabel.text = String.init(format: "比赛时间：%@", newValue?.second ?? "")
                self.producerLabel.text = String.init(format: "比赛场馆：%@", newValue?.third ?? "")
                self.projectTypeLabel.text = String.init(format: "剧目类型：%@", newValue?.playType ?? "")
                break
                
            case 6:
                self.showCompanyLabel.text = String.init(format: "栏目出品：%@", newValue?.first ?? "")
                self.directorLabel.text = String.init(format: "栏目类型：%@", newValue?.playType ?? "")
                self.producerLabel.text = String.init(format: "录影时间：%@", newValue?.second ?? "")
                self.projectTypeLabel.text = String.init(format: "播出频道：%@", newValue?.third ?? "")
                break
                
            default:
                break
            }
        }
    }
    // 票务Id， 我的关注的票务
    var ticketId: String?

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "抢票详情"
        
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: 355 * width_height_ratio)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "common_share_button_highlight_iPhone"), style: .done, target: self, action: #selector(shareBarButtonItemAction))
        loadTicketDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewConfig()
        headAImageView.startAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        self.tableView.window?.addSubview(bottomView)
        self.tableView.window?.bringSubview(toFront: bottomView)
        bottomView.addSubview(lotteryBtn)
        
        lotteryBtn.snp.makeConstraints { (make) in
            make.left.equalTo(bottomView).offset(13)
            make.right.equalTo(bottomView).offset(-13)
            make.bottom.equalTo(bottomView).offset(-9)
            make.height.equalTo(46)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        bottomView.removeFromSuperview()
    }
    
    // 添加缩放动画
    func viewConfig() {
        headScrollView.contentSize = CGSize(width: kScreen_width, height: 216.5 * width_height_ratio)
        headScrollView.isScrollEnabled = false
        headScrollView.addSubview(headAImageView)
        headAImageView.startAnimation()
    }
    
    // 动画图片
    lazy var headAImageView: KImageViewAnimation = {
        let headAImageView = KImageViewAnimation(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 216.5 * width_height_ratio))
        return headAImageView
    }()
    
    // 获取数据
    private func loadTicketDetail() {
        NetRequest.ticketDetailNetRequest(roomId: roomId ?? "", ticketId: ticketId ?? "", openId: AppInfo.shared.user?.token ?? "") { (success, info, result) in
            if success {
                self.ticketDetailData = TicketDetailModel.deserialize(from: result)
                self.roomInfo = self.ticketDetailData?.roomInfo
                self.attribution = self.ticketDetailData?.attribution
                self.ticketPriceLabel.text = String.init(format: "%@", self.ticketDetailData?.ticketInfo?.ticketPirce ?? "")
                // string 是需要设置中划线的字符串
                let attributedStr = NSMutableAttributedString(string: self.ticketPriceLabel.text ?? "")
                // range 是设置中划线的范围   其他参数不必管
                attributedStr.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: 1), range: NSMakeRange(0, self.ticketPriceLabel.text!.count))
                
                // 赋值
                self.ticketPriceLabel.attributedText = attributedStr
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var bottomView: UIView = {
        let bottomView = UIView(frame: CGRect(x: 0, y: kScreen_height - 60, width: kScreen_width, height: 60))
        bottomView.backgroundColor = UIColor.white
        
        return bottomView
    }()
    
    lazy var lotteryBtn: UIButton = {
        let lotteryBtn = UIButton(type: .custom)
        lotteryBtn.layer.cornerRadius = 5.0
        lotteryBtn.layer.masksToBounds = true
        lotteryBtn.setTitle("立即抢票", for: .normal)
        lotteryBtn.backgroundColor = UIColor.themeColor
        lotteryBtn.addTarget(self, action: #selector(lotteryBtnAction), for: .touchUpInside)
        
        return lotteryBtn
    }()
    
    // MARK: - event response
    func shareBarButtonItemAction() {
        let messageObject = UMSocialMessageObject()
        
        let shareTicketId = ticketDetailData?.ticketInfo?.ticketId ?? ""
        // 分享链接
        let url = String.init(format: "/mob/group/ticketDetail?type_id=%d&g_id=%@", typeId ?? 0, roomId ?? "")
        let shareLink = kApi_baseUrl(path: url)
        // 设置文本
//        messageObject.text = roomInfo!.title! + shareLink
        // 分享对象
        let shareObject: UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: roomInfo?.title ?? "", descr: roomInfo?.detail ?? "", thumImage: UIImage(named: "aladdiny_icon"))
        // 网址
        shareObject.webpageUrl = shareLink
        messageObject.shareObject = shareObject
        
        // 传相关参数
        ShareManager.shared.loadShareAdv()
        ShareManager.shared.complaintId = shareTicketId
        ShareManager.shared.type = "3"
        
        ShareManager.shared.messageObject = messageObject
        ShareManager.shared.viewController = self
        ShareManager.shared.show()
    }
    // 跳转抢票详情
    func lotteryBtnAction() {
        let timeModel = ticketDetailData?.timeInfo?[lastIndex]
        
        switch timeModel?.type ?? "1" {
        case "1":
            // 问答
            let questVC = QuestionsViewController()
            questVC.ticketTimeId = timeModel?.ticketTimeId
            navigationController?.pushViewController(questVC, animated: true)
        case "2":
            // 投票
            let voteVC = VoteViewController()
            voteVC.ticketTimeId = timeModel?.ticketTimeId
            navigationController?.pushViewController(voteVC, animated: true)
        case "3":
            // 抽奖
            let lotteryVC = LotteryViewController()
            lotteryVC.ticketTimeId = timeModel?.ticketTimeId
            navigationController?.pushViewController(lotteryVC, animated: true)
        default:
            break
        }
        
    }
    
    // 关注票务
    @IBAction func attentionTicket(_ sender: UIButton) {
        NetRequest.addAttentionTicketNetRequest(openId: AppInfo.shared.user?.token ?? "", ticketId: ticketDetailData?.ticketInfo?.ticketId ?? "") { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info!)
                sender.isSelected = true
                
                let count = Int(self.ticketDetailData?.roomInfo?.followedCount ?? "")! + 1
                sender.setTitle("  \(count)人", for: .normal)
                sender.isSelected = true
                
                self.loadTicketDetail()
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
    
    // 项目认证
    @IBAction func projectCertificate(_ sender: UIButton) {
        let project = ProjectCertificationViewController()
        project.roomId = roomId ?? ""
        navigationController?.pushViewController(project, animated: true)
    }
    
    // 企业认证
    @IBAction func companyCertificate(_ sender: UIButton) {
        let company = CompanyCertificationViewController()
        company.roomId = roomId
        navigationController?.pushViewController(company, animated: true)
    }
    
}

extension LotteryDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // 选择场次
            let cell = tableView.dequeueReusableCell(withIdentifier: "chooseSessionIdentifier", for: indexPath)
            let collectionView = cell.viewWithTag(400) as? UICollectionView
//            collectionView?.allowsSelection = false
            if collectionView != nil {
                collectionView?.reloadData()
            }
            return cell
        } else if indexPath.section == 1 {
            // 座位图
            let cell = tableView.dequeueReusableCell(withIdentifier: "seatmapIdentifier")
            cell?.textLabel?.text = ticketDetailData?.ticketVernve?.vernveName ?? ""
            cell?.selectionStyle = .none
            return cell!
        } else if indexPath.section == 2 {
            // 地图
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapIdentifier")
            cell?.textLabel?.text = ticketDetailData?.ticketVernve?.vernveAddress ?? ""
            cell?.selectionStyle = .none
            return cell!
        } else {
            // 详情
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailsIdentifier") as? TicketInfoCell
            cell?.ticketInfoLabel.text = ticketDetailData?.ticketInfo?.ticketDetail ?? ""
            cell?.selectionStyle = .none
            return cell!
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 0))
        sectionHeaderView.backgroundColor = UIColor.white
        
        // 灰线
        let grayView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 10))
        grayView.backgroundColor = UIColor.init(hexColor: "f1f2f4")
        sectionHeaderView.addSubview(grayView)
        
        // 图标视图
        let iconView = UIImageView()
        iconView.image = UIImage(named: "home_rednote_icon_normal_iPhone")
        sectionHeaderView.addSubview(iconView)
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.init(hexColor: "333333")
        titleLabel.text = "场次"
        sectionHeaderView.addSubview(titleLabel)
        
        // 设置布局
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(sectionHeaderView)
            make.top.equalTo(grayView.snp.bottom).offset(12)
            make.size.equalTo(CGSize(width: 2, height: 16))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(4)
            make.top.equalTo(grayView.snp.bottom).offset(10)
            make.height.equalTo(18)
        }

        switch section {
        case 0:
            titleLabel.text = "请选择场次"
        case 3:
            titleLabel.text = "详情"
        default:
            break
        }
        if section == 0 || section == 3 {
            return sectionHeaderView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            
            // 场次数量
            let itemCount = Int(ticketDetailData?.timeInfo?.count ?? 0)
            
            if (itemCount % 3) > 0 {
                // 有多余的
                return CGFloat(itemCount / 3 + 1) * 110
            } else {
                // 没有多余的，满格显示
                return CGFloat(itemCount / 3 * 110)
            }
            
        } else if indexPath.section == 1 {
            // 座位图
            return 44.5
        } else if indexPath.section == 2 {
            // 地图
            return 44.5
        } else {
            // 详情
            return 290
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 51.0
        case 3:
            return 40.0
        default:
            return 0.5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 {
            return 30
        }
        return 0.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let mapVC = MapViewController()
            mapVC.vernveId = ticketDetailData?.ticketVernve?.vernveId ?? ""
            navigationController?.pushViewController(mapVC, animated: true)
        } else if indexPath.section == 1 {
            let mapVC = SeatMapViewController()
            mapVC.vernveId = ticketDetailData?.ticketVernve?.vernveId ?? ""
            navigationController?.pushViewController(mapVC, animated: true)
        }
    }
}

extension LotteryDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ticketDetailData?.timeInfo != nil {
            return ticketDetailData?.timeInfo?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as! TicketTimeCell
        if ticketDetailData?.timeInfo != nil && collectionView.tag == 400 {
           cell.timeModel = ticketDetailData?.timeInfo?[indexPath.item]
        }
        
        if indexPath.row == 0 {
            cell.isSelected = true
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let lastCell = collectionView.cellForItem(at: IndexPath(row: lastIndex, section: indexPath.section))
        lastCell?.isSelected = false
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = true
        
        lastIndex = indexPath.row
    }
}

