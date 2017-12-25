//
//  PersonalInformationViewController.swift
//  WYP
//
//  Created by lym on 2017/12/13.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class PersonalInformationViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var targetId: String?
    var conversationType: Int?
    var name: String?
    
    // 记录偏移量
    var navOffset: CGFloat = 0
    
    var tableView: UITableView!
    
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "个人资料"
        self.view.backgroundColor = UIColor.init(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1)
        
        self.tableView = UITableView.init(frame: CGRect(x:0, y:-64, width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height-70), style: UITableViewStyle.plain)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(tableView)
        
        let rightItem = UIBarButtonItem(title: "更多", style: .plain, target: self, action: #selector(moreAction))
        self.navigationItem.rightBarButtonItem = rightItem
        
        let messageB = UIButton(frame:CGRect(x:50, y:UIScreen.main.bounds.size.height-60-70, width:UIScreen.main.bounds.size.width-100, height:50))
        messageB.backgroundColor = UIColor.themeColor
        messageB.layer.cornerRadius = 15
        messageB.clipsToBounds = true
        messageB.setTitle("发消息", for: UIControlState.normal)
        messageB.addTarget(self, action: #selector(messageBAction(button:)), for: .touchUpInside)
        self.view.addSubview(messageB)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 设置导航条透明度
        DispatchQueue.main.async {
            self.navBarBgAlpha = self.navOffset
            if self.navOffset == 0 {
                self.navigationController?.navigationBar.subviews.first?.alpha = 0
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.subviews.first?.alpha = 1
    }
    
    // MARK: - tableView代理方法
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 1:
            return 3
        case 4:
            return 2
            
        default:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let cellid = "cellID" + String.init(format: "%.2f", indexPath.section) + String.init(format: "%.2f", indexPath.row)
        let cellid = "cellID"
        var cell = tableView.cellForRow(at: indexPath)
        //        var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        switch indexPath.section {
        case 0:
            let headIV = UIImageView(image:UIImage(named:"grzy_porfile_bg"))
            headIV.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:260)
            cell?.addSubview(headIV)
            
            let circleIV = UIImageView(image:UIImage(named:"0001"))
            circleIV.frame = CGRect(x:15, y:260-248/6, width:248/3, height:248/3)
            circleIV.layer.cornerRadius = 248/6
            circleIV.clipsToBounds = true
            cell?.addSubview(circleIV)
            
            let label1 = UILabel(frame:CGRect(x:248/3+15+20, y:260-35, width:90, height:30))
            label1.layer.cornerRadius = 10
            label1.clipsToBounds = true
            label1.textColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            label1.font = UIFont.systemFont(ofSize: 17)
            label1.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.30)
            label1.text = self.name
            label1.textAlignment = .center
            cell?.addSubview(label1)
            
            let label2 = UILabel(frame:CGRect(x:248/3+15+20, y:260+5, width:180, height:30))
            label2.textColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            label2.font = UIFont.systemFont(ofSize: 15)
            label2.text = "15011142323"
            cell?.addSubview(label2)
            
        case 1:
            let label1 = UILabel(frame:CGRect(x:50, y:0, width:60, height:50))
            label1.textColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            label1.font = UIFont.systemFont(ofSize: 15)
            cell?.addSubview(label1)
            let label2 = UILabel(frame:CGRect(x:110, y:0, width:180, height:50))
            label2.textColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
            label2.font = UIFont.systemFont(ofSize: 15)
            cell?.addSubview(label2)
            if indexPath.row == 0 {
                label1.text = "性别："
                label2.text = "男"
            }
            if indexPath.row == 1 {
                label1.text = "地址："
                label2.text = "北京市海淀区"
                let presonIV = UIImageView(image:UIImage(named:"datum_icon_Information_normalmore"))
                presonIV.frame = CGRect(x:15, y:15, width:20, height:20)
                cell?.addSubview(presonIV)
                let arrowIV = UIImageView(image:UIImage(named:"chat_icon_advance_normalmore"))
                arrowIV.frame = CGRect(x:UIScreen.main.bounds.size.width-50, y:15, width:10, height:20)
                cell?.addSubview(arrowIV)
            }
            if indexPath.row == 2 {
                label1.text = "签名："
                label2.text = "欲望就该像匹野马"
            }
            
        case 2:
            let circleIV = UIImageView(image:UIImage(named:"datum_icon_datum_icon_Information_normalmore_normalmore"))
            circleIV.frame = CGRect(x:15, y:45, width:20, height:20)
            cell?.addSubview(circleIV)
            let arrowIV = UIImageView(image:UIImage(named:"chat_icon_advance_normalmore"))
            arrowIV.frame = CGRect(x:UIScreen.main.bounds.size.width-50, y:45, width:10, height:20)
            cell?.addSubview(arrowIV)
            
            let aIV = UIImageView(image:UIImage(named:"0001"))
            aIV.frame = CGRect(x:50, y:25, width:60, height:60)
            cell?.addSubview(aIV)
            let bIV = UIImageView(image:UIImage(named:"0001"))
            bIV.frame = CGRect(x:130, y:25, width:60, height:60)
            cell?.addSubview(bIV)
            let cIV = UIImageView(image:UIImage(named:"0001"))
            cIV.frame = CGRect(x:210, y:25, width:60, height:60)
            cell?.addSubview(cIV)
            
        case 3:
            let titleIV = UIImageView(image:UIImage(named:"0002"))
            titleIV.frame = CGRect(x:(UIScreen.main.bounds.size.width-550/3)/2, y:20, width:550/3, height:50/3)
            cell?.addSubview(titleIV)
            
            let aIV = UIImageView(image:UIImage(named:"0001"))
            aIV.frame = CGRect(x:15, y:50, width:60, height:60)
            cell?.addSubview(aIV)
            let bIV = UIImageView(image:UIImage(named:"0001"))
            bIV.frame = CGRect(x:95, y:50, width:60, height:60)
            cell?.addSubview(bIV)
            
        case 4:
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell?.textLabel?.textColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            if indexPath.row == 0 {
                cell?.textLabel?.text = "查找聊天记录"
                let arrowIV = UIImageView(image:UIImage(named:"chat_icon_advance_normalmore"))
                arrowIV.frame = CGRect(x:UIScreen.main.bounds.size.width-50, y:15, width:10, height:20)
                cell?.addSubview(arrowIV)
                
            }
            if indexPath.row == 1 {
                cell?.textLabel?.text = "消息免打扰"
                let uiSwitch = UISwitch(frame: CGRect(x: UIScreen.main.bounds.size.width-80, y: 10, width: 51, height: 31))
                uiSwitch.setOn(false, animated: true)
                uiSwitch.addTarget(self, action: #selector(switchClick), for: .valueChanged)
                cell?.addSubview(uiSwitch)
            }
            
            
            
            
        default:
            print("fdfd")
        }
        
        
        
        
        return cell!
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 310
        case 2:
            return 110
        case 3:
            return 130
            
        default:
            return 50
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell点击事件")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 0.1
        case 1:
            return 1
        case 2:
            return 5
        case 3:
            return 5
            
        default:
            return 1
        }
        
        
    }
    
    
    // MARK: - scrollView代理方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        self.navOffset = scrollView.contentOffset.y / 200
        self.navBarBgAlpha = self.navOffset
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - 自定义方法
    func switchClick(uiSwitch:UISwitch) {
        
        if uiSwitch.isOn {
            print("打开")
        }else {
            print("关闭")
        }
    }
    
    func messageBAction(button:UIButton) {
        print("发消息")
        let conversationVC = ChatDeatilViewController()
        conversationVC.conversationType = RCConversationType(rawValue: UInt(self.conversationType!))!
        conversationVC.targetId = self.targetId
        conversationVC.title = self.name
        conversationVC.flag = 11
        navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    func moreAction() {
        print("更多")
        let x = UIScreen.main.bounds.size.width - 10 - 100
        let y = CGFloat(78)
        let p = CGPoint(x: x, y: y)
        LSXPopMenu.show(at: p, titles: ["删除好友", "修改备注", "推荐名片"], icons: ["", "", ""], menuWidth: 150, isShowTriangle: false, delegate: self as LSXPopMenuDelegate)
    }
    
   
    
    
    
}

//更多
extension PersonalInformationViewController:LSXPopMenuDelegate{
    
    func lsxPopupMenuDidSelected(at index: Int, lsxPopupMenu LSXPopupMenu: LSXPopMenu!) {
        print(index)
        if index == 0 {
            
        }else if index == 1 {
            
        }else {
            
        }
    }
}
