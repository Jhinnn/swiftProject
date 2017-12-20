//
//  TicketShowNaviViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class TicketShowNaviViewController: TicketBaseNaviViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch title! {
        case "演出":
            classPid = "1"
            classId = ["","7","8","10","11","21","24","25"]
//            titles = ["全部","演唱会","音乐会","曲苑杂坛","舞蹈芭蕾","歌剧话剧"]
            titles = ["全部","秀","舞剧","话剧","歌剧","演唱会","舞台剧","音乐剧"]
            break
        case "旅游":
            classPid = "2"
            classId = ["","36","37","38","39","40","41","42"]
//            titles = ["全部","门票-身边景点","热门主题","定制游"]
            titles = ["全部","国家公园","奇特景点","水上乐园","主题乐园","家庭亲子","古镇园林","名胜风光"]
            break
        case "会展":
            classPid = "3"
            classId = ["","46","47","48","49","50"]
//            titles = ["全部","车展","婚博会","科技展","动漫","花博会"]
            titles = ["全部","车展","动漫","花博会","婚博会","科技展"]
            break
        case "赛事":
            classPid = "4"
            classId = ["","52","53","56","57","61","76","77"]
//            titles = ["全部","球类运动","搏击运动","冰上运动","水上运动","其他竞技"]
            titles = ["全部","篮球","足球","滑雪","滑冰","网球","水上排球","花样滑冰"]
            break
        case "电影":
            classPid = "5"
            classId = ["","80","81","82","83","84","85","86","87"]
//            titles = ["全部","战争犯罪","奇幻科幻","惊悚悬疑","动作","传记","动画","喜剧","爱情"]
            titles = ["全部","动作","传记","动画","喜剧","爱情","战争犯罪","奇幻科幻","惊悚悬疑"]
            break
        case "栏目":
            classPid = "6"
            classId = ["","89","90","91"]
//            titles = ["全部","新闻类节目","教育类节目","综艺类节目","电视剧","体育类","服务类节目"]
            titles = ["全部","选秀","晚会","真人秀"]
            break
        default:
            break
        }
        
        
        initControl()
        viewConfig()
        layoutPageSubviews()
    }
}
