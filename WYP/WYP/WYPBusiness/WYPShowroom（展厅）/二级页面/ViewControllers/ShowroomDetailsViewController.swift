//
//  ShowroomDetailsViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/4/5.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import Alamofire

class ShowroomDetailsViewController: UITableViewController {
    
    // 刷新加载
    enum RoomRequestType {
        case update
        case loadMore
    }
    // 加载页数
    var pageNum: Int = 1
    
    // 封面图片
    @IBOutlet weak var headImgView: UIImageView!
    
    @IBOutlet weak var headScrollView: UIScrollView!
    // 关注按钮
    @IBOutlet weak var followButton: UIButton!
    
    // 项目标题
    @IBOutlet weak var projectTitleLabel: UILabel!

    // 演出单位
    @IBOutlet weak var showCompanyLabel: UILabel!
    
    // 导演
    @IBOutlet weak var directorLabel: UILabel!
    
    // 制作人
    @IBOutlet weak var producerLabel: UILabel!
    
    // 项目类型
    @IBOutlet weak var projectTypeLabel: UILabel!
    
    // 首演时间
    @IBOutlet weak var firstShowTimeLabel: UILabel!
    
    // 时长
    @IBOutlet weak var lengthLabel: UILabel!
    
    // 国家
    @IBOutlet weak var countryLabel: UILabel!
    // 项目认证
    @IBOutlet weak var projectButton: UIButton!
    // 企业认证
    @IBOutlet weak var companyButton: UIButton!
    
    
    // 免费的相关属性
    @IBOutlet weak var firstLineTitle: UILabel!
    @IBOutlet weak var secondLineTitle: UILabel!
    @IBOutlet weak var thirdLineTitle: UILabel!
    @IBOutlet weak var fourthLineTitle: UILabel!
    
    // MARK: - 约束
    @IBOutlet weak var firstTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var fourthTopConstraint: NSLayoutConstraint!
    
    // 付费约束
    @IBOutlet weak var firstLineWidth: NSLayoutConstraint!
    @IBOutlet weak var secondLineWidth: NSLayoutConstraint!
    @IBOutlet weak var thirdLineWidth: NSLayoutConstraint!
    
    
    
    // 单元格的高度
    var descriptionCellHeight: CGFloat = 160
    
    // 缩放封面的放大图
    var scrollView:UIScrollView?
    var lastImageView:UIImageView?
    var originalFrame:CGRect!
    var isDoubleTap:ObjCBool!
    
