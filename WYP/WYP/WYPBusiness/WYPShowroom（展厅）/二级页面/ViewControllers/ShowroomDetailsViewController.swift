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
    
    @IBOutlet weak var contentLabel: UILabel!
    
    
    @IBOutlet weak var headimageView: UIImageView!
    
    @IBOutlet weak var qianpiaoBtn: UIButton!
    
    @IBOutlet weak var headSmallImageView: UIImageView!
    
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
    
    
    var dynamicArray = [StatementModel]()
    
    
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
        let sectionTitleArray = ["媒体库", "群组", "项目成员", "最新动态","","","申请入驻", "最近评论"]
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
            var imageUrll: URL?
            if isFree {
                imageUrl = URL(string: newValue?.logo ?? "")
                self.headImgView.kf.setImage(with: imageUrl)
            } else {
                imageUrl = URL(string: newValue?.background ?? "")
                
                imageUrll = URL(string: newValue?.logo ?? "")
                self.headimageView.kf.setImage(with: imageUrl, placeholder: UIImage.init(named: "place_image"), options: nil, progressBlock: nil, completionHandler: nil)

                
                self.headSmallImageView.kf.setImage(with: imageUrll, placeholder: UIImage.init(named: "place_image"), options: nil, progressBlock: nil, completionHandler: nil)
            }
    
            self.projectTitleLabel.text = newValue?.title ?? ""
            self.followButton.setTitle("  \(newValue?.followedCount ?? "")人", for: .normal)
            
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
    
    //话题数据源
    var topicsData: [InfoModel]?
    
    
    var newsData = [StatementFrameModel]()
    
    var newsDataAll = [StatementFrameModel]()
    
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
        
        
        self.tableView.register(TalkOnePictureTableViewCell.self, forCellReuseIdentifier: "onePicCell1")
        self.tableView.register(TalkTravelTableViewCell.self, forCellReuseIdentifier: "textCell1")
        self.tableView.register(TalkThreePictureTableViewCell.self, forCellReuseIdentifier: "threeCell1")
        self.tableView.register(TalkVideoInfoTableViewCell.self, forCellReuseIdentifier: "videoCell1")
        self.tableView.register(IntelligentTableViewCell.self, forCellReuseIdentifier: "inteCell1")
        
        self.tableView.register(UINib.init(nibName: "ShowroomApplyCell", bundle: nil), forCellReuseIdentifier: "appCell")
        
        
        self.tableView.register(StatementCell.self, forCellReuseIdentifier: "StatementCellIdentifier")
        
        
        self.tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadShowRoomDetailData(requestType: .loadMore)
        })
