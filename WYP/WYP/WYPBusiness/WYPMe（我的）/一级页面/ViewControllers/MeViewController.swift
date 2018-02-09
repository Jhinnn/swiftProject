//
//  MeViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/2/24.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class MeViewController: UITableViewController {
    
    @IBOutlet weak var headImgView: UIButton!
    
    @IBOutlet weak var nickNameButton: UIButton!

    @IBOutlet weak var lvScoreButton: UIButton!
    
    @IBOutlet weak var levelButton: UIButton!
    
    @IBOutlet weak var communityButton: UIButton!
    
    @IBOutlet weak var myFriendsButton: SYButton!
    
    @IBOutlet weak var myAttentionButton: UIButton!
    
    @IBOutlet weak var myWalletButton: UIButton!
    
    // 未读消息数
    dynamic var RCnum: Int32 = 0
    // 监听是否有新消息
    var timer: Timer?
    // 是否添加观察者
    var isAddObserver = false
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSetAndNotification()
        
        self.myWalletButton.isExclusiveTouch = true
        self.myAttentionButton.isExclusiveTouch = true
        self.myFriendsButton.isExclusiveTouch = true
        self.communityButton.isExclusiveTouch = true
//        if let shadowView = navigationController?.navigationBar.value(forKey: "_shadowView") as? UIView {
//            shadowView.isHidden = true
//        }
        // 设置tabbar的title
        self.tabBarItem.title = "未登录"
        
        // 获取未读消息数
        myFriendsButton.badgeView.frame = CGRect(x: myFriendsButton.bounds.maxX - 20 , y: 15, width: 10, height: 10)
        myFriendsButton.addSubview(myFriendsButton.badgeView)
        myFriendsButton.badgeView.isHidden = true
        RCnum = RCIMClient.shared().getTotalUnreadCount()
        
        // 创建定时器
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getRCnumCount), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    deinit {
        if isAddObserver {
            self.removeObserver(self, forKeyPath: "RCnum")
            self.isAddObserver = false
        }
        timer?.invalidate()
        timer = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // 未读数
        self.addObserver(self, forKeyPath: "RCnum", options: NSKeyValueObservingOptions.new, context: nil)
        self.isAddObserver = true
        
        // 设置小圆点
        let num = UIApplication.shared.applicationIconBadgeNumber
        if num == 0 {
            notificationBarButtonItem.badgeView.isHidden = true
        } else {
            notificationBarButtonItem.badgeView.isHidden = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeNotoificationMessage), name: NSNotification.Name(rawValue: "notificationMessage"), object: nil)
        
        let placeholderImg = UIImage(named: "mine_header_icon_normal_iPhone")
        
        
        if AppInfo.shared.isLogin {
            // 已登录
            nickNameButton.isHidden = false
            lvScoreButton.isHidden = false
            levelButton.isHidden = false
            
            self.headImgView.kf.setImage(with: URL(string: AppInfo.shared.user?.headImgUrl ?? ""), for: .normal, placeholder: UIImage(named: "mine_header_icon_normal_iPhone"), options: nil, progressBlock: nil, completionHandler: nil)
            print("--------")
            print(AppInfo.shared.user?.token ?? "")
            print("--------")
            NetRequest.getUserInfoNetRequest(token: AppInfo.shared.user?.token ?? "", complete: { (success, info, userInfoDic) in
                if success {
                    // 获取成功
                    AppInfo.shared.user?.level = userInfoDic?["level"] as? String
                    AppInfo.shared.user?.lvScore = userInfoDic?["score1"] as? String
                    AppInfo.shared.user?.nickName = userInfoDic?["nickname"] as? String
                    
                    var dic = AppInfo.shared.user?.userInfo as! [String: Any]?
                    dic?.updateValue(userInfoDic?["level"] as! String, forKey: "level")
                    dic?.updateValue(userInfoDic?["score1"] as! String, forKey: "score")
                    dic?.updateValue(userInfoDic?["avatar"] as! String, forKey: "avatar")
                    dic?.updateValue(userInfoDic?["nickname"] as! String, forKey: "nickname")
                    AppInfo.shared.user?.userInfo = dic as NSDictionary?
                    
                    // 更新数据
                    self.nickNameButton.setTitle(AppInfo.shared.user?.nickName, for: .normal)
                    self.lvScoreButton.setTitle("我的积分:\(AppInfo.shared.user!.lvScore!)", for: .normal)
                    self.levelButton.setTitle("当前等级:\(AppInfo.shared.user!.level!)", for: .normal)

                } else {
                    // 获取失败

                }
            })
        }  else {
            // 未登录
            headImgView.setImage(placeholderImg, for: .normal)
            nickNameButton.isHidden = false
            lvScoreButton.isHidden = true
            levelButton.isHidden = true
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if RCnum == 0 {
            myFriendsButton.badgeView.isHidden = true
        } else {
            myFriendsButton.badgeView.isHidden = false
        }
    }
    
    // MARK: - event response
    // 设置设置按钮和通知按钮
    private func setupSetAndNotification() {
        let setBarButtonItem = UIBarButtonItem(image: UIImage(named: "mine_setting_button_normal_iPhone"), style: .done, target: self, action: #selector(setBarButtonItemAction))
        
        let notificationItem = UIBarButtonItem(customView: notificationBarButtonItem)
        
        navigationItem.rightBarButtonItems = [notificationItem, setBarButtonItem]
    }
    
    @IBAction func nickNameBtnAction(_ sender: UIButton) {
        
    }
    
    @IBAction func lvScoreButtonAction(_ sender: UIButton) {
        // 等级积分
        navigationController?.pushViewController(LevelViewController(), animated: true)
    }
    
    func setBarButtonItemAction() {
        // 系统设置
        navigationController?.pushViewController(SetSystemViewController(), animated: true)
    }
    
    func notificationBarButtonItemAction() {
        // 消息通知
        navigationController?.pushViewController(NotificationViewController(), animated: true)
    }
    // 清除小圆点
    func removeNotoificationMessage() {
        notificationBarButtonItem.badgeView.isHidden = true
    }
    
    // 延时1s才能点击
    func delayToEnable(sender: UIButton) {
        communityButton.isEnabled = true
    }
    
    @IBAction func myCommunityBtnAction(_ sender: UIButton) {
        
        var friendsArr = [PersonModel]()
        // 获取好友数
        NetRequest.friendsListNetRequest(openId: AppInfo.shared.user?.token ?? "", page: "") { (success, info, result) in
            if success {
                let array = result!.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                friendsArr = [PersonModel].deserialize(from: jsonString) as! [PersonModel]
                
                let community = MyCommunityViewController()
                community.title = "个人主页"
                community.headImageUrl = AppInfo.shared.user?.headImgUrl ?? ""
                community.userId = AppInfo.shared.user?.userId ?? ""
                community.nickName = AppInfo.shared.user?.nickName ?? ""
                community.fansCount = String.init(format: "粉丝:%@人", AppInfo.shared.user?.fans ?? "0")
                community.friendsCountLabel.text = String.init(format: "好友:%d人", friendsArr.count)
                community.type = "2"
//                community.userType = "200"
                community.isFollowed = false
                self.navigationController?.pushViewController(community, animated: true)
                
            } else {
                print(info!)
            }
        }
        
        sender.isEnabled = false
        self.perform(#selector(delayToEnable(sender:)), with: nil, afterDelay: 0.3)
    }
    
    func getRCnumCount() {
        RCnum = RCIMClient.shared().getTotalUnreadCount()
    }
    
    // MARK: - setter and getter
    lazy var notificationBarButtonItem: SYButton = {
        let notificationBarButtonItem = SYButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        notificationBarButtonItem.setImage(UIImage(named: "common_warning_button_normal_iPhone"), for: .normal)
        notificationBarButtonItem.badgeView.frame = CGRect(x: notificationBarButtonItem.bounds.maxX - 8 , y: 0, width: 10, height: 10)
        notificationBarButtonItem.addSubview(notificationBarButtonItem.badgeView)
        notificationBarButtonItem.badgeView.backgroundColor = UIColor.white
        notificationBarButtonItem.addTarget(self, action: #selector(notificationBarButtonItemAction), for: .touchUpInside)
        return notificationBarButtonItem
    }()
    
    lazy var qrView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height))
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenQrView))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var qrImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: (kScreen_width - 240)/2, y: (kScreen_height - 240)/2 - 80, width: 240, height: 240))
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        let userId = AppInfo.shared.user?.userId ?? ""
        let intUserId = Int(userId)! + 100000
        let str = String.init(format: "chat,%d", intUserId)
        let image:UIImage = self.creatCIQRCodeImage(formdata: str, imageWidth: 240)
        imageView.image = image
        return imageView
    }()
    
    func hiddenQrView() {
        qrView.removeFromSuperview()
    }
    
    //生成二维码
    func creatCIQRCodeImage(formdata:String,imageWidth:CGFloat) -> UIImage {
        //创建一个二维码的滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        
        // 恢复滤镜的默认属性
        qrFilter?.setDefaults()
        
        // 将字符串转换成
        let infoData =  formdata.data(using: .utf8)
        
        // 通过KVC设置滤镜inputMessage数据
        qrFilter?.setValue(infoData, forKey: "inputMessage")
        
        // 获得滤镜输出的图像
        let  outputImage = qrFilter?.outputImage
        
        // 设置缩放比例
        let scale = imageWidth / outputImage!.extent.size.width;
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let transformImage = qrFilter!.outputImage!.applying(transform)
        
        // 获取Image
        let image = UIImage(ciImage: transformImage)
        
        /*
         // 无logo时  返回普通二维码image
         //        guard let QRCodeLogo = logo else { return image }
         
         // logo尺寸与frame
         let logoWidth = image.size.width/4
         let logoFrame = CGRect(x: (image.size.width - logoWidth) /  2, y: (image.size.width - logoWidth) / 2, width: logoWidth, height: logoWidth)
         */
        // 绘制二维码
        UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.main.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        /*
         // 绘制中间logo
         QRCodeLogo.draw(in: logoFrame)
         */
        //返回带有logo的二维码
        let QRCodeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return QRCodeImage!
    }
    
    // MARK: - tableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0{
            
            UIView.animate(withDuration: 1, animations: {
                self.qrView.addSubview(self.qrImageView)
                self.view.addSubview(self.qrView)
            })
            
           
            
//             self.navigationController?.pushViewController(QRCodeViewController(), animated: true)
        }else if indexPath.section == 2 && indexPath.row == 0 {
        
                let topicVC = TopicsViewController()
                topicVC.targId = AppInfo.shared.user?.userId
                print(AppInfo.shared.user?.userId ?? "")
                self.navigationController?.pushViewController(topicVC, animated: true)
        }
        else if indexPath.section == 3 && indexPath.row == 0 {
            
            // 客服中心
            navigationController?.pushViewController(ServiceCenterViewController(), animated: true)
        } else if indexPath.section == 3 && indexPath.row == 2 {
            // 申请入驻
            navigationController?.pushViewController(ApplyToEnterViewController(), animated: true)
        }
        
    }
    
}