    // 当前展厅是否是免费
    var isFree: Bool!
    // 是否关联票务
    var isTicket: Int?
    // 展厅id
    var roomId: String?
    // 分类Id
    var typeId: Int!
    // 分组标题
    lazy var sectionTitleArray: [String] = {
        let sectionTitleArray = ["", "", "媒体库", "群组", "项目成员", "最新动态", "申请入驻", "最近评论"]
        return sectionTitleArray
    }()
    lazy var moreTitleArray: [String] = {
        let moreTitleArray = ["", "", "", "", "", "", "建立展厅", ""]
        return moreTitleArray
    }()
    // headerView的数据
    var roomInfo: RoomInfoModel? {
        willSet {
            var imageUrl: URL?
            if isFree {
                imageUrl = URL(string: newValue?.logo ?? "")
                self.headImgView.kf.setImage(with: imageUrl)
            } else {
                imageUrl = URL(string: newValue?.background ?? "")
                self.headAImageView.kf.setImage(with: imageUrl)
            }
    
            self.projectTitleLabel.text = newValue?.title ?? ""
            self.followButton.setTitle("  \(newValue?.followedCount ?? "")人", for: .normal)
            if newValue?.isLike == 1 {
                followButton.isSelected = true
            }
            if newValue?.isProject == 1 {
                projectButton.isSelected = true
            }
            if newValue?.isCommpany == 1 {
                companyButton.isSelected = true
            }
            self.typeId = newValue?.typeId
            self.isTicket = newValue?.isTicket
        }
    }
    // 属性数据
    var attribution: AttributionModel? {
        willSet {
            switch typeId {
            case 1: // 演出
                if isFree {
                    self.firstLineTitle.text = String.init(format: "导演：%@", newValue?.second ?? "")
                    self.secondLineTitle.text = String.init(format: "制作人：%@", newValue?.third ?? "")
                    if newValue?.fourth == "00" {
                        self.thirdLineTitle.text = String.init(format: "%@ | 不详", newValue?.playType ?? "")
                    } else {
                        self.thirdLineTitle.text = String.init(format: "%@ | %@分钟", newValue?.playType ?? "", newValue?.fourth ?? "")
                    }
                    self.fourthLineTitle.text = String.init(format: "首演时间：%@ | 国家：%@", newValue?.fifth ?? "" , newValue?.sixth ?? "")
                } else {
                    self.showCompanyLabel.text = String.init(format: "演出单位：%@", newValue?.first ?? "")
                    self.directorLabel.text = String.init(format: "导演：%@", newValue?.second ?? "")
                    self.producerLabel.text = String.init(format: "剧目类型：%@", newValue?.playType ?? "")
                    self.lengthLabel.text = String.init(format: "剧长：%@分钟", newValue?.fourth ?? "")
                    self.firstShowTimeLabel.text = String.init(format: "制作人：%@", newValue?.third ?? "")
                    self.countryLabel.text = String.init(format: "国家：%@", newValue?.sixth ?? "")
                    self.projectTypeLabel.text = String.init(format: "首演时间：%@", newValue?.fifth ?? "")
                }
                
                
            case 2: // 旅游
                if isFree {
                    self.firstLineTitle.text = String.init(format: "所属地区：%@", newValue?.second ?? "")
                    self.secondLineTitle.text = String.init(format: "开放(开团)时间：%@", newValue?.third ?? "")
                    self.thirdLineTitle.text = String.init(format: "类型：%@", newValue?.playType ?? "")
                    // 约束设置
                    self.firstTopConstraint.constant = 25
                    self.secondTopConstraint.constant = 18
                    self.thirdTopConstraint.constant = 18
                    
                } else {
                    self.showCompanyLabel.text = String.init(format: "运营商：%@", newValue?.first ?? "")
                    self.directorLabel.text = String.init(format: "所属地区：%@", newValue?.second ?? "")
                    self.producerLabel.text = String.init(format: "开放(开团)时间：%@", newValue?.third ?? "")
                    self.projectTypeLabel.text = String.init(format: "类型：%@", newValue?.playType ?? "")
                    // 约束设置
                    self.firstLineWidth.constant = -200
                    self.secondLineWidth.constant = -200
                    self.thirdLineWidth.constant = -200
                }
                
            case 3: // 会展
                if isFree {
                    self.firstLineTitle.text = String.init(format: "所在地区：%@", newValue?.second ?? "")
                    self.secondLineTitle.text = String.init(format: "展览日期：%@", newValue?.third ?? "")
                    self.thirdLineTitle.text = String.init(format: "展览场馆：%@", newValue?.fourth ?? "")
                    self.fourthLineTitle.text = String.init(format: "类型：%@", newValue?.playType ?? "")
                } else {
                    self.showCompanyLabel.text = String.init(format: "主办机构：%@", newValue?.first ?? "")
                    self.directorLabel.text = String.init(format: "所在地区：%@", newValue?.second ?? "")
                    self.producerLabel.text = String.init(format: "展览日期：%@", newValue?.third ?? "")
                    self.lengthLabel.text = String.init(format: "类型：%@", newValue?.playType ?? "")
                    self.firstShowTimeLabel.text = String.init(format: "展览场馆：%@", newValue?.fourth ?? "")
                }
                
            case 5: // 电影
                if isFree {
                    self.firstLineTitle.text = String.init(format: "导演：%@", newValue?.second ?? "")
                    self.secondLineTitle.text = String.init(format: "主演：%@", newValue?.third ?? "")
                    if newValue?.fourth == "没有" {
                        self.thirdLineTitle.text = String.init(format: "%@ | 不详", newValue?.playType ?? "")
                    } else {
                        self.thirdLineTitle.text = String.init(format: "%@ | %@分钟", newValue?.playType ?? "", newValue?.fourth ?? "")
                    }
                    self.fourthLineTitle.text = String.init(format: "首演时间：%@ | 国家：%@", newValue?.fifth ?? "" , newValue?.sixth ?? "")
                } else {
                    self.showCompanyLabel.text = String.init(format: "出品方：%@", newValue?.first ?? "")
                    self.directorLabel.text = String.init(format: "导演：%@", newValue?.second ?? "")
                    self.producerLabel.text = String.init(format: "主演：%@", newValue?.third ?? "")
                    self.lengthLabel.text = String.init(format: "影片时长：%@分钟", newValue?.fourth ?? "")
                    self.firstShowTimeLabel.text = String.init(format: "首演时间：%@", newValue?.fifth ?? "")
                    self.countryLabel.text = String.init(format: "国家：%@", newValue?.sixth ?? "")
                    self.projectTypeLabel.text = String.init(format: "影片类型：%@", newValue?.playType ?? "")
                }
                
            case 4: // 赛事
                if isFree {
                    self.firstLineTitle.text = String.init(format: "比赛时间：%@", newValue?.second ?? "")
                    self.secondLineTitle.text = String.init(format: "赛事类型：%@", newValue?.playType ?? "")
                    self.thirdLineTitle.text = String.init(format: "比赛场馆：%@", newValue?.third ?? "")
                    // 约束设置
                    self.firstTopConstraint.constant = 25
                    self.secondTopConstraint.constant = 18
                    self.thirdTopConstraint.constant = 18
                } else {
                    self.showCompanyLabel.text = String.init(format: "主办方：%@", newValue?.first ?? "")
                    self.directorLabel.text = String.init(format: "比赛时间：%@", newValue?.second ?? "")
                    self.producerLabel.text = String.init(format: "比赛场馆：%@", newValue?.third ?? "")
                    self.projectTypeLabel.text = String.init(format: "赛事类型：%@", newValue?.playType ?? "")
                    // 约束设置
                    self.firstLineWidth.constant = -200
                    self.secondLineWidth.constant = -200
                    self.thirdLineWidth.constant = -200
                }
                
            case 6: // 栏目
                if isFree {
                    self.firstLineTitle.text = String.init(format: "栏目类型：%@", newValue?.playType ?? "")
                    self.secondLineTitle.text = String.init(format: "播出时间：%@", newValue?.second ?? "")
                    self.thirdLineTitle.text = String.init(format: "播出频道：%@", newValue?.third ?? "")
                    // 约束设置
                    self.firstTopConstraint.constant = 25
                    self.secondTopConstraint.constant = 18
                    self.thirdTopConstraint.constant = 18
                } else {
                    self.showCompanyLabel.text = String.init(format: "栏目出品：%@", newValue?.first ?? "")
                    self.directorLabel.text = String.init(format: "栏目类型：%@", newValue?.playType ?? "")
                    self.producerLabel.text = String.init(format: "播出时间：%@", newValue?.second ?? "")
                    self.projectTypeLabel.text = String.init(format: "播出频道：%@", newValue?.third ?? "")
                    // 约束设置
                    self.firstLineWidth.constant = -200
                    self.secondLineWidth.constant = -200
                    self.thirdLineWidth.constant = -200
                }
            default:
                break
            }
        }
    }
    // 所有数据
    var showRoomDetailData: ShowRoomDetailModel?
    // 媒体库数据源
    var mediaData: [MediaModel]?
    
    //  MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "展厅详情"
        
        if !isFree {
            viewConfig()
        }
        
        self.tableView.register(OnePictureTableViewCell.self, forCellReuseIdentifier: "onePicCell")
        self.tableView.register(TravelTableViewCell.self, forCellReuseIdentifier: "textCell")
        self.tableView.register(ThreePictureTableViewCell.self, forCellReuseIdentifier: "threeCell")
        self.tableView.register(VideoInfoTableViewCell.self, forCellReuseIdentifier: "videoCell")
        
