//
//  AppDelegate.swift
//  WYP
//
//  Created by 你个LB on 2017/2/24.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var startAdvData: BannerModel?
    
    // 控制屏幕是否自动旋转
    var blockRotation: Bool = false
    
    // 引导页
    lazy var guidePageWindow: UIWindow? = {
        let guidePageWindow = UIWindow(frame: UIScreen.main.bounds)
        guidePageWindow.backgroundColor = UIColor.clear
        guidePageWindow.windowLevel = UIWindowLevelStatusBar
        guidePageWindow.rootViewController = GuideViewController()
        return guidePageWindow
    }()
    
    // 是否支持横竖屏切换
    override func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if self.blockRotation {
            return UIInterfaceOrientationMask.all
        } else {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    // 注册通知
    func registerNotification(application: UIApplication) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                
            })
        } else if #available(iOS 8.0, *){
            let setting = UIUserNotificationSettings.init(types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(setting)
        } else {
            UIApplication.shared.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
    }
    // 程序启动时调用
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window?.backgroundColor = UIColor.themeColor
        
        // MARK: - 设置导航条样式
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor.themeColor
        UINavigationBar.appearance().isTranslucent = false
        let dict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18)]
        // 标题颜色
        UINavigationBar.appearance().titleTextAttributes = dict as? [String : AnyObject]
        
        // MARK: - 键盘样式/功能设置默认属性
        let manager = IQKeyboardManager.shared()
        //控制整个功能是否启用。
        manager.isEnabled = true;
        //控制点击背景是否收起键盘
        manager.shouldResignOnTouchOutside = true;
        //控制键盘上的工具条文字颜色是否用户自定义。  注意这个颜色是指textfile的tintcolor
        manager.shouldToolbarUsesTextFieldTintColor = false;
        //中间位置是否显示占位文字
        manager.shouldShowTextFieldPlaceholder = false;
        //设置占位文字的字体
        manager.placeholderFont = UIFont.boldSystemFont(ofSize: 17)
        //控制是否显示键盘上的工具条。
        manager.isEnableAutoToolbar = false;
        
        // MARK: - 弱提示设置默认属性
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        
        // MARK: - 开始获取定位信息
        LocationManager.shared.starUpdatingLocation()
        
        // MARK: - 添加开屏广告
        self.setupXHLaunchAd()
        
        // 注册推送
        registerNotification(application: application)
        
        // MARK: - 极光推送
        if application.applicationIconBadgeNumber == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationNumber"), object: nil)
        }

        
        if #available(iOS 10, *) {

            let entiity = JPUSHRegisterEntity()
            entiity.types = Int(UNAuthorizationOptions.alert.rawValue |
                UNAuthorizationOptions.badge.rawValue |
                UNAuthorizationOptions.sound.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entiity, delegate: self)
            
        } else if #available(iOS 8.0, *) {
            
            let types = UIUserNotificationType.badge.rawValue |
                UIUserNotificationType.sound.rawValue |
                UIUserNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: types, categories: nil)
            
        }else {
            let type = UIRemoteNotificationType.badge.rawValue |
                UIRemoteNotificationType.sound.rawValue |
                UIRemoteNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: type, categories: nil)
        }
        
        JPUSHService.setup(withOption: launchOptions,
                           appKey: JPushAppKey,
                           channel: "App Store",
                           apsForProduction: isProduction)

        // MARK: - 友盟
        UMSocialManager.default().openLog(true)
        //不清除缓存，用缓存的数据请求用户数据
        UMSocialGlobal.shareInstance().isClearCacheWhenGetUserInfo = true
        
        UMSocialManager.default().umSocialAppkey = UMengAppKey
        //设置微信的appKey和appSecret
        UMSocialManager.default().setPlaform(.wechatSession, appKey: WeChatAppKey, appSecret: WeChatAppSecret, redirectURL: "http://mobile.umeng.com/social")
        //设置QQ的appKey和appSecret
        UMSocialManager.default().setPlaform(.QQ, appKey: QQAppKey, appSecret: QQAppSecret, redirectURL: "http://mobile.umeng.com/social")
        //设置新浪微博的appKey和appSecret
        UMSocialManager.default().setPlaform(.sina, appKey: sinaAppKey, appSecret: sinaAppSecret, redirectURL: "http://mobile.umeng.com/social")
        
        // MARK: - 融云
        RCIM.shared().initWithAppKey(RCIMAppKey)
        //设置用户信息源和群组信息源
        RCIM.shared().userInfoDataSource = self
        RCIM.shared().groupInfoDataSource = self
        //设置接收消息代理
        RCIM.shared().receiveMessageDelegate = self
        RCIM.shared().globalNavigationBarTintColor = UIColor.white

        // 登录
        RCIM.shared().currentUserInfo = RCUserInfo(userId: AppInfo.shared.user?.userId ?? "1", name: AppInfo.shared.user?.nickName ?? "1", portrait: AppInfo.shared.user?.headImgUrl ?? "1")
        RCIM.shared().connect(withToken: AppInfo.shared.user?.rcToken ?? "", success: { (userId) in
            
        }, error: { (status) in
            
       
            
        }) { 
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            
        }
        
        /**
         * 推送处理1
         */
        // 统计推送打开率
        RCIMClient.shared().recordLaunchOptionsEvent(launchOptions)
        
        let pushServiceData = RCIMClient.shared().getPushExtra(fromLaunchOptions: launchOptions)
        if pushServiceData != nil {
            
            for (_, _) in pushServiceData! {
             
            }
        } else {
            
        }
        
        // MARK: - 版本号
        let isAlreadyRun = UserDefaults.standard.bool(forKey: versionString)
        guidePageWindow?.isHidden = isAlreadyRun
        if isAlreadyRun {
        } else {
            UserDefaults.standard.set(true, forKey: versionString)
        }
        
        return true
    }
    
    /**
     * 推送处理2
     */
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        // 注册推送
        application.registerForRemoteNotifications()
    }
    
    // App进入后台
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    // App将要进入前台
    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
        
        let token = deviceToken.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        
        RCIMClient.shared().setDeviceToken(token)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        JPUSHService.handleRemoteNotification(userInfo)
        RCIMClient.shared().recordRemoteNotificationEvent(userInfo)
        completionHandler(.newData)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // 获取极光推送的消息内容
        JPUSHService.handleRemoteNotification(userInfo)
        
        /**
         * 获取融云推送服务扩展字段
         * nil 表示该启动事件不包含来自融云的推送服务
         */
        RCIMClient.shared().recordRemoteNotificationEvent(userInfo)
        let pushServiceData = RCIMClient.shared().getPushExtra(fromRemoteNotification: userInfo)
        if pushServiceData != nil {
            
            for (_, _) in pushServiceData! {
        
            }
        } else {
            
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let result = UMSocialManager.default().handleOpen(url, options: options)
        if !result {
        }
        return result
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        
    }
}
 
 @available(iOS 10.0, *)
 extension AppDelegate : JPUSHRegisterDelegate{
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNAuthorizationOptions.alert.rawValue))// 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        let userInfo = response.notification.request.content.userInfo
  
        if userInfo["rc"] != nil {
            
        } else {
            if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
                JPUSHService.handleRemoteNotification(userInfo)
                goToNewsDetailViewController(message: userInfo as NSDictionary)
            }
        }
        
        completionHandler()
    }
 }

