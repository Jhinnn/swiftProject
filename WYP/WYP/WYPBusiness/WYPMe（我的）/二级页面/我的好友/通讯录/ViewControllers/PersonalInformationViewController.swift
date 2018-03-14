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

    var isFushFormTopic: Bool = false  //是否从话题页过来
    
    var gambit_cover: [String] = []
    var community_cover: [String] = []
    
    var uiSwitch: UISwitch?
    
    // 记录偏移量
    var navOffset: CGFloat = 0
    
    
    var personalModel: PersonalModel?
    
   
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
  

        self.title = "个人资料"
        self.view.backgroundColor = UIColor.init(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1)
        
    
    
        view.addSubview(self.tableView)
        bgView.addSubview(button)
        view.addSubview(bgView)
        
        if self.targetId == AppInfo.shared.user?.userId {  //如果是自己的社区
            
            bgView.isHidden = true
            if kScreen_height == 812 {
                tableView.frame = CGRect(x: 0, y: -88, width: kScreen_width, height: kScreen_height)
            }else{
                tableView.frame = CGRect(x: 0, y: -64, width: kScreen_width, height: kScreen_height)
            }
        }else {
            if kScreen_height == 812 {
                tableView.frame = CGRect(x: 0, y: -88, width: kScreen_width, height: kScreen_height - 70)
            }else{
                tableView.frame = CGRect(x: 0, y: -64, width: kScreen_width, height: kScreen_height - 64)
            }
            bgView.isHidden = false
        }
    
    }
    
    
    
    lazy var tableView :UITableView = {
        var tabView = UITableView()
        
        
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = UITableViewCellSeparatorStyle.none
        return tabView
    }()
    
    lazy var bgView: UIView = {
        var bgView = UIView()
        if kScreen_height == 812 {
            bgView.frame = CGRect(x: 0, y: kScreen_height - 158, width: kScreen_width, height: 60)
        }else{
            bgView.frame = CGRect(x: 0, y: kScreen_height - 124, width: kScreen_width, height: 60)
        }
        
        bgView.backgroundColor = UIColor.groupTableViewBackground
        return bgView
    }()
    
    lazy var button : UIButton = {
        let btn = UIButton(frame: CGRect(x: 20, y: 5, width: kScreen_width - 40, height: 50))
        btn.backgroundColor = UIColor.themeColor
        btn.layer.cornerRadius = 15
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(messageBAction(button:)), for: .touchUpInside)
        return btn
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

         netRequestAction()
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
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navBarBgAlpha = 1
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
        let cellid = "cellID"
        var cell = tableView.cellForRow(at: indexPath)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        switch indexPath.section {
        case 0:
            let headIV = UIImageView(image:UIImage(named:"grzy_porfile_bg"))
            headIV.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:220)
            cell?.addSubview(headIV)
            
            let circleIV = UIImageView()
            let avatarPath = URL(string: self.personalModel?.avatar ?? "")
            circleIV.kf.setImage(with: avatarPath)
            circleIV.frame = CGRect(x:15, y:220-248/6, width:248/3, height:248/3)
            circleIV.layer.cornerRadius = 248/6
            circleIV.clipsToBounds = true
            cell?.addSubview(circleIV)
            
            let label1 = UILabel(frame:CGRect(x:248/3+15+20, y:220-35, width:95, height:30))
            cell?.addSubview(label1)
            label1.layer.cornerRadius = 10
            label1.clipsToBounds = true
            label1.textColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            label1.font = UIFont.systemFont(ofSize: 17)
            label1.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.30)
            label1.text = self.name
            label1.textAlignment = .center
            
            
            let label2 = UILabel(frame:CGRect(x:248/3+15+30, y:220+5, width:180, height:30))
            label2.textColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            label2.font = UIFont.systemFont(ofSize: 15)
            label2.text = personalModel?.aldid
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
                if personalModel?.sex == "1"{
                    label2.text = "男"
                }else{
                    label2.text = "女"
                }
                
            }
            if indexPath.row == 1 {
                label1.text = "地址："
                label2.text = self.personalModel?.address
                let presonIV = UIImageView(image:UIImage(named:"datum_icon_Information_normalmore"))
                presonIV.frame = CGRect(x:15, y:15, width:20, height:20)
                cell?.addSubview(presonIV)
                let arrowIV = UIImageView(image:UIImage(named:"chat_icon_advance_normalmore"))
                arrowIV.frame = CGRect(x:UIScreen.main.bounds.size.width-50, y:15, width:10, height:20)
                cell?.addSubview(arrowIV)
            }
            if indexPath.row == 2 {
                label1.text = "签名："
                label2.text = self.personalModel?.signature
            }
            
        case 2:
            let circleIV = UIImageView(image:UIImage(named:"datum_icon_datum_icon_Information_normalmore_normalmore"))
            circleIV.frame = CGRect(x:15, y:45, width:20, height:20)
            cell?.addSubview(circleIV)
            let arrowIV = UIImageView(image:UIImage(named:"chat_icon_advance_normalmore"))
            arrowIV.frame = CGRect(x:UIScreen.main.bounds.size.width-50, y:45, width:10, height:20)
            cell?.addSubview(arrowIV)
            
            
            if self.community_cover.count != 0 {
                for index in 0..<self.community_cover.count{
                    switch index {
                    case 0:
                        let aIV = UIImageView()
                        let aUrl = URL(string: community_cover[index] )
                        aIV.kf.setImage(with: aUrl)
                        aIV.frame = CGRect(x:50, y:25, width:60, height:60)
                        cell?.addSubview(aIV)
                        
                        break
                    case 1:
                        let bIV = UIImageView()
                        let bUrl = URL(string: community_cover[index] )
                        bIV.kf.setImage(with: bUrl)
                        bIV.frame = CGRect(x:130, y:25, width:60, height:60)
                        cell?.addSubview(bIV)
                      break
                    case 2 :
                        let cIV = UIImageView()
                        let cUrl = URL(string: community_cover[index] )
                        cIV.kf.setImage(with: cUrl)
                        cIV.frame = CGRect(x:210, y:25, width:60, height:60)
                        cell?.addSubview(cIV)
                        break
                        
                    default :
                        print("无数据")
                  
                    }
                   
                }
                
            }
            
           
            
        case 3:
            let titleIV = UIImageView(image:UIImage(named:"0002"))
            titleIV.frame = CGRect(x:(UIScreen.main.bounds.size.width-550/3)/2, y:20, width:550/3, height:50/3)
            cell?.addSubview(titleIV)
            if self.gambit_cover.count != 0{
                for index in 0..<self.gambit_cover.count{
                    switch index{
                    case 0:
                        let aIV = UIImageView()
                        let aURl = URL(string: self.gambit_cover[index] )
                        aIV.kf.setImage(with: aURl)
                        aIV.frame = CGRect(x:15, y:50, width:60, height:60)
                        cell?.addSubview(aIV)
                        break
                        
                    case 1:
                        let bIV = UIImageView()
                        let bURl = URL(string: self.gambit_cover[index] )
                        bIV.kf.setImage(with: bURl)
                        bIV.frame = CGRect(x:95, y:50, width:60, height:60)
                        cell?.addSubview(bIV)
                    case 2:
                        let cIV = UIImageView()
                        let cURl = URL(string: self.gambit_cover[index] )
                        cIV.kf.setImage(with: cURl)
                        cIV.frame = CGRect(x:175, y:50, width:60, height:60)
                        cell?.addSubview(cIV)
                    default:
                         print("无数据")
                    }
                
                }
                
            }
     
        case 4:
            
            
            if !self.isFushFormTopic {  //是从话题界面push过来 则都不显示 聊天记录
                if self.personalModel?.isFollow == "1"  {
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
                        uiSwitch = UISwitch(frame: CGRect(x: UIScreen.main.bounds.size.width-80, y: 10, width: 51, height: 31))
                        uiSwitch?.onTintColor = UIColor.themeColor
                        if self.personalModel?.is_push == "1" && self.personalModel != nil {
                            uiSwitch?.setOn(true, animated: true)
                        }else {
                            uiSwitch?.setOn(false, animated: true)
                        }
    
                        uiSwitch?.addTarget(self, action: #selector(switchClick), for: .valueChanged)
                        cell?.addSubview(uiSwitch!)
                    }
                    
                }
            }
            
           
       
            
        default:
            print("")
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
        
        if indexPath.section == 2 {
            let commun = MyCommunityViewController()
            commun.userId = self.targetId
            commun.type = "2"
            commun.title = "个人社区"
            self.navigationController?.pushViewController(commun, animated: true)
        }
        if indexPath.section == 3 {
            let topicsView = TopicsViewController()
            topicsView.titleName = self.personalModel?.name
            topicsView.targId = self.targetId
            self.navigationController?.pushViewController(topicsView, animated: true)
        }
       
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
    
    
    // MARK: - 消息免打扰
    func switchClick(sender:UISwitch) {

        if !sender.isOn {
            //MARK: ---允许通知
            RCIMClient.shared().setConversationNotificationStatus(.ConversationType_PRIVATE, targetId: targetId, isBlocked: false, success: { (status) in
                
                NetRequest.ignoreFriendsMessageNetRequest(uid: self.targetId ?? "", complete: { (success, info, result) in
                    print("开启通知")
                })
                
                
            }) { (error) in
                print(error)
            }
            
        } else {

            //MARK: ---禁止通知
            RCIMClient.shared().setConversationNotificationStatus(.ConversationType_PRIVATE , targetId: targetId, isBlocked: true, success: { (status) in
                
                NetRequest.ignoreFriendsMessageNetRequest(uid: self.targetId ?? "", complete: { (success, info, result) in
                    print("关闭通知")
                })
                
            }) { (error) in
                print(error)
            }
        }
      
    }
    
    func messageBAction(button:UIButton) {
        
        if self.personalModel?.isFollow == "1" {
            let conversationVC = ChatDeatilViewController()
            conversationVC.conversationType = RCConversationType.ConversationType_PRIVATE
            conversationVC.targetId = self.targetId
            conversationVC.title = self.name
            conversationVC.flag = 11
            navigationController?.pushViewController(conversationVC, animated: true)
        }else {
            let vc = VerifyApplicationViewController()
            vc.applyMobile = self.personalModel?.mobile
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func moreAction() {
        var point = CGPoint.zero
        if deviceTypeIPhoneX() {
            point = CGPoint(x: kScreen_width - 30, y: 74)
        }else {
            point = CGPoint(x: kScreen_width - 30, y: 55)
        }
        let popupMenu = YBPopupMenu.show(at: point, titles: ["删除好友"], icons: nil, menuWidth: 100, delegate: self)
        popupMenu?.dismissOnSelected = true
        popupMenu?.type = .default
    }
    
    // MARK: --数据请求
    func netRequestAction(){
        NetRequest.requestMyhome(tarUId: self.targetId! ,muid: AppInfo.shared.user?.userId ?? "" ) { (success, info, result) in
            if success {
                let array = result
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                self.personalModel = PersonalModel.deserialize(from: jsonString)
                self.community_cover = (self.personalModel?.community_cover)!
                self.gambit_cover = (self.personalModel?.gambit_cover)!
                self.name = self.personalModel?.name
                
                self.tableView.reloadData()
                
                if self.personalModel?.isFollow == "1" {
                    self.button.setTitle("发消息", for: .normal)
                    let rightItem = UIBarButtonItem(title: "更多", style: .plain, target: self, action: #selector(self.moreAction))
                    self.navigationItem.rightBarButtonItem = rightItem
                }else {
                    self.button.setTitle("添加好友", for: .normal)
                }
    
            }else {
                SVProgressHUD.showError(withStatus: info)
            }
                
        }
    }

}

extension PersonalInformationViewController: YBPopupMenuDelegate {
    func ybPopupMenuDidSelected(at index: Int, ybPopupMenu: YBPopupMenu!) {
        if index == 0 {  //删除
            let alertController = UIAlertController(title: "",
                                                    message: "确定删除该好友？", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                action in
              
                NetRequest.peopleCancelAttentionNetRequest(openId: AppInfo.shared.user?.token ?? "", peopleId: self.targetId!, complete: { (success, result) in
                    if success {
                        SVProgressHUD.showSuccess(withStatus: "删除成功！")
                        let time: TimeInterval = 0.5
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                            self.navigationController?.popToRootViewController(animated: true)
                            
                        }
                    }
                })
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }else if index == 1 {  //修改备注
            
        }
        
    }
}

//更多
extension PersonalInformationViewController:LSXPopMenuDelegate{
    
    func lsxPopupMenuDidSelected(at index: Int, lsxPopupMenu LSXPopupMenu: LSXPopMenu!) {
      
    }
}