        self.tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadShowRoomDetailData(requestType: .loadMore)
        })
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadShowRoomDetailData(requestType: .update)
        })

        
        if !isFree {
            // 如果不是免费展厅
            tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: 355 * width_height_ratio)
        }
    
        // 放大封面图
        if isFree && roomInfo?.logo != "" {
            let tap = UITapGestureRecognizer(target: self, action: #selector(clickHeadImageView(tap:)))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            headImgView.isUserInteractionEnabled = true
            headImgView.addGestureRecognizer(tap)
            headImgView.clipsToBounds = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = false
        
        if isFree {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
//            navigationController?.navigationBar.barTintColor = UIColor.white
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "tj_icon_fxh_normal"), style: .done, target: self, action: #selector(shareBarButtonItemAction))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "tj_icon_fxh_normal"), style: .done, target: self, action: #selector(shareBarButtonItemAction))
        }
        loadShowRoomDetailData(requestType: .update)
        headAImageView.startAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 判断是否关联票务 08/01 修改为一直显示抢票按钮，将判断加载点击事件中
        self.tableView.window?.addSubview(bottomView)
        self.tableView.window?.bringSubview(toFront: bottomView)
        bottomView.addSubview(lotteryBtn)
            
        lotteryBtn.snp.makeConstraints { (make) in
            make.left.equalTo(bottomView).offset(13)
            make.right.equalTo(bottomView).offset(-13)
            make.bottom.equalTo(bottomView).offset(-9)
            make.height.equalTo(46)
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barTintColor = UIColor.themeColor
        
        bottomView.removeFromSuperview()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isFree {
            return .default
        } else {
            return .lightContent
        }
    }
    
    func viewConfig() {
        headScrollView.contentSize = CGSize(width: kScreen_width, height: 220 * width_height_ratio)
        headScrollView.isScrollEnabled = false
        headScrollView.addSubview(headAImageView)
        headAImageView.startAnimation()
    }
    
    // 动画图片
    lazy var headAImageView: KImageViewAnimation = {
        let headAImageView = KImageViewAnimation(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 220 * width_height_ratio))
        return headAImageView
    }()
    
    // 返回按钮
    lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 13.5)
        backButton.setImage(UIImage(named: "chat_icon_return_normalmore"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        return backButton
    }()
    
    lazy var bottomView: UIView = {
        let bottomView = UIView(frame: CGRect(x: 0, y: kScreen_height - 60, width: kScreen_width, height: 60))
        bottomView.backgroundColor = UIColor.white
        
        return bottomView
    }()
    
    lazy var lotteryBtn: UIButton = {
        let lotteryBtn = UIButton(type: .custom)
        lotteryBtn.layer.cornerRadius = 5.0
        lotteryBtn.layer.masksToBounds = true
        lotteryBtn.setTitle("立即抢票", for: .normal)
        lotteryBtn.backgroundColor = UIColor.themeColor
        lotteryBtn.addTarget(self, action: #selector(lotteryBtnAction), for: .touchUpInside)
        
        return lotteryBtn
    }()
    
    // MARK: - private method
    func loadShowRoomDetailData(requestType: RoomRequestType) {

        if requestType == .update {
            pageNum = 1
        } else {
            pageNum = pageNum + 1
        }
        
        NetRequest.showRoomDetailNetRequest(page: "\(pageNum)", uid: AppInfo.shared.user?.userId ?? "", type_id: roomId ?? "") { (success, info, result) in
            if success {
                let dic = result?.value(forKey: "data") as? NSDictionary
                
                if requestType == .update {
                    self.showRoomDetailData = ShowRoomDetailModel.deserialize(from: dic)
                    self.roomInfo = self.showRoomDetailData?.roomInfo
                    self.attribution = self.showRoomDetailData?.attribution
                    self.mediaData = self.showRoomDetailData?.video
                    for image in (self.showRoomDetailData?.image)! {
                        image.type = "1"
                        self.mediaData?.append(image)
                    }
                } else {
                    // 把新数据添加进去
                    let roomDetail = ShowRoomDetailModel.deserialize(from: dic)
                    self.showRoomDetailData?.comment = (self.showRoomDetailData?.comment)! + (roomDetail?.comment)!
                }

                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                self.tableView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
    
    // MARK: - event response
    // 点击展厅封面
    func clickHeadImageView(tap: UITapGestureRecognizer) {
        let bgView = UIScrollView.init(frame: UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.3
        let tapBg = UITapGestureRecognizer.init(target: self, action: #selector(tapBgView(tapBgRecognizer:)))
        bgView.addGestureRecognizer(tapBg)
        let picView = tap.view as! UIImageView//view 强制转换uiimageView
        if picView.image != nil {
            let imageView = UIImageView.init()
            imageView.image = picView.image;
            
            var frame = imageView.frame
            frame.size.width = 275 * width_height_ratio
            frame.size.height = frame.size.width * ((imageView.image?.size.height)! / (imageView.image?.size.width)!)
            frame.origin.x = 50 * width_height_ratio
            frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5
            imageView.frame = bgView.convert(frame, from: self.view)
            
            UIApplication.shared.keyWindow?.addSubview(bgView)
            UIApplication.shared.keyWindow?.addSubview(imageView)
            self.lastImageView = imageView
            self.originalFrame = imageView.frame
            self.scrollView = bgView
            self.scrollView?.isScrollEnabled = false
            self.scrollView?.delegate = self
            
            UIView.animate(
                withDuration: 0.3,
                delay: 0.0,
                options: UIViewAnimationOptions.beginFromCurrentState,
                animations: {
                    var frame = imageView.frame
                    frame.size.width = 275 * width_height_ratio
                    frame.size.height = frame.size.width * ((imageView.image?.size.height)! / (imageView.image?.size.width)!)
                    frame.origin.x = 50 * width_height_ratio
                    frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5
                    imageView.frame = frame
            }, completion: nil
            )
        }
    }
    func tapBgView(tapBgRecognizer:UITapGestureRecognizer)
    {
        self.scrollView?.contentOffset = CGPoint.zero
        UIView.animate(withDuration: 0.5, animations: {
            self.lastImageView?.frame = self.originalFrame
            tapBgRecognizer.view?.backgroundColor = UIColor.clear
            
        }) { (finished:Bool) in
            self.lastImageView?.removeFromSuperview()
            tapBgRecognizer.view?.removeFromSuperview()
            self.scrollView = nil
            self.lastImageView = nil
        }
    }
    
    //正确代理回调方法
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.lastImageView
    }
    
    // 收藏展厅
    @IBAction func collectionCurrentRoom(_ sender: UIButton) {
        let token = AppInfo.shared.user?.token ?? ""
        if sender.isSelected {
            NetRequest.roomCancelAttentionNetRequest(openId: token, groupId: roomId ?? "", complete: { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info!)
                    self.loadShowRoomDetailData(requestType: .update)
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            })
        } else {
            let uid = AppInfo.shared.user?.userId ?? ""
            if uid == "" {
                GeneralMethod.alertToLogin(viewController: self)
                return
            }
            NetRequest.collectionRoomNetRequest(openId: token, id: roomId ?? "") { (success, info) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: info!)
                    self.loadShowRoomDetailData(requestType: .update)
                } else {
                    SVProgressHUD.showError(withStatus: info!)
                }
            }
        }
        sender.isSelected = !sender.isSelected
    }
    
    // 添加取消关注
    @IBAction func addAttention(_ sender: UIButton) {
        let uid = AppInfo.shared.user?.userId ?? ""
        if uid == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        if sender.isSelected == false {
            NetRequest.addOrCancelAttentionNetRequest(method: "POST", mid: AppInfo.shared.user?.userId ?? "", follow_who: showRoomDetailData?.member?[sender.tag - 500].memberId ?? "") { (success, info) in
                
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    sender.setBackgroundImage(UIImage(named: "showRoom_alreadyAttentionRed_button_normal_iPhone"), for: .selected)
                    sender.isSelected = true
                    self.showRoomDetailData?.member?[sender.tag - 500].isFllow = "1"
                    self.loadShowRoomDetailData(requestType: .update)
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
        } else {
            NetRequest.addOrCancelAttentionNetRequest(method: "DELETE", mid: AppInfo.shared.user?.userId ?? "", follow_who: showRoomDetailData?.member?[sender.tag - 500].memberId ?? "") { (success, info) in
                
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    sender.setBackgroundImage(UIImage(named: "showRoom_attentionRed_button_normal_iPhone"), for: .normal)
                    sender.isSelected = false
                    self.showRoomDetailData?.member?[sender.tag - 500].isFllow = "0"
                    self.loadShowRoomDetailData(requestType: .update)
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
        }
    }
    // 项目认证
    @IBAction func projectCertificate(_ sender: UIButton) {
        if roomInfo?.isProject == 0 {
            return
        }
        let project = ProjectCertificationViewController()
        project.roomId = roomId ?? ""
        navigationController?.pushViewController(project, animated: true)
    }
    // 企业认证
    @IBAction func companyCerifcate(_ sender: UIButton) {
        let company = CompanyCertificationViewController()
        company.roomId = roomId
        navigationController?.pushViewController(company, animated: true)
    }
    
    // 返回按钮点击事件
    func backButtonAction(button: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: // 查看更多视频
    func showMoreVideos(sender: UIButton) {
        let mediaVC = MediaLibraryViewController()
        mediaVC.roomId = self.roomId
        mediaVC.isTicket = self.isTicket
        navigationController?.pushViewController(mediaVC, animated: true)
    }
    //MARK:// 展示图片
    func showMorePhotos() {
        let mediaVC = MediaLibraryViewController()
        mediaVC.roomId = self.roomId
        mediaVC.isTicket = self.isTicket
        navigationController?.pushViewController(mediaVC, animated: true)
    }
    
    //MARK: //显示图片
    func showCurrentIndex(index: Int) {
        let photos = PhotosViewController()
        if showRoomDetailData?.image != nil {
            var imageArr = [String]()
            for i in 0..<showRoomDetailData!.image!.count {
                let imageUrl = showRoomDetailData?.image?[i].address
                imageArr.append(imageUrl!)
            }
            photos.imageArray = imageArr
        }
        photos.currentIndex = index + 1
        photos.title = showRoomDetailData?.roomInfo?.title
        self.present(photos, animated: false, completion: nil)
    }
    // 点击更多
    func showMore(sender: UIButton) {
        switch sender.tag {
        case 3:
            let groupList = TheaterGroupViewController()
            groupList.roomId = roomId ?? ""
            navigationController?.pushViewController(groupList, animated: true)
        case 4:
            
            if showRoomDetailData?.member?.count == 0 {
                return
            }else {
                let member = MemberViewController()
                member.roomId = roomId ?? ""
                navigationController?.pushViewController(member, animated: true)
            }
           
            break
        case 5:
            let news = ShowNewsListViewController()
            news.roomId = roomId
            navigationController?.pushViewController(news, animated: true)
            break
        case 6:
            navigationController?.pushViewController(ApplyToEnterViewController(), animated: true)
            break
        case 7:
            let issueComment = IssueCommentViewController()
            issueComment.roomId = roomId
            navigationController?.pushViewController(issueComment, animated: true)
            break
        default:
            break
        }
    }
    
    // 分享
    func shareBarButtonItemAction() {
        // 判断是否登录
        let uid = AppInfo.shared.user?.userId ?? ""
        if uid == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        
        let messageObject = UMSocialMessageObject()
        var shareLink: String?
        // 分享链接
        if isFree {
            let url = String.init(format: "mob/group/freegroup?type_id=%d&g_id=%@", typeId, roomId ?? "")
            shareLink = kApi_baseUrl(path: url)
        } else {
            let url = String.init(format: "mob/group/groupDetail?type_id=%d&g_id=%@", typeId, roomId ?? "")
            shareLink = kApi_baseUrl(path: url)
        }
        // 设置文本
//        messageObject.text = showRoomDetailData!.roomInfo!.title! + shareLink!
        // 分享对象
        let shareObject: UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: showRoomDetailData?.roomInfo?.title ?? "", descr: showRoomDetailData?.roomInfo?.detail ?? "", thumImage: UIImage(named: "aladdiny_icon"))
        // 网址
        shareObject.webpageUrl = shareLink
        messageObject.shareObject = shareObject
        
        // 传相关参数
        ShareManager.shared.loadShareAdv()
        ShareManager.shared.complaintId = roomId ?? ""
        ShareManager.shared.type = "2"
        
        ShareManager.shared.messageObject = messageObject
        ShareManager.shared.viewController = self
        ShareManager.shared.show()
    }
    
    // 跳转抢票详情
    func lotteryBtnAction() {
        if isTicket == 1 {
            let board = UIStoryboard.init(name: "LotteryDetails", bundle: nil)
            let lotteryDetailsViewController = board.instantiateInitialViewController() as! LotteryDetailsViewController
            lotteryDetailsViewController.roomId = roomId
            navigationController?.pushViewController(lotteryDetailsViewController, animated: true)
        } else {
            let alert = SYAlertController(title: "", message: "该项目的票已被抢完，您可选择参与其他活动", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "关闭", style: .default, handler: nil)
            let toAction = UIAlertAction(title: "跳转", style: .default, handler: { (_) in
                ticketsCurrentIndex = 0
                self.tabBarController?.selectedIndex = 3
            })
            alert.addAction(closeAction)
            alert.addAction(toAction)
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 5 {
            if showRoomDetailData != nil {
                if (showRoomDetailData?.recentNews?.count)! > 0 {
                    return (showRoomDetailData?.recentNews?.count)!
                }
                return 1
            }
            return 1
        } else if section == 6 {
            return 0
        } else if section == 7 {
            if showRoomDetailData != nil {
                return (showRoomDetailData?.comment?.count)!
            }
            return 0
        }
        return 1
    }
    
    lazy var descriptionCell: ShowroomDescriptionCell = {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "descriptionCellIdentifier") as! ShowroomDescriptionCell
        cell.delegate = self as ShowroomDescriptionCellDelegate
        
        return cell
    }()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // 没有简介
            if showRoomDetailData?.roomInfo?.detail != "" {
                descriptionCell.descriptionLabel.text = showRoomDetailData?.roomInfo?.detail?.appending("\n\n\n\n\n\n\n")
            } else {
                let label = UILabel()
                label.tag = 160
                label.text = "暂无介绍"
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 18)
                label.textColor = UIColor.init(hexColor: "afafaf")
                descriptionCell.addSubview(label)
                
                label.snp.makeConstraints({ (make) in
                    make.center.equalTo(descriptionCell)
                    make.size.equalTo(CGSize(width: kScreen_width, height: 20))
                })
            }

            return descriptionCell
        } else if indexPath.section == 1 { // 公告
            let cell = tableView.dequeueReusableCell(withIdentifier: "noticeCellIdentifier") as! ShowroomNoticeCell
            cell.noticeLabel.text = showRoomDetailData?.announ?[0].announTitle ?? "暂无公告！"
            return cell
        } else if indexPath.section == 2 { // 媒体库
            let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCellIdentifier")
            // 没有数据
            if mediaData?.count == 0 {
                let label = UILabel()
                label.tag = 1001
                label.text = "暂无数据"
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 18)
                label.textColor = UIColor.init(hexColor: "afafaf")
                cell?.addSubview(label)
                
                label.snp.makeConstraints({ (make) in
                    make.center.equalTo(cell!)
                    make.size.equalTo(CGSize(width: kScreen_width, height: 20))
                })
            } else {
                let label = cell?.viewWithTag(1001)
                if label != nil {
                    label?.removeFromSuperview()
                }
            }
            
            let collectionView = cell?.viewWithTag(200) as! UICollectionView
            collectionView.reloadData()
            cell?.backgroundColor = UIColor.white
            return cell!
        } else if indexPath.section == 3 { // 群组
            let cell = tableView.dequeueReusableCell(withIdentifier: "theaterGroupCellIdentifier")
            // 没有数据
            if showRoomDetailData?.group?.count == 0 {
                let label = UILabel()
                label.tag = 1002
                label.text = "暂无群组"
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 18)
                label.textColor = UIColor.init(hexColor: "afafaf")
                cell?.addSubview(label)
                
                label.snp.makeConstraints({ (make) in
                    make.center.equalTo(cell!)
                    make.size.equalTo(CGSize(width: kScreen_width, height: 20))
                })
            } else {
                let label = cell?.viewWithTag(1002)
                if label != nil {
                    label?.removeFromSuperview()
                }
            }
            
            let collectionView = cell?.viewWithTag(201) as! UICollectionView
            collectionView.reloadData()
            return cell!
        } else if indexPath.section == 4 { // 项目成员
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCellIdentifier")
            // 没有项目成员
            if showRoomDetailData?.member?.count == 0 {
                let label = UILabel()
                label.tag = 1003
                label.text = "暂无项目成员"
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 18)
                label.textColor = UIColor.init(hexColor: "afafaf")
                cell?.addSubview(label)
                
                label.snp.makeConstraints({ (make) in
                    make.center.equalTo(cell!)
                    make.size.equalTo(CGSize(width: kScreen_width, height: 20))
                })
            } else {
                let label = cell?.viewWithTag(1003)
                if label != nil {
                    label?.removeFromSuperview()
                }
            }
            
            let collectionView = cell?.viewWithTag(202) as! UICollectionView
            collectionView.reloadData()
            
            return cell!
        } else if indexPath.section == 5 {  // 资讯
            let cell = tableView.dequeueReusableCell(withIdentifier: "onePicCell") as! OnePictureTableViewCell?
            
            // 暂无数据
            if showRoomDetailData != nil && showRoomDetailData?.recentNews?.count != 0 {
                cell?.adButton.isHidden = false
                cell?.topButton.isHidden = false
                cell?.infoImageView.isHidden = false
                cell?.infoModel = showRoomDetailData?.recentNews?[indexPath.row]
                
                let label = cell?.viewWithTag(1004)
                if label != nil {
                    label?.isHidden = true
                }
            } else {
                // 没有最新动态的时候
                
                cell?.adButton.isHidden = true
                cell?.topButton.isHidden = true
                cell?.infoImageView.isHidden = true
                
                let label = UILabel()
                label.tag = 1004
                label.text = "暂无数据"
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 18)
                label.textColor = UIColor.init(hexColor: "afafaf")
                cell?.addSubview(label)
                
                label.snp.makeConstraints({ (make) in
                    make.center.equalTo(cell!)
                    make.size.equalTo(CGSize(width: kScreen_width, height: 20))
                })
            }
            
            if showRoomDetailData != nil {
                if (showRoomDetailData?.recentNews?.count)! == 2 && indexPath.row == 1 {
                    let view = UIView()
                    view.backgroundColor = tableView.separatorColor
                    cell?.contentView.addSubview(view)
                    view.snp.makeConstraints({ (make) in
                        make.height.equalTo(0.5)
                        make.left.equalTo((cell?.contentView)!).offset(15)
                        make.right.equalTo((cell?.contentView)!)
                        make.bottom.equalTo((cell?.contentView)!)
                    })
                }
            }
            
            let newsData = showRoomDetailData?.recentNews
            if newsData?.count != 0 {
                switch newsData?[indexPath.row].showType ?? 0 {
                case 1: //只有文字
                    let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! TravelTableViewCell
                    cell.infoModel = newsData?[indexPath.row]
                    return cell
                case 2: //上图下文
                    let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoInfoTableViewCell
                    cell.infoModel = newsData?[indexPath.row]
                    return cell
                case 3: //左文右图
                    let cell = tableView.dequeueReusableCell(withIdentifier: "onePicCell", for: indexPath) as! OnePictureTableViewCell
                    cell.infoModel = newsData?[indexPath.row]
                    return cell
                case 4: //三张图
                    let cell = tableView.dequeueReusableCell(withIdentifier: "threeCell", for: indexPath) as! ThreePictureTableViewCell
                    cell.infoModel = newsData?[indexPath.row]
                    return cell
                case 5: // 大图
                    let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoInfoTableViewCell
                    cell.infoLabel.isHidden = true
                    cell.playImageView.isHidden = true
                    cell.infoModel = newsData?[indexPath.row]
                    return cell
                default:
                    return cell!
                }
            }
            return cell!
            
        } else {
            let cell = ShowRoomCommentCell(style: .default, reuseIdentifier: "TopicsViewIdentifier")
            if showRoomDetailData != nil {
                let commentFrame = RoomCommentFrameModel()
                commentFrame.comment = showRoomDetailData?.comment?[indexPath.row]
                cell.commentFrame = commentFrame
                cell.starCountButton.tag = 150 + indexPath.row
                cell.replyButton.tag = 160 + indexPath.row
                cell.delegate = self
                cell.selectionStyle = .none
            }
            
            let view = UIView()
            view.backgroundColor = tableView.separatorColor
            cell.contentView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.height.equalTo(0.5)
                make.left.equalTo(cell.contentView).offset(15)
                make.right.equalTo(cell.contentView)
                make.bottom.equalTo(cell.contentView)
            })
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return descriptionCellHeight
        } else if indexPath.section == 1 {
            return 44.5
        } else if indexPath.section == 2 {
            return 95
        } else if indexPath.section == 3 {
            return 160
        } else if indexPath.section == 4 {
            if isFree {
                return 0
            }
            return 160
        } else if indexPath.section == 5 {
            let newsData = showRoomDetailData?.recentNews
            if newsData?.count == 0 {
                return 109
            } else {
                if newsData != nil {
                    switch newsData?[indexPath.row].showType ?? 0 {
                    case 1:
                        return 87.5 * width_height_ratio
                    case 2:
                        return 280 * width_height_ratio
                    case 3:
                        return 109
                    case 4:
                        return 160 * width_height_ratio
                    case 5:
                        return 280 * width_height_ratio
                    default:
                        return 0
                    }
                }
            }
            
            return 0
            
        } else if indexPath.section == 7 {
            
            if showRoomDetailData != nil {
                let commentFrame = RoomCommentFrameModel()
                commentFrame.comment = showRoomDetailData?.comment?[indexPath.row]
                return commentFrame.cellHeight!
            }
            return 0
        } else {
            return 0
        }
    }
    
    // MARK: - 设置组头
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == 1 {
            return nil
        }
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 0))
        sectionHeaderView.backgroundColor = UIColor.white
        
        // 图标视图
        let iconView = UIImageView()
        iconView.image = UIImage(named: "home_rednote_icon_normal_iPhone")
        sectionHeaderView.addSubview(iconView)
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.init(hexColor: "333333")
        titleLabel.text = sectionTitleArray[section]
        sectionHeaderView.addSubview(titleLabel)
        
        // 设置布局
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(sectionHeaderView)
            make.top.equalTo(sectionHeaderView).offset(15)
            make.size.equalTo(CGSize(width: 2, height: 16.5))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(4)
            make.bottom.equalTo(sectionHeaderView).offset(-8)
            make.height.equalTo(18)
        }
        // 按钮前的文字
        let moreTitleLabel = UILabel()
        moreTitleLabel.font = UIFont.systemFont(ofSize: 10)
        moreTitleLabel.textColor = UIColor.init(hexColor: "333333")
        moreTitleLabel.text = moreTitleArray[section]
        sectionHeaderView.addSubview(moreTitleLabel)
        
        // 媒体库
        
        // FIXME:- 媒体库按钮大小
        if section == 2 && showRoomDetailData != nil {
            
            // 更多按钮
            let moreButton = UIButton()
            moreButton.tag = section
            moreButton.setImage(UIImage(named: "home_more_button_normal_iPhone"), for: .normal)
            moreButton.addTarget(self, action: #selector(showMorePhotos), for: .touchUpInside)
            sectionHeaderView.addSubview(moreButton)
            
            let photosButton = UIButton()
            photosButton.titleLabel?.textAlignment = .right
            let photosTitle = String.init(format: "图片 %d", showRoomDetailData?.image?.count ?? 0)
            photosButton.setTitle(photosTitle, for: .normal)
            photosButton.setTitleColor(UIColor.black, for: .normal)
            
            photosButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            photosButton.addTarget(self, action: #selector(showMorePhotos), for: .touchUpInside)
            sectionHeaderView.addSubview(photosButton)
            
            if showRoomDetailData?.image?.count == 0 {
                photosButton.isEnabled = false
            } else {
                photosButton.isEnabled = true
            }
            
            moreButton.snp.makeConstraints { (make) in
                make.right.equalTo(sectionHeaderView).offset(-13)
                make.centerY.equalTo(sectionHeaderView)
                make.size.equalTo(CGSize(width: 25, height: 25))
            }
            
            photosButton.snp.makeConstraints({ (make) in
                make.right.equalTo(moreButton.snp.left)
                make.centerY.equalTo(sectionHeaderView)
                make.height.equalTo(sectionHeaderView)
            })
            
            
            
            if !isFree { // 免费展厅没有视频
                let videosButton = UIButton()
                videosButton.titleLabel?.textAlignment = .right
                
                let videosTitle = String.init(format: "视频 %d", showRoomDetailData?.video?.count ?? 0)
                videosButton.setTitle(videosTitle, for: .normal)
                videosButton.setTitleColor(UIColor.black, for: .normal)
                videosButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
                videosButton.addTarget(self, action: #selector(showMoreVideos(sender:)), for: .touchUpInside)
                sectionHeaderView.addSubview(videosButton)
                
                if showRoomDetailData?.video?.count == 0 {
                    photosButton.isEnabled = false
                } else {
                    photosButton.isEnabled = true
                }
                
                videosButton.snp.makeConstraints({ (make) in
                    make.right.equalTo(photosButton.snp.left).offset(-6)
                    make.centerY.equalTo(sectionHeaderView)
                    make.height.equalTo(sectionHeaderView)
                })
            }
            
        } else if section > 3 && section < 7 {
            
            // 更多按钮
            let moreButton = UIButton()
            moreButton.tag = section
            moreButton.setImage(UIImage(named: "home_more_button_normal_iPhone"), for: .normal)
            moreButton.addTarget(self, action: #selector(showMore(sender:)), for: .touchUpInside)
            sectionHeaderView.addSubview(moreButton)
            
            moreButton.snp.makeConstraints { (make) in
                make.right.equalTo(sectionHeaderView).offset(-13)
                make.centerY.equalTo(sectionHeaderView)
                make.size.equalTo(CGSize(width: 25, height: 25))
            }
            
            moreTitleLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(moreButton.snp.left).offset(-10)
                make.centerY.equalTo(sectionHeaderView)
                make.height.equalTo(10)
            })
            
            // 项目成员
            if section == 4 && isFree {
                return nil
            }
            
            // 添加手势
            if section == 6 {
                let tap = UITapGestureRecognizer(target: self, action: #selector(applyToEnter(tap:)))
                tap.numberOfTapsRequired = 1
                tap.numberOfTouchesRequired = 1
                sectionHeaderView.addGestureRecognizer(tap)
            }
            
        } else {
            // 群组
            if section == 3 && showRoomDetailData?.group != nil {
                let groupButton = UIButton()
                groupButton.tag = section
                groupButton.isEnabled = false
                groupButton.titleLabel?.textAlignment = .right
                groupButton.setTitle("群组\(showRoomDetailData?.group?.count ?? 0)", for: .normal)
                groupButton.setTitleColor(UIColor.black, for: .normal)
                groupButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
                groupButton.addTarget(self, action: #selector(showMore(sender:)), for: .touchUpInside)
                sectionHeaderView.addSubview(groupButton)
                
                groupButton.snp.makeConstraints({ (make) in
                    make.right.equalTo(sectionHeaderView).offset(-13)
                    make.centerY.equalTo(sectionHeaderView)
                    
                    make.height.equalTo(10)
                })
            }
            
            // 评论
            if section == 7 {
                let commentLabel = UILabel()
                
                commentLabel.text = "(\(showRoomDetailData!.plcount!))"
                commentLabel.font = UIFont.systemFont(ofSize: 13)
                sectionHeaderView.addSubview(commentLabel)
                
                commentLabel.snp.makeConstraints({ (make) in
                    make.left.equalTo(titleLabel.snp.right).offset(8)
                    make.bottom.equalTo(sectionHeaderView).offset(-8)
                    make.height.equalTo(11)
                })
                
                let commentButton = UIButton()
                commentButton.tag = section
                commentButton.titleLabel?.textAlignment = .right
                commentButton.setTitle("我要评论", for: .normal)
                commentButton.setTitleColor(UIColor.black, for: .normal)
                commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
                commentButton.addTarget(self, action: #selector(showMore(sender:)), for: .touchUpInside)
                sectionHeaderView.addSubview(commentButton)
                
                commentButton.snp.makeConstraints({ (make) in
                    make.right.equalTo(sectionHeaderView).offset(-13)
                    make.centerY.equalTo(sectionHeaderView)
                    make.height.equalTo(40)
                })

            }
        }
        return sectionHeaderView
    }
    
    func applyToEnter(tap: UITapGestureRecognizer) {
        let uid = AppInfo.shared.user?.userId ?? ""
        if uid == "" {
            GeneralMethod.alertToLogin(viewController: self)
        }
        navigationController?.pushViewController(ApplyToEnterViewController(), animated: true)
    }
    
    // 设置组头高度
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 0.01
        }
        if section == 4 && isFree {
            return 0.01
        }
        return 40
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 4 && isFree {
            return 0.01
        }
        return 10
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if showRoomDetailData?.announ?[0].announTitle != nil {
                let announce = AnnouncementViewController()
                announce.announcementId = showRoomDetailData?.announ?[0].announId
                navigationController?.pushViewController(announce, animated: true)
            }
        }
        if indexPath.section == 5 {
            if (showRoomDetailData?.recentNews?.count)! > 0 {
                let news = RoomNewsDetailViewController()
                news.newsPhoto = showRoomDetailData?.recentNews?[indexPath.row].infoImageArr?[0] ?? ""
                news.newsId = showRoomDetailData?.recentNews?[indexPath.row].newsId ?? ""
                news.newsTitle = showRoomDetailData?.recentNews?[indexPath.row].infoTitle ?? ""
                news.commentNumber = showRoomDetailData?.recentNews?[indexPath.row].infoComment ?? "0"
                navigationController?.pushViewController(news, animated: true)
            }
            
        }
        if indexPath.section == 7 {
            let commentReply = CommentReplyViewController()
            commentReply.roomId = roomId
            commentReply.commentData = showRoomDetailData?.comment?[indexPath.row]
            navigationController?.pushViewController(commentReply, animated: true)
        }
    }
}