//        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
//            self.loadShowRoomDetailData(requestType: .update)
//        })

        // 监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)

            // 如果不是免费展厅
        if deviceTypeIphone5() {
            tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: 520 * width_height_ratio)
        }else {
             tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: 460 * width_height_ratio)
        }
       

    }
    
    deinit {

        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = false
        
       
            
        self.navigationController?.navigationBar.isHidden = true
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "tj_icon_fxh_normal"), style: .done, target: self, action: #selector(shareBarButtonItemAction))
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 判断是否关联票务 08/01 修改为一直显示抢票按钮，将判断加载点击事件中
        self.tableView.window?.addSubview(bottomView)
        self.tableView.window?.bringSubview(toFront: bottomView)
        bottomView.addSubview(commentTextField)
        bottomView.addSubview(collectionButton)
            
        commentTextField.snp.makeConstraints { (make) in
            if deviceTypeIPhoneX() {
                make.centerY.equalTo(bottomView.snp.centerY).offset(-4)
            }else {
                make.centerY.equalTo(bottomView.snp.centerY)
            }
            
            make.left.equalTo(bottomView).offset(13)
            make.right.equalTo(collectionButton.snp.left).offset(-30)
            make.height.equalTo(34)
        }
        
        collectionButton.snp.makeConstraints { (make) in
            make.right.equalTo(bottomView).offset(-24)
            make.centerY.equalTo(commentTextField.snp.centerY)
            make.size.equalTo(CGSize(width: 21, height: 21))
        }
        
        loadShowRoomDetailData(requestType: .update)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barTintColor = UIColor.themeColor
        
        self.navigationController?.navigationBar.isHidden = false
        
        bottomView.removeFromSuperview()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
       
       return .lightContent

    }
    
    func viewConfig() {
        self.headSmallImageView.layer.masksToBounds = true
        self.headSmallImageView.layer.cornerRadius = 8
        self.headSmallImageView.layer.borderColor = UIColor.white.cgColor
        self.headSmallImageView.layer.borderWidth = 1.5
        
        self.qianpiaoBtn.layer.masksToBounds = true
        self.qianpiaoBtn.layer.cornerRadius = 20
        self.qianpiaoBtn.backgroundColor = UIColor.themeColor
        
        self.tableView.separatorColor = UIColor.init(hexColor: "f8f8f8")
        
    }
    

    lazy var bottomView: UIView = {
        let bottomView = UIView(frame: CGRect(x: 0, y: kScreen_height - 60, width: kScreen_width, height: 60))
        bottomView.backgroundColor = UIColor.white
        
        return bottomView
    }()
    
  
    
    // 评论框
    lazy var commentTextField: SYTextField = {
        let commentTextField = SYTextField()
        commentTextField.font = UIFont.systemFont(ofSize: 14)
        commentTextField.delegate = self
        commentTextField.placeholder = "写下你的想法..."
        commentTextField.returnKeyType = .send
        commentTextField.layer.masksToBounds = true
        commentTextField.layer.cornerRadius = 15
        commentTextField.backgroundColor = UIColor.init(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        let imageView = UIImageView(frame: CGRect(x: 10, y: 8, width: 16, height: 16))
        imageView.image = UIImage(named: "zx_icon_write_normal")
        commentTextField.addSubview(imageView)
        
        return commentTextField
    }()
    
    lazy var collectionButton: UIButton = {
        let collectionButton = UIButton()
        collectionButton.setBackgroundImage(UIImage(named: "common_collection_button_normal_iPhone"), for: .normal)
        collectionButton.setBackgroundImage(UIImage(named: "common_collection_button_selected_iPhone"), for: .selected)
        collectionButton.addTarget(self, action: #selector(collectionNews(sender:)), for: .touchUpInside)
        return collectionButton
    }()
    

    // MARK: --关注展厅
    func collectionNews(sender: UIButton) {
        
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
                let dynamicArray = dic!["dynamic"] as? [NSDictionary]
                
                if requestType == .update {
                    self.showRoomDetailData = ShowRoomDetailModel.deserialize(from: dic)
                    
                    
                    
                    self.roomInfo = self.showRoomDetailData?.roomInfo
                    self.attribution = self.showRoomDetailData?.attribution
                    self.mediaData = self.showRoomDetailData?.video
                    self.topicsData = self.showRoomDetailData?.gambit
                    
                    self.newsData.removeAll()

                    for optDic in dynamicArray! {
                        let statement = StatementModel(contentDic: optDic as! [AnyHashable : Any])
                        let statementFrame = StatementFrameModel()
                        let statementFrameAll = StatementFrameModel()
                        statementFrame.isSeachResult = true
                        
                        statementFrame.statement = statement
                        statementFrameAll.statement = statement
                        statementFrame.isShowAllMessage = true
                        self.newsData.append(statementFrame)
                        self.newsDataAll.append(statementFrameAll)
                    }
                    
                    for image in (self.showRoomDetailData?.image)! {
                        image.type = "1"
                        self.mediaData?.append(image)
                    }
                    
                    if self.showRoomDetailData?.roomInfo?.isLike == 0 {
                        self.collectionButton.isSelected = false
                        self.collectionButton.setBackgroundImage(UIImage(named: "common_collection_button_normal_iPhone"), for: .normal)
                    }else {
                        self.collectionButton.isSelected = true
                        self.collectionButton.setBackgroundImage(UIImage(named: "common_collection_button_selected_iPhone"), for: .selected)
                    }
                    
                    
                    
                    self.contentLabel.text = self.showRoomDetailData?.roomInfo?.detail
                } else {
                    // 把新数据添加进去
                    let roomDetail = ShowRoomDetailModel.deserialize(from: dic)
                    self.showRoomDetailData?.comment = (self.showRoomDetailData?.comment)! + (roomDetail?.comment)!
                }

//                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                self.tableView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
    
    
    //正确代理回调方法
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.lastImageView
    }
    
    // 收藏展厅
    @IBAction func collectionCurrentRoom(_ sender: UIButton) {

    }
    
    // 添加取消关注
    @IBAction func addAttention(_ sender: UIButton) {

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
    @IBAction func backBtnAction(_ sender: Any) {
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
        case 1:
            let groupList = TheaterGroupViewController()
            groupList.roomId = roomId ?? ""
            navigationController?.pushViewController(groupList, animated: true)
        case 2:
            
            if showRoomDetailData?.member?.count == 0 {
                return
            }else {
                let member = MemberViewController()
                member.roomId = roomId ?? ""
                navigationController?.pushViewController(member, animated: true)
            }
           
            break
        case 3:
            let news = ShowNewsListViewController()
            news.roomId = roomId
            navigationController?.pushViewController(news, animated: true)
            break
//        case 6:
//
//            break
//        case 7:
//            let issueComment = IssueCommentViewController()
//            issueComment.roomId = roomId
//            navigationController?.pushViewController(issueComment, animated: true)
//            break
        default:
            break
        }
    }
    
    // MARK --申请入驻
    func applyAction() {
        navigationController?.pushViewController(ApplyToEnterViewController(), animated: true)
    }
    
    // 分享
    @IBAction func shareBtnAction(_ sender: Any) {
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
    
    func keyboardWillShow(note: NSNotification) {
        let userInfo = note.userInfo!
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {
            //键盘的偏移量
            self.bottomView.transform = CGAffineTransform(translationX: 0 , y: -deltaY)
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else{
            animations()
        }
    }
    
    
    func keyboardWillHidden(note: NSNotification) {
        self.bottomView.transform = CGAffineTransform(translationX: 0 , y: 0)
    }
    
 
    
    //MARK: --抢票详情
    
    @IBAction func lotteryBtnAction(_ sender: Any) {
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
        if section == 3 {
            if showRoomDetailData != nil {
                return (showRoomDetailData?.recentNews?.count)!
            }
            return 0
        } else if section == 4 {
            if showRoomDetailData != nil {
                return (showRoomDetailData?.gambit?.count)!
            }
            return 0
        } else if section == 5 {
            if self.newsData.count != 0 {
                return self.newsData.count
            } else {
                return 0
            }
        }else if section == 6 {
            return 1
        }else if section == 7 {
            if showRoomDetailData != nil {
                return (showRoomDetailData?.comment?.count)!
            }
            return 0
        }
        return 1
    }
    
  
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            //媒体库
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
            collectionView.layer.cornerRadius = 12
            collectionView.layer.masksToBounds = true
            collectionView.reloadData()
            cell?.backgroundColor = UIColor.white
            return cell!
        }else if indexPath.section == 1 {  //群组
            let cell = tableView.dequeueReusableCell(withIdentifier: "theaterGroupCellIdentifier")
            // 没有数据
            if showRoomDetailData?.group?.count == 0 {
                let label = UILabel()
                label.tag = 1002
                label.text = "暂无群组"
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 17)
                label.textColor = UIColor.black
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
            collectionView.layer.cornerRadius = 12
            collectionView.layer.masksToBounds = true
            collectionView.reloadData()
            return cell!
        }else if indexPath.section == 2 { //项目成员
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
            collectionView.layer.cornerRadius = 12
            collectionView.layer.masksToBounds = true
            collectionView.reloadData()
            return cell!
        }else if indexPath.section == 3 {  //最新动态
          
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
                    cell.contentView.layer.masksToBounds = true
                    cell.contentView.layer.cornerRadius = 20
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
                    return UITableViewCell()
                }
            }

        }else if indexPath.section == 4 {  //话题
            let newData1 = showRoomDetailData?.gambit
            switch newData1?[indexPath.row].showType ?? 6 {
            case 0: // 视频
                let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell1", for: indexPath) as! TalkVideoInfoTableViewCell
                cell.infoModel = newData1?[indexPath.row]
                return cell
            case 1: //只有文字
                let cell = tableView.dequeueReusableCell(withIdentifier: "textCell1", for: indexPath) as! TalkTravelTableViewCell
                cell.infoModel = newData1?[indexPath.row]
                return cell
            case 2: //上图下文
                let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell1", for: indexPath) as! TalkVideoInfoTableViewCell
                cell.infoModel = newData1?[indexPath.row]
                return cell
            case 3: //左文右图
                let cell = tableView.dequeueReusableCell(withIdentifier: "onePicCell1", for: indexPath) as! TalkOnePictureTableViewCell
                cell.infoModel = newData1?[indexPath.row]
                return cell
            case 4: //三张图
                let cell = tableView.dequeueReusableCell(withIdentifier: "threeCell1", for: indexPath) as! TalkThreePictureTableViewCell
                cell.infoModel = newData1?[indexPath.row]
                return cell
            case 5: // 大图
                let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell1", for: indexPath) as! TalkVideoInfoTableViewCell
                cell.infoLabel.isHidden = true
                cell.playImageView.isHidden = true
                cell.infoModel = newData1?[indexPath.row]
                return cell
            default:
                return UITableViewCell()
            }
        }else if indexPath.section == 5 { //社区
            let cell = StatementCell(style: .default, reuseIdentifier: "StatementCellIdentifier")
            cell.statementFrame = newsData[indexPath.row]
            cell.shareButton.isHidden = true
            cell.leaveMessageButton.isHidden =  true
            cell.starButton.isHidden = true
            cell.selectionStyle = .none;
            cell.selectImgBlock = {(index, imageUrlArray) in
                return
            }
            
            return cell
        }else if indexPath.section == 6 {  //申请入驻
            let cell = tableView.dequeueReusableCell(withIdentifier: "appCell", for: indexPath)
            let btn1 = cell.contentView.viewWithTag(99) as! UIButton
            let btn2 = cell.contentView.viewWithTag(100) as! UIButton
            btn1.addTarget(self, action: #selector(applyAction), for: .touchUpInside)
            btn2.addTarget(self, action: #selector(applyAction), for: .touchUpInside)
            return cell
        }else if indexPath.section == 7 { //最新评论
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
        return UITableViewCell()
        
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 110
        } else if indexPath.section == 1 {
            return 160
        } else if indexPath.section == 2 {
            return 165
        } else if indexPath.section == 3 {
            let newsData = showRoomDetailData?.recentNews
            
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
 
        }else if indexPath.section == 4 {
            
            let newsData1 = showRoomDetailData?.gambit
            switch newsData1![indexPath.row].showType ?? 6 {
            case 0:
                
                let titleH = self.getLabHeight(labelStr: newsData1![indexPath.row].infoTitle!, font: UIFont.systemFont(ofSize: 16), width: kScreen_width - 26)
                if titleH > 20 {   //两行
                    return 310 * width_height_ratio
                }
                return 275 * width_height_ratio
            case 1:  //只有文字
                let titleH = self.getLabHeight(labelStr: newsData1![indexPath.row].infoTitle!, font: UIFont.systemFont(ofSize: 16), width: kScreen_width - 26)
                if titleH > 20 {
                    return 87.5 * width_height_ratio
                }
                return 74 * width_height_ratio
            case 2:  //大图下文
                let titleH = self.getLabHeight(labelStr: newsData1![indexPath.row].infoTitle!, font: UIFont.systemFont(ofSize: 16), width: kScreen_width - 26)
                if titleH > 20 {   //两行
                    return 295 * width_height_ratio
                }
                return 275 * width_height_ratio
            case 3:    //左文右图
                return 100
            case 4:  //三图
                
                let titleH = self.getLabHeight(labelStr: newsData1![indexPath.row].infoTitle!, font: UIFont.systemFont(ofSize: 16), width: kScreen_width - 26)
                if titleH > 20 {
                    return 180 * width_height_ratio
                }
                
                return 160 * width_height_ratio
            case 5:
                
                return 275 * width_height_ratio
            default:
                return 0
            }
        }else if indexPath.section == 5 {
            let statementFrame = newsData[indexPath.row]
            return statementFrame.cellHeight
        }else if indexPath.section == 6 {
            return 50
        }
        else if indexPath.section == 7 {
            
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
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 0))
        sectionHeaderView.backgroundColor = UIColor.init(hexColor: "F8F8F8")
        
        // 图标视图
        let iconView = UIImageView()
        iconView.image = UIImage(named: "home_rednote_icon_normal_iPhone")
        sectionHeaderView.addSubview(iconView)
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor.init(hexColor: "333333")
        
        
        
        titleLabel.text = sectionTitleArray[section]
        sectionHeaderView.addSubview(titleLabel)
        
        // 设置布局
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(sectionHeaderView).offset(17)
            make.centerY.equalTo(sectionHeaderView)
            make.size.equalTo(CGSize(width: 2, height: 15))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(6)
            make.centerY.equalTo(sectionHeaderView)
            
        }
        // 按钮前的文字
        let moreTitleLabel = UILabel()
        moreTitleLabel.font = UIFont.systemFont(ofSize: 10)
        moreTitleLabel.textColor = UIColor.init(hexColor: "333333")
        moreTitleLabel.text = moreTitleArray[section]
        sectionHeaderView.addSubview(moreTitleLabel)
        
        // 媒体库
        
        // FIXME:- 媒体库按钮大小
        if section == 0 && showRoomDetailData != nil {
            
            // 更多按钮
            let moreButton = UIButton()
            moreButton.tag = section
            moreButton.setImage(UIImage(named: "home_more_button_normal_iPhone"), for: .normal)
            moreButton.addTarget(self, action: #selector(showMorePhotos), for: .touchUpInside)
            sectionHeaderView.addSubview(moreButton)
            
            let photosButton = UIButton()
            photosButton.titleLabel?.textAlignment = .right
            let photosTitle = String.init(format: "图片 (%d)", showRoomDetailData?.image?.count ?? 0)
            photosButton.setTitle(photosTitle, for: .normal)
            photosButton.setTitleColor(UIColor.black, for: .normal)
            
            photosButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
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
            
            let videosButton = UIButton()
            videosButton.titleLabel?.textAlignment = .right
            
            let videosTitle = String.init(format: "视频 (%d)", showRoomDetailData?.video?.count ?? 0)
            videosButton.setTitle(videosTitle, for: .normal)
            videosButton.setTitleColor(UIColor.black, for: .normal)
            videosButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
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
            
            
        } else if section >= 1 && section < 4 || section == 6{
            
            let groupLabel = UILabel()
            groupLabel.font = UIFont.boldSystemFont(ofSize: 12)
            sectionHeaderView.addSubview(groupLabel)
            
            // 更多按钮
            let moreButton = UIButton()
            moreButton.tag = section
            moreButton.setImage(UIImage(named: "home_more_button_normal_iPhone"), for: .normal)
            moreButton.addTarget(self, action: #selector(showMore(sender:)), for: .touchUpInside)
            sectionHeaderView.addSubview(moreButton)
            
            moreButton.snp.makeConstraints { (make) in
                make.right.equalTo(sectionHeaderView).offset(-12)
                make.centerY.equalTo(sectionHeaderView)
                make.size.equalTo(CGSize(width: 40, height: 25))
            }
            
            groupLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(titleLabel.snp.right).offset(5)
                make.centerY.equalTo(sectionHeaderView)
                make.height.equalTo(10)
            })
            
            if section == 1 {
                groupLabel.text = "(\(showRoomDetailData?.group?.count ?? 0))"
            }else if section == 2 {
                groupLabel.text = "(\(showRoomDetailData?.member?.count ?? 0))"
            }else if section == 3 {
                if showRoomDetailData != nil {
                    let count = (showRoomDetailData?.recentNews?.count)! + (showRoomDetailData?.gambit?.count)! + (self.newsData.count)
                    groupLabel.text = "(\(count))"
                }else {
                    groupLabel.text = "(0)"
                }
                
            }

            // 添加手势
            if section == 6 {
                let tap = UITapGestureRecognizer(target: self, action: #selector(applyToEnter(tap:)))
                tap.numberOfTapsRequired = 1
                tap.numberOfTouchesRequired = 1
                sectionHeaderView.addGestureRecognizer(tap)
            }
            
        }else if section == 4 || section == 5 {
            return UIView()
        }else {
            // 评论
            if section == 7 {
                let commentLabel = UILabel()
                if showRoomDetailData == nil {
                    commentLabel.text = "0"
                }else {
                    commentLabel.text = "(\(showRoomDetailData!.plcount!))"
                }
                
                commentLabel.font = UIFont.systemFont(ofSize: 13)
                sectionHeaderView.addSubview(commentLabel)
                
                commentLabel.snp.makeConstraints({ (make) in
                    make.left.equalTo(titleLabel.snp.right).offset(5)
                    make.centerY.equalTo(sectionHeaderView)
                    make.height.equalTo(10)
                })
//
//                let commentButton = UIButton()
//                commentButton.tag = section
//                commentButton.titleLabel?.textAlignment = .right
//                commentButton.setTitle("我要评论", for: .normal)
//                commentButton.setTitleColor(UIColor.black, for: .normal)
//                commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
//                commentButton.addTarget(self, action: #selector(showMore(sender:)), for: .touchUpInside)
//                sectionHeaderView.addSubview(commentButton)
//
//                commentButton.snp.makeConstraints({ (make) in
//                    make.right.equalTo(sectionHeaderView).offset(-13)
//                    make.centerY.equalTo(sectionHeaderView)
//                    make.height.equalTo(40)
//                })

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
        if section == 4 || section == 5 {
            return 0.0001
        }
        return 40
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if showRoomDetailData?.announ?[0].announTitle != nil {
                let announce = AnnouncementViewController()
                announce.announcementId = showRoomDetailData?.announ?[0].announId
                navigationController?.pushViewController(announce, animated: true)
            }
        }
        if indexPath.section == 3 { //资讯
            if (showRoomDetailData?.recentNews?.count)! > 0 {
                let news = RoomNewsDetailViewController()
                news.newsPhoto = showRoomDetailData?.recentNews?[indexPath.row].infoImageArr?[0] ?? ""
                news.newsId = showRoomDetailData?.recentNews?[indexPath.row].newsId ?? ""
                news.newsTitle = showRoomDetailData?.recentNews?[indexPath.row].infoTitle ?? ""
                news.commentNumber = showRoomDetailData?.recentNews?[indexPath.row].infoComment ?? "0"
                navigationController?.pushViewController(news, animated: true)
            }
            
        }
        if indexPath.section == 4 {  //话题
            let newsDetail = TalkNewsDetailsViewController()
            newsDetail.newsTitle = showRoomDetailData?.gambit?[indexPath.row].infoTitle
            newsDetail.newsId = showRoomDetailData?.gambit?[indexPath.row].newsId
            newsDetail.commentNumber = showRoomDetailData?.gambit?[indexPath.row].infoComment
            navigationController?.pushViewController(newsDetail, animated: true)
        }
        if indexPath.section == 5 {  //社区
            let moreCommenityVC = MoreCommunityViewController()
            let statement = self.newsDataAll[indexPath.row]
            moreCommenityVC.dataId = statement.statement._id
            navigationController?.pushViewController(moreCommenityVC, animated: true)
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
                cell.delegate = self
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

extension ShowroomDetailsViewController: ShowroomMemberAttentionDelegate {
    func attentionActionCell(_ IntelligentCell: ShowroomMemberCell, intelligentModel model: MemberModel) {
        if model.isFllow == "1" { //已关注
            
            NetRequest.addOrCancelAttentionNetRequest(method: "DELETE", mid: AppInfo.shared.user?.userId ?? "", follow_who: model.memberId ?? "") { (success, info) in
                
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    
                    IntelligentCell.followButton.adjustsImageWhenHighlighted = false
                    IntelligentCell.followButton.backgroundColor = UIColor.themeColor
                    IntelligentCell.followButton.setTitle("关注", for: .normal)
                    IntelligentCell.followButton.setTitleColor(UIColor.white, for: .normal)
                    model.isFllow = "0"
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
            
            
        } else {
            NetRequest.addOrCancelAttentionNetRequest(method: "POST", mid: AppInfo.shared.user?.userId ?? "", follow_who: model.memberId ?? "") { (success, info) in
                
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    
                    IntelligentCell.followButton.adjustsImageWhenHighlighted = false
                    IntelligentCell.followButton.backgroundColor = UIColor.white
                    IntelligentCell.followButton.setTitle("已关注", for: .normal)
                    IntelligentCell.followButton.setTitleColor(UIColor.themeColor, for: .normal)
                    model.isFllow = "1"
                    
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
        }
    }
    
    func getLabHeight(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width: width, height: 1000)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize.height
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


extension ShowroomDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let token = AppInfo.shared.user?.token ?? ""
        if token == "" {
            GeneralMethod.alertToLogin(viewController: self)
            return false
        }
        
        NetRequest.issueCommentNetRequest(openId: token, groupId: roomId ?? "", content: textField.text!, pid: "") { (success, info, result) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info!)

                textField.text = ""
                textField.resignFirstResponder()
                self.loadShowRoomDetailData(requestType: .update)
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
        
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}
