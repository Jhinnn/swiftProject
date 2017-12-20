//
//  OrderDetailViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/8/7.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class OrderDetailViewController: BaseViewController {
    
    // 数据
    let dataSource = ["商品名称:","配送方式:","快递单号:","收货人:","联系电话:","收货地址:","处理时间:"]
    var orderInfo = [String]()
    // 订单Id
    var orderId: String?
    // 是否已确认收货
    var isConfirm: Bool? {
        willSet {
            if newValue == true {
                var image = UIImage(named: "common_grayBack_icon_normal_iPhone")
                image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode: .tile)
                OKButton.setBackgroundImage(image, for: .normal)
                OKButton.isEnabled = false
            } else {
                var image = UIImage(named: "common_backgroundColor_button_normal_iPhone")
                image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode: .tile)
                OKButton.setBackgroundImage(image, for: .normal)
                OKButton.isEnabled = true
            }
        }
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfig()
        loadOrderInfo()
    }

    // MARK: - private method
    func viewConfig() {
        view.addSubview(orderTableView)
        view.addSubview(OKButton)
        
        orderTableView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(view)
            make.height.equalTo(350)
        }
        
        
        OKButton.snp.makeConstraints { (make) in
            make.top.equalTo(orderTableView.snp.bottom).offset(60)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 180, height: 46))
        }
    }
    
    func loadOrderInfo() {
        NetRequest.orderDetailNetRequest(uid: AppInfo.shared.user?.userId ?? "", orderId: orderId ?? "") { (success, info, result) in
            if success {
                self.orderInfo.append(result?.value(forKey: "title") as! String)
                self.orderInfo.append(result?.value(forKey: "logistics") as! String)
                self.orderInfo.append(result?.value(forKey: "logistics_number") as! String)
                self.orderInfo.append(result?.value(forKey: "name") as! String)
                self.orderInfo.append(result?.value(forKey: "phone_number") as! String)
                let address = (result?.value(forKey: "region") as! String) + (result?.value(forKey: "address") as! String)
                self.orderInfo.append(address)
                self.orderInfo.append(result?.value(forKey: "update_time") as! String)
                
                self.orderTableView.reloadData()
            }
        }
    }
    
    // MARK: - event response
    func confirmReceip(sender: UIButton) {
        NetRequest.confirmReceiptNetRequest(orderId: orderId ?? "") { (success) in
            if success {
                SVProgressHUD.showSuccess(withStatus: "确认收货成功")
                self.navigationController?.popViewController(animated: true)
            } else {
                SVProgressHUD.showError(withStatus: "确认收货失败，请重试")
            }
            
        }
    }

    // MARK: - setter and getter
    lazy var orderTableView: UITableView = {
        let orderTableView = UITableView(frame: .zero, style: .plain)
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.rowHeight = 50
        orderTableView.bounces = false
        orderTableView.register(OrderDetailTableViewCell.self, forCellReuseIdentifier: "orderDetail")
        return orderTableView
    }()
    
    lazy var OKButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.setTitle("确认收货", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        var image = UIImage(named: "common_backgroundColor_button_normal_iPhone")
        image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode: .tile)
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(confirmReceip(sender:)), for: .touchUpInside)
        return button
    }()
}

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderDetail") as! OrderDetailTableViewCell
        cell.orderLabel.text = dataSource[indexPath.row]
        if orderInfo.count > 0 {
            cell.orderTextField.text = orderInfo[indexPath.row]
        }
        
        return cell
    }
}
