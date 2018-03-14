//
//  WalletViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class CouponViewController: BaseViewController {
    
    // MARK: - Lifecycle
    
    var dataList = [CouponModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的钱包"
        
        setupUI()
        
        loadNetData(requestType: .update)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Public Methods
    
    
    // MARK: - Private Methods
    
    // 设置所有控件
    fileprivate func setupUI() {
        view.addSubview(tableView)
        
        setupUIFrame()
    }
    
    // 设置控件frame
    fileprivate func setupUIFrame() {
        // 设置tableView的布局
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    func loadNetData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.myCouponListNetRequest(page: "\(pageNumber)", token: AppInfo.shared.user?.token ?? "") { (success, info, dataArr) in
            if success {
                var models = [CouponModel]()
                for dic in dataArr! {
                    let coupon = CouponModel.deserialize(from: dic)
                    models.append(coupon!)
                }
                if requestType == .update {
                    self.dataList = models
                } else {
                    // 把新数据添加进去
                    self.dataList = self.dataList + models
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
                
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
            }
            
        }
    }
    
    // MARK: - setter and getter
    // 设置tableView WYPTableView
    lazy var tableView: WYPTableView = {
        let tableView = WYPTableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadNetData(requestType: .loadMore)
        })
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadNetData(requestType: .update)
        })
        tableView.rowHeight = 221
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CouponCellIdentifier")
        
        return tableView
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
        label.text = "暂无优惠券/兑换券"
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
    
    // MARK: - IBActions
    func whenNoDataGoToTicket(sender: UIButton) {
        self.tabBarController?.selectedIndex = 3
        ticketsCurrentIndex = 1
    }
    
    
}

extension CouponViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataList.count == 0 {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
            noDataButton.isHidden = false
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
            noDataButton.isHidden = true
        }
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = CouponCell(style: .default, reuseIdentifier: "CouponCellIdentifier")
        let coupon = dataList[indexPath.row]
        cell.coupon = coupon
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coupon = dataList[indexPath.row]
        if coupon.useStatus == "0" { // 未使用
            if coupon.type == "2" {
                // 兑换券
                let sb = UIStoryboard.init(name: "Main", bundle: nil)
                let goodsAdressVC = sb.instantiateViewController(withIdentifier: "GoodsAddressIdentity") as! GoodsAddressController
                let coupon: CouponModel = dataList[indexPath.row]
                goodsAdressVC.ticketTimeId = coupon.ticketTimeId ?? ""
                goodsAdressVC.typeId = "1"
                goodsAdressVC.walletId = coupon.id
                goodsAdressVC.invitationId = ""
                goodsAdressVC.flag = 2
                goodsAdressVC.ticketName = coupon.ticketName ?? ""
                navigationController?.pushViewController(goodsAdressVC, animated: true)
            } else {
                let useExplainVC = UseExplainViewController()
                navigationController?.pushViewController(useExplainVC, animated: true)
            }
        }
    }
}
