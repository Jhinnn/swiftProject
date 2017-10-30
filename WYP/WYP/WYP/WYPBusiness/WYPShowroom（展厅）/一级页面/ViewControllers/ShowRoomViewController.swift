//
//  ShowRoomViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/1.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ShowRoomViewController: BaseViewController {

    // 是否显示banner
    var isShowBanner: Bool = true
    // 数据源
    var showRoomData: [ShowroomModel]?
    // 分类id
    var typeId: String?
    // 一级页面二级页面的标志
    var flag: Int = 1
    // 首页搜索关键字
    var keyword: String?
    
    // 最新最热 1：最新  2：最热
    var order = ""
    
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
        
        // 获取数据
        loadShowRoomData(requestType: .update)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadBannerData()
    }

    // MARK: - private method
    private func viewConfig() {
        view.addSubview(showRoomTableView)
        // 只有全部页面显示banner
        if isShowBanner == true {
            showRoomTableView.tableHeaderView = syBanner
        }
        showRoomData = [ShowroomModel]()
    }
    private func layoutPageSubviews() {
        switch flag {
        case 1:
            showRoomTableView.snp.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 157, 0))
            }
            break

        default:
            showRoomTableView.snp.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 108, 0))
            }
            break
        }
        
    }
    
    // 轮播图
    func loadBannerData() {
        NetRequest.showRoomAdv { (success, info, result) in
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
    }

    // 数据请求
    func loadShowRoomData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        if flag == 2 { // 从首页的搜索进来的
            NetRequest.homeSearchMoreRoomsNetRquest(page: "\(pageNumber)", keyword: keyword ?? "", complete: { (success, info, result) in
                if success {
                    
                    let array = result!.value(forKey: "data")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    if requestType == .update {
                        self.showRoomData = [ShowroomModel].deserialize(from: jsonString) as? [ShowroomModel]
                    } else {
                        // 把新数据添加进去
                        let show = [ShowroomModel].deserialize(from: jsonString) as! [ShowroomModel]
                        self.showRoomData = self.showRoomData! + show
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
                    
                    self.showRoomTableView.reloadData()
                    self.showRoomTableView.mj_header.endRefreshing()
                    self.showRoomTableView.mj_footer.endRefreshing()
                } else {
                    self.showRoomTableView.mj_header.endRefreshing()
                    self.showRoomTableView.mj_footer.endRefreshing()
                }
            })
        } else if flag == 10 { // 展厅搜索结果页
            NetRequest.roomSearchNetRequest(keyword: keyword ?? "", page: "\(pageNumber)", typeId: typeId ?? "") { (success, info, result) in
                if success {
                    let array = result!.value(forKey: "data")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    
                    if requestType == .update {
                        self.showRoomData = [ShowroomModel].deserialize(from: jsonString) as? [ShowroomModel]
                    } else {
                        // 把新数据添加进去
                        let show = [ShowroomModel].deserialize(from: jsonString) as? [ShowroomModel]
                        self.showRoomData = self.showRoomData! + show!
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
                    
                    self.showRoomTableView.reloadData()
                    self.showRoomTableView.mj_header.endRefreshing()
                    self.showRoomTableView.mj_footer.endRefreshing()
                } else {
                    self.showRoomTableView.mj_header.endRefreshing()
                    self.showRoomTableView.mj_footer.endRefreshing()
                }
            }
            
        } else { // 获取展厅分类列表数据
            NetRequest.showRoomNetRequest(page: "\(pageNumber)", type_id: typeId ?? "", order: order) { (success, info, result) in
                print(self.order)
                if success {
                    let array = result!.value(forKey: "data")
                    let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                    if requestType == .update {
                        self.showRoomData = [ShowroomModel].deserialize(from: jsonString) as? [ShowroomModel]
                    } else {
                        // 把新数据添加进去
                        let show = [ShowroomModel].deserialize(from: jsonString) as! [ShowroomModel]
                        self.showRoomData = self.showRoomData! + show
                    }
                    
                    // 先移除再添加
                    self.noDataImageView.removeFromSuperview()
                    self.noDataLabel.removeFromSuperview()
                    // 没有数据的情况
                    self.noDataLabel.text = "该频道暂未开放，敬请期待"
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
                    
                    self.showRoomTableView.reloadData()
                    self.showRoomTableView.mj_header.endRefreshing()
                    self.showRoomTableView.mj_footer.endRefreshing()
                    
                } else {
                    self.showRoomTableView.mj_header.endRefreshing()
                    self.showRoomTableView.mj_footer.endRefreshing()
                    print(info!)
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
    
    // MARK: - Setter
    lazy var showRoomTableView: WYPTableView = {
        let showRoomTableView = WYPTableView()
        showRoomTableView.rowHeight = 345 * width_height_ratio
        showRoomTableView.delegate = self
        showRoomTableView.dataSource = self
        showRoomTableView.tableFooterView = UIView()
        showRoomTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadShowRoomData(requestType: .loadMore)
        })
        showRoomTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadShowRoomData(requestType: .update)
        })
        //注册
        showRoomTableView.register(ShowroomCell.self, forCellReuseIdentifier: "showRoomCell")
        
        return showRoomTableView
    }()
    // 设置表视图头视图
    lazy var syBanner: SYBannerView = {
        let banner = SYBannerView(frame: CGRect(x: 0, y: 70, width: kScreen_width, height: 180 * width_height_ratio))
        banner.delegate = self
        return banner
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

extension ShowRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showRoomData?.count == 0 {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
        }
        return showRoomData?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "showRoomCell") as? ShowroomCell
        
        if cell == nil {
            cell = ShowroomCell.init(style: .default, reuseIdentifier: "showRoomCell")
        }
        cell?.selectionStyle = .none
        cell?.showRoomModel = showRoomData?[indexPath.row]
        // 判断是不是搜索页面
        if flag == 10 || flag == 2 {
            let attributeString = changeTextColor(text: cell?.showRoomTitleLabel.text ?? "")
            cell?.showRoomTitleLabel.attributedText = attributeString
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 跳转
        let showRoom = showRoomData?[indexPath.row]
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
}

extension ShowRoomViewController: SYBannerViewDelegate {
    
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
            showroomDetailsViewController.roomInfo?.isTicket = bannerData?[index].isTicket ?? 0
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