extension AppDelegate: RCIMUserInfoDataSource, RCIMGroupInfoDataSource, RCIMReceiveMessageDelegate {
    
    // 实现代理方法，获取用户信息
    func getGroupInfo(withGroupId groupId: String!, completion: ((RCGroup?) -> Void)!) {
        NetRequest.getGroupNameAndHeadImgUrlNetRequest(groupId: groupId) { (success, info, groupDic) in
            let group = RCGroup()
            group.groupName = groupDic?.object(forKey: "title") as? String
            group.portraitUri = groupDic?.object(forKey: "photo") as? String
            group.groupId = groupId
            
            completion(group)
        }
    }
    
    // 获取用户信息
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        
        let currentUserId = AppInfo.shared.user?.userId ?? ""
        if userId == currentUserId {
            let user = RCUserInfo()
            user.name = AppInfo.shared.user?.nickName
            user.portraitUri = AppInfo.shared.user?.headImgUrl
            user.userId = userId
            completion(user)
        } else {
            NetRequest.getUserNickNameAndHeadImgUrlNetRequest(userId: userId, complete: { (success, info, userDic) in
                if success {
                    let user = RCUserInfo()
                    user.name = userDic?.object(forKey: "nickname") as! String
                    user.userId = userId
                    user.portraitUri = userDic?.object(forKey: "avatar128") as! String
       
                    completion(user)
                } else {
                   
                }
            })
        }
    }
    
    func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        
    }

    func onRCIMCustomLocalNotification(_ message: RCMessage!, withSenderName senderName: String!) -> Bool {
       
        return false
    }
    
    func onRCIMCustomAlertSound(_ message: RCMessage!) -> Bool {
        return false
    }
    
    // 跳转资讯详情页面
    func goToNewsDetailViewController(message: NSDictionary) {
        // 解析json
        let aps = message.value(forKey: "aps") as? NSDictionary
        let info = aps?.value(forKey: "category") as? String
        
        if info == "gambit" {  //邀请话题
          
            let new_id = message.value(forKey: "news_id") as? String
            let talkNewVC = TalkNewsDetailsViewController()
            talkNewVC.newsId = new_id
            
            let navi = BaseNavigationController.init(rootViewController: talkNewVC)
            navi.isNotication = true
            
            self.window?.rootViewController?.present(navi, animated: true, completion: nil)
            
        }else {
            let arr = info?.components(separatedBy: "-")
            
            
            let category = arr?[0] ?? ""
            let newsId = arr?[1] ?? ""
            
            // 分类展示详情页面
            if category == "3" {
                // 图集
                NetRequest.getPhotoDeatilsNetRequest(photoId: newsId, complete: { (success, info, result) in
                    if success {
                        let newsData = InfoModel.deserialize(from: result)
                        UserDefaults.standard.set("PhotoPush", forKey: "PhotoPush")
                        let photos = NewsPhotosDetailViewController()
                        photos.newsId = newsData?.newsId
                        photos.newsTitle = newsData?.infoTitle
                        photos.isFollow = newsData?.isFollow
                        photos.imageArray = newsData?.infoImageArr
                        photos.contentArray = newsData?.contentArray
                        photos.commentNumber = newsData?.infoComment
                        photos.currentIndex = 0
                        photos.flag = 100
                        let navi = UINavigationController.init(rootViewController: photos)
                        self.window?.rootViewController?.present(navi, animated: true, completion: nil)
                    }
                })
            } else if category == "4" {
                // 视频
                UserDefaults.standard.set("VideoPush", forKey: "VideoPush")
                if newsId != "" {
                    let newsVC = VideoDetailViewController()
                    newsVC.newsId = newsId
                    newsVC.flag = 100
                    let navi = UINavigationController.init(rootViewController: newsVC)
                    self.window?.rootViewController?.present(navi, animated: true, completion: nil)
                }
            } else {
                // 普通资讯
                UserDefaults.standard.set("NewsPush", forKey: "NewsPush")
                if newsId != "" {
                    let newsVC = NewsDetailsViewController()
                    newsVC.newsId = newsId
                    let navi = UINavigationController.init(rootViewController: newsVC)
                    self.window?.rootViewController?.present(navi, animated: true, completion: nil)
                }
            }
        }
        
        
        
       
        
    }

    
 }
 
 