extension ShowroomDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundColor = UIColor.white
        if showRoomDetailData != nil {
            switch collectionView.tag {
            case 200:
                return mediaData?.count ?? 0
            case 201:
                return showRoomDetailData?.group?.count ?? 0
            case 202:
                return showRoomDetailData?.member?.count ?? 0
            default:
                return 0
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if showRoomDetailData != nil {
            switch collectionView.tag {
            case 200:
                // 媒体库
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as! ShowroomMediaCell
                cell.mediaModel = mediaData?[indexPath.row]
                return cell
            case 201:
                // 群组
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as! ShowroomGroupCell
                cell.groupModel = showRoomDetailData?.group?[indexPath.row]
                return cell
            case 202:
                // 展厅成员
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as! ShowroomMemberCell
                cell.memberModel = showRoomDetailData?.member?[indexPath.row]
                cell.followButton.tag = indexPath.item + 500
                return cell
            default:
                return UICollectionViewCell()
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 200: // 媒体库
            if indexPath.row < (showRoomDetailData?.video?.count)! {
                let videos = VideosViewController()
                videos.roomId = roomId
                videos.isTicket = isTicket ?? 0
                videos.roomTitle = showRoomDetailData?.roomInfo?.title ?? ""
                videos.videoId = showRoomDetailData?.video?[indexPath.row].mediaId
                navigationController?.pushViewController(videos, animated: true)
            } else {
                showCurrentIndex(index: indexPath.item - (showRoomDetailData?.video?.count)!)
            }
            break
        case 201: // 群组
            let groupModel = showRoomDetailData?.group?[indexPath.row]
            let isJoin = groupModel?.isJoin
            
            if isJoin == "0" {
                // 未加入
                let group = GroupMemberListViewController()
                group.groupId = groupModel?.groupId ?? ""
                group.roomName = roomInfo?.title ?? ""
                group.groupName = groupModel?.groupName ?? ""
                group.flag = 10
                navigationController?.pushViewController(group, animated: false)
            } else if isJoin == "1" {
                // 已加入
                let conversationVC = ChatDeatilViewController()
                conversationVC.conversationType = RCConversationType.ConversationType_GROUP
                conversationVC.targetId = groupModel?.groupId ?? "0"
                conversationVC.roomName = groupModel?.roomName ?? ""
                conversationVC.groupName = groupModel?.groupName ?? ""
                conversationVC.flag = 10
                navigationController?.pushViewController(conversationVC, animated: true)
            }
        case 202: // 社区
            let community = MyCommunityViewController()
            community.title = "个人社区"
            let memberModel = showRoomDetailData?.member?[indexPath.row]
            community.headImageUrl = memberModel?.memberPhoto
            community.userId = memberModel?.memberId
            community.nickName = memberModel?.nickName
            community.type = "2"
            community.fansCount = "粉丝:\(memberModel?.memberFans ?? "0")人"
            community.friendsCountLabel.text = "好友:\(memberModel?.friendsNumber ?? "0")人"
            if memberModel?.isFllow == "1" {
                community.isFollowed = true
            } else {
                community.isFollowed = false
            }
            
            navigationController?.pushViewController(community, animated: true)
            break
        default:
            break
        }
    }
}

extension ShowroomDetailsViewController: ShowRoomCommentCellDelegate {
    func commentPushButtonDidSelected(sender: UIButton, comments: CommentModel) {
        let personInfo = PersonalInformationViewController()
        personInfo.targetId = comments.uid ?? ""
        personInfo.name = comments.nickName ?? ""
        self.navigationController?.pushViewController(personInfo, animated: true)
    }
    
    // 点赞按钮
    func commentReplyStarDidSelected(sender: UIButton, comments: CommentModel) {
        let uid = AppInfo.shared.user?.userId ?? ""
        if uid == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return
        }
        NetRequest.thumbUpNetRequest(id: comments.commentId ?? "", uid: uid) { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info)
                sender.isSelected = true
                comments.isStar = "1"
                comments.zanNumber = "\(Int(comments.zanNumber!)! + 1)"
                self.tableView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: info)
            }
        }
    }

    // 回复按钮
    func commentReplyButtonDidSelected(sender: UIButton) {
        let commentReply = CommentReplyViewController()
        commentReply.roomId = roomId
        commentReply.commentData = showRoomDetailData?.comment?[sender.tag - 160]
        navigationController?.pushViewController(commentReply, animated: true)
    }
}

extension ShowroomDetailsViewController: ShowroomDescriptionCellDelegate {
    func showroomDescriptionCell(_ showroomDescriptionCell: ShowroomDescriptionCell, moreBtnAction moreBtn: UIButton) {
        
        if moreBtn.isSelected {
            // 当前处于展开状态  变成收起
            descriptionCellHeight = 160
        } else {
            // 当前处于收起状态  变成展开
            let size = String().stringSize(text: showRoomDetailData?.roomInfo?.detail ?? "", font: UIFont.systemFont(ofSize: 15), maxSize: CGSize(width: kScreen_width - 20, height: 2000))
            
            descriptionCellHeight = size.height + 48.5 + 15
            
            if descriptionCellHeight < 160 {
                descriptionCellHeight = 160
            }
        }
        moreBtn.isSelected = !moreBtn.isSelected
        tableView.reloadData()
    }
    
    
}
