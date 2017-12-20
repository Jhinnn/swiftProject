//
//  GeneralViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/5/9.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import Kingfisher

class GeneralViewController: BaseViewController {
    
    fileprivate let titleArray = ["禁止推送", "清除缓存"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "通用"
        
        setupUI()
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
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    // 设置tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = 55
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SetSystemCellIdentifier")
        
        return tableView
    }()
    
    // MARK: - IBActions
    func unAllowPush(sender: UISwitch) {
        print(sender.isOn)
        if sender.isOn {
            UIApplication.shared.registerForRemoteNotifications()
            sender.isOn = false
            
            // 允许通知
            let userDefault = UserDefaults.standard
            userDefault.set("0", forKey: "notification")
            
        } else {
            UIApplication.shared.unregisterForRemoteNotifications()
            sender.isOn = true
            
            // 禁止通知
            let userDefault = UserDefaults.standard
            userDefault.set("1", forKey: "notification")
        }
        
        
    }
    //计算缓存大小
    
    lazy var fileSizeOfCache: String = {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        //缓存目录路径
        print(cachePath ?? "")
        
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        
        //快速枚举出所有文件名 计算文件大小
        var size: Float = 0.0
        for file in fileArr! {
            
            // 把文件名拼接到路径中
            let path = cachePath?.appending("/\(file)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path!)
            // 用元组取出文件大小属性
            for (abc, bcd) in floder {
                // 累加文件大小
                if abc == FileAttributeKey.size {
                    print(abc)
                    print(bcd)
                    size += (bcd as! NSNumber).floatValue
                }
            }
        }
        
        let mm: Float = size / 1024 / 1024
        
        return String(format: "%.1f", mm)

    }()
    
    func clearCache() {
        
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        
        // 遍历删除
        for file in fileArr! {
            let path = cachePath?.appending("/\(file)")
            if FileManager.default.fileExists(atPath: path!) {
                do {
                    try FileManager.default.removeItem(atPath: path!)
                } catch {
                    
                }
            }
        }
    }
    
    // MARK: - Getter
    
    
    // MARK: - Setter
    
    
    // MARK: - UITableViewDataSource
    
    
    // MARK: - UITableViewDelegate
    
    
    // MARK: - Other Delegate
    
    
    // MARK: - NSCopying
}

extension GeneralViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "SetSystemCellIdentifier")
        // 设置标题
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.textColor = UIColor.init(hexColor: "#333333")
        if indexPath.row == 0 {
            let notificationSwitch = UISwitch(frame: CGRect(x: kScreen_width - 51 - 15, y: 15, width: 51, height: 31))
            notificationSwitch.onTintColor = UIColor.themeColor
            notificationSwitch.center.y = cell.contentView.center.y
            notificationSwitch.addTarget(self, action: #selector(unAllowPush(sender:)), for: .valueChanged)
            let notification = UserDefaults.standard.value(forKey: "notification") as? String
            if notification == "0" {
                notificationSwitch.isOn = false
            } else if notification == "1" {
                notificationSwitch.isOn = true
            }
            cell.contentView.addSubview(notificationSwitch)
        } else {
            cell.accessoryType = .disclosureIndicator
            
            let label = UILabel(frame: CGRect(x: kScreen_width - 80 - 30, y: 16.75, width: 80, height: 20))
            label.font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = .right
            label.text = "\(fileSizeOfCache)M"
            cell.contentView.addSubview(label)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12.5
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.vcBgColor
        return headerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath {
        case [0, 0]:
            // 禁止推送
            print("禁止推送")
        case [0, 1]:
            // 清除缓存
            let alert = UIAlertView(title: "清除缓存", message: "是否清除应用缓存", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alert.show()
            
        default:
            print("")
        }
    }
}

extension GeneralViewController: UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        print(buttonIndex)
        if buttonIndex == 1 {
            // 确定清除缓存
            clearCache()
            fileSizeOfCache = "0.0"
            tableView.reloadData()
        }
    }
}
