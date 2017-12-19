//
//  AppDelegate+Extension.swift
//  WYP
//
//  Created by 你个LB on 2017/3/21.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import Foundation

extension AppDelegate: XHLaunchAdDelegate {
    
    public func setupXHLaunchAd() {
        loadData()
    }
    
    // 加载本地图片广告
    public func loadData() {
        
        
        // 设置需要添加的子视图(可选)
        //    imageAdconfiguration.subViews =
        
        XHLaunchAd.setWaitDataDuration(5)
        
        NetRequest.startAdv { (success, info, result) in
            if success {
                let array = result!.value(forKey: "banner")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                let bannerData = [BannerModel].deserialize(from: jsonString) as? [BannerModel]
                self.startAdvData = bannerData?[0]
        
                // 配置广告数据
                let imageAdconfiguration = XHLaunchImageAdConfiguration()
                
                // 广告停留时间
                imageAdconfiguration.duration = 5
                
                // 广告的frame
                if deviceTypeIPhone4() {
                    imageAdconfiguration.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_width / 1242*1242)
                } else {
                    imageAdconfiguration.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_width / 1242*1786)
                }
                
                // 广告图片URLString或本地图片名(.jpg/.gif请带上后缀)
                imageAdconfiguration.imageNameOrURLString = self.startAdvData?.bannerImage != "" ? self.startAdvData!.bannerImage! : "image1.jpg"
    
                // 缓存机制(仅对网络图片有效)
                imageAdconfiguration.imageOption = .refreshCached
                
                // 图片填充模式
                imageAdconfiguration.contentMode = .scaleAspectFill
                
                // 广告点击打开链接
                imageAdconfiguration.openURLString = ""
                
                // 广告显示完成动画
                imageAdconfiguration.showFinishAnimate = .fadein
                
                // 跳过按钮类型
                imageAdconfiguration.skipButtonType = .timeText;
                
                // 后台返回时，是否显示广告
                imageAdconfiguration.showEnterForeground = false
                
                // 显示开屏广告
                XHLaunchAd.imageAd(with: imageAdconfiguration, delegate: self)
            }
        }
    }
    
    func xhLaunchAd(_ launchAd: XHLaunchAd, clickAndOpenURLString openURLString: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startAdv"), object: nil)
    }
    
    func xhLaunchAd(_ launchAd: XHLaunchAd, imageDownLoadFinish image: UIImage) {
        
    }
    
}
