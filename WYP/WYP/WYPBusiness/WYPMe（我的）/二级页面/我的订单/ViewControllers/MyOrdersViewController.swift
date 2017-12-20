//
//  MyOrdersViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/21.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class MyOrdersViewController: BaseViewController {

    var orders: [OrdersModel]?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initBaseViewLayout()
        layoutPageSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadOrdersData(requestType: .update)
    }
    
    // MARK: - private method
    private func initBaseViewLayout() {
        self.title = "我的订单"
        view.addSubview(ordersTableView)
    }
    private func layoutPageSubviews() {
        ordersTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    func loadOrdersData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        NetRequest.myOrdersNetRequest(page: "\(pageNumber)", uid: AppInfo.shared.user?.userId ?? "") { (success, info, result) in
            if success {
                let array = result!.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                if requestType == .update {
                    self.orders = [OrdersModel].deserialize(from: jsonString) as? [OrdersModel]
                } else {
                    // 把新数据添加进去
                    let ordersArray = [OrdersModel].deserialize(from: jsonString) as? [OrdersModel]
                    
                    self.orders = self.orders! + ordersArray!
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
                
                self.ordersTableView.reloadData()
                self.ordersTableView.mj_header.endRefreshing()
                self.ordersTableView.mj_footer.endRefreshing()
            } else {
                self.ordersTableView.mj_header.endRefreshing()
                self.ordersTableView.mj_footer.endRefreshing()
            }
        }
    }
    
    // MARK: - event response
    func whenNoDataGoToTicket(sender: UIButton) {
        self.tabBarController?.selectedIndex = 3
        ticketsCurrentIndex = 1
    }
    
    // MARK: - setter and getter
    lazy var ordersTableView: UITableView = {
        let ordersTableView = UITableView(frame: .zero, style: .plain)
        ordersTableView.rowHeight = 170
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.tableFooterView = UIView()
        ordersTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadOrdersData(requestType: .loadMore)
        })
        ordersTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadOrdersData(requestType: .update)
        })
        //注册
        ordersTableView.register(MyOrdersTableViewCell.self, forCellReuseIdentifier: "ordersCell")
        
        return ordersTableView
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
    
}

extension MyOrdersViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orders?.count == 0 {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
            noDataButton.isHidden = false
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
            noDataButton.isHidden = true
        }
        return orders?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordersCell") as! MyOrdersTableViewCell
        if orders != nil {
            cell.orders = orders?[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if orders?[indexPath.row].currentStatus == 1 {
            SVProgressHUD.showInfo(withStatus: "请在出票后查看订单")
        } else if orders?[indexPath.row].currentStatus == 2 {
            let orderDetail = OrderDetailViewController()
            orderDetail.isConfirm = false
            orderDetail.orderId = orders?[indexPath.row].orderId ?? ""
            self.navigationController?.pushViewController(orderDetail, animated: true)
        } else if orders?[indexPath.row].currentStatus == 3 {
            let orderDetail = OrderDetailViewController()
            orderDetail.isConfirm = true
            orderDetail.orderId = orders?[indexPath.row].orderId ?? ""
            self.navigationController?.pushViewController(orderDetail, animated: true)
        }
        
    }
}
