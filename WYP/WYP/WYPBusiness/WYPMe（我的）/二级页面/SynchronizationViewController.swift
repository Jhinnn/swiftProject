//
//  SynchronizationViewController.swift
//  WYP
//
//  Created by aLaDing on 2018/3/20.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit


typealias closureBlock = ([String],[String],[String],[String]) -> Void

class SynchronizationViewController: BaseViewController {
    

    var postValueBlock: closureBlock?
    
    var synRoomCollectionView:UICollectionView? //同步展厅
    var synGroupCollectionView:UICollectionView? //同步群组
    var synTypeCollectionView:UICollectionView? //同步话题类型
    var synTopicTableView:UITableView? //同步话题
    
    var synRoomViewGlobal:UIView? //展厅
    var synGroupViewGlobal:UIView? //群组
    var synTypeViewGlobal:UIView? //话题类型
    var synTopicViewGlobal:UIView? //话题类型
    
    var synRoomRightImage:UIImageView?
    var synGroupRightImage:UIImageView?
    var synTypeRightImage:UIImageView?
    var synTopicRightImage:UIImageView?

    var synGroupCountLabel:UILabel?
    var synRoomCountLabel:UILabel?
 
    
    //记录 展厅 点击View的转态: 0--未点开 1--点开
    var RoomClickStatus:NSInteger = 0
    //记录 群组 点击View的转态: 0--未点开 1--点开
    var GroupClickStatus:NSInteger = 0
    //记录 话题类型 点击View的转态: 0--未点开 1--点开
    var TypeClickStatus:NSInteger = 0
    //记录 话题 点击View的转态: 0--未点开 1--点开
    var TopicClickStatus:NSInteger = 0
    
    var synroomArray = [SynRoomModel]()
    var syngroupArray = [SynGroupModel]()
    var syntypeArray = [SynTypeModel]()
    var syntopicArray = [SynTopicModel]()

    
    var synRoomIdArray = [String]()  //存放选中展厅ID数组
    var synGroupIdArray = [String]()  //存放选中展厅ID数组
    var synTypeIdArray = [String]()  //存放选中话题类型ID数组
    var synTopicIdArray = [String]()  //存放选中话题ID数组
    
    
    var ViewH = 0.0
    
    var imageV:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "同步"
        view.backgroundColor = UIColor.groupTableViewBackground
        
        setupUI()
        
        layoutPageSubviews()
        
        
        loadNetData()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(synCompletAction))
        
    }
    
    
    
    // MARK: -完成按钮
    func synCompletAction() {
        if postValueBlock != nil {
            
        
            self.postValueBlock!(synRoomIdArray,synGroupIdArray,synTypeIdArray,synTopicIdArray)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK : - 数据加载
    func loadNetData() {
        NetRequest.synchronizationListNetRequest { (success, info, dic) in
            if success {
                
                //展厅
                let groupArray = dic!.value(forKey: "group")
                let groupdata = try! JSONSerialization.data(withJSONObject: groupArray!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let groupjsonString = NSString(data: groupdata, encoding: String.Encoding.utf8.rawValue)! as String
                self.synroomArray = [SynRoomModel].deserialize(from: groupjsonString) as! [SynRoomModel]
                
                self.synGroupCountLabel?.text = "(\(self.synroomArray.count))"
                
                
                var GH = 0
                if self.synroomArray.count % 4 != 0{
                    GH = Int(CGFloat(Int(self.synroomArray.count / 4) + 1) * (kScreen_width / 4 * 1.2))
                }else {
                    GH = Int(CGFloat(Int(self.synroomArray.count / 4)) * (kScreen_width / 4 * 1.2))
                }
                
                
                //群组
                let roomArray = dic!.value(forKey: "qunzu")
                let roomdata = try! JSONSerialization.data(withJSONObject: roomArray!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let roomjsonString = NSString(data: roomdata, encoding: String.Encoding.utf8.rawValue)! as String
                self.syngroupArray = [SynGroupModel].deserialize(from: roomjsonString) as! [SynGroupModel]
                
                self.synRoomCountLabel?.text = "(\(self.syngroupArray.count))"
          
                
                var RH = 0
                if self.syngroupArray.count % 4 != 0{
                    RH = Int(CGFloat(Int(self.syngroupArray.count / 4) + 1) * (kScreen_width / 4 * 1.2))
                }else {
                    RH = Int(CGFloat(Int(self.syngroupArray.count / 4)) * (kScreen_width / 4 * 1.2))
                }
                
                //话题类型
                let typeArray = dic!.value(forKey: "category")
                let typedata = try! JSONSerialization.data(withJSONObject: typeArray!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let typejsonString = NSString(data: typedata, encoding: String.Encoding.utf8.rawValue)! as String
                self.syntypeArray = [SynTypeModel].deserialize(from: typejsonString) as! [SynTypeModel]
                
                //话题
                let topicArray = dic!.value(forKey: "gambit")
                let topicdata = try! JSONSerialization.data(withJSONObject: topicArray!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let topicjsonString = NSString(data: topicdata, encoding: String.Encoding.utf8.rawValue)! as String
                self.syntopicArray = [SynTopicModel].deserialize(from: topicjsonString) as! [SynTopicModel]
                
                var TH = 0
                for model in self.syntopicArray {
                    if model.new_type == "0" || model.new_type == "2" || model.new_type == "3" {
                        TH += Int(109 * width_height_ratio)
                    }else if model.new_type == "1" { //文字
                        TH += Int(87 * width_height_ratio)
                    }else if model.new_type == "4" {
                        TH += Int(160 * width_height_ratio)
                    }
                }
                
                self.scrollView.contentSize = CGSize(width: kScreen_width, height: CGFloat(GH) + CGFloat(RH) + CGFloat(TH) + 310)
            }
        }
    }
    
    lazy var scrollView: UIScrollView = {

        let scrollView = UIScrollView(frame: CGRect.zero)
        scrollView.backgroundColor = UIColor.groupTableViewBackground
//        scrollView.contentSize = CGSize(width: kScreen_width, height: kScreen_height * 4)
        
        return scrollView
    }()
    
 

    
    // MARK: - 展厅列表
    lazy var roomCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: kScreen_width / 4, height: kScreen_width / 4 * 1.2)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        let roomCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        roomCollectionView.backgroundColor = UIColor.white
        roomCollectionView.isScrollEnabled = false
        roomCollectionView.delegate = self
        roomCollectionView.dataSource = self
        roomCollectionView.register(UINib(nibName: "SynCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "synRoomIndentity")
        //注册
        return roomCollectionView
    }()
    
    // MARK: - 群组列表
    lazy var groupCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: kScreen_width / 4, height: kScreen_width / 4 * 1.2)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        let groupCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        groupCollectionView.backgroundColor = UIColor.white
        groupCollectionView.isScrollEnabled = false
        groupCollectionView.delegate = self
        groupCollectionView.dataSource = self
        groupCollectionView.register(UINib(nibName: "SynGourpCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "synGroupIndentity")
        //注册
        return groupCollectionView
    }()
    
    // MARK: - 话题类型
    lazy var typeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: (kScreen_width - 25) / 6, height: (kScreen_width - 25) / 6)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        let typeCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        typeCollectionView.backgroundColor = UIColor.white
        typeCollectionView.isScrollEnabled = false
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        typeCollectionView.register(UINib(nibName: "TypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "synTypeIndentity")
        //注册
        return typeCollectionView
    }()
    
    // MARK: - 话题
    lazy var topicTabelView: UITableView = {
        let tabelView = UITableView()
        tabelView.isScrollEnabled = false
        tabelView.tableFooterView = UIView()
        tabelView.rowHeight = 109
        tabelView.delegate = self
        tabelView.dataSource = self
        
        
        tabelView.register(TalkOnePictureTableViewCell.self, forCellReuseIdentifier: "onePicCell")
        tabelView.register(TalkTravelTableViewCell.self, forCellReuseIdentifier: "textCell")
        tabelView.register(TalkThreePictureTableViewCell.self, forCellReuseIdentifier: "threePicCell")
        tabelView.register(TalkVideoInfoTableViewCell.self, forCellReuseIdentifier: "bigPicCell")
        
        
        return tabelView
    }()
    
    //MARK: --视图添加
    func setupUI(){
        
        
        view.addSubview(scrollView)
        
        
        //同步展厅
        let groupView = UIView()
        groupView.backgroundColor = UIColor.white
        
        let rightImageView = UIImageView()
        
        synRoomRightImage = rightImageView
        rightImageView.image = UIImage(named: "synchro_icon_more_normal")
        groupView.addSubview(rightImageView) //添加图标
        
        rightImageView.snp.makeConstraints { (make) in
            make.right.equalTo(groupView).offset(-10)
            make.centerY.equalTo(groupView)
            make.width.equalTo(13)
            make.height.equalTo(18)
        }
        
        
        let synGroupViewNameLabel = UILabel()
        synGroupViewNameLabel.text = "同步至展厅"
        synGroupViewNameLabel.font = UIFont.boldSystemFont(ofSize: 19)
        synGroupViewNameLabel.textColor = UIColor.black
        groupView.addSubview(synGroupViewNameLabel)
        
        synGroupViewNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(groupView.snp.centerY)
            make.left.equalTo(groupView).offset(10)
        }
        
        
        
        //展厅数量
        let synGroupViewCountLabel = UILabel()
        synGroupViewCountLabel.font = UIFont.systemFont(ofSize: 15)
        groupView.addSubview(synGroupViewCountLabel)
        synGroupViewCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(groupView.snp.centerY)
            make.left.equalTo(synGroupViewNameLabel.snp.right).offset(2)
        }
        synGroupCountLabel = synGroupViewCountLabel
        
        
        
        
        scrollView.addSubview(groupView)
        
        
        
        
        synRoomViewGlobal = groupView
        
        //同步社区--添加手势
        let clicksynRoomViewGesture = UITapGestureRecognizer(target: self, action: #selector(clicksynRoomViewTap))
        groupView.addGestureRecognizer(clicksynRoomViewGesture)
        
        
        
        //群组--添加tableView
        let collectionview = roomCollectionView
        scrollView.addSubview(collectionview)
        synRoomCollectionView = collectionview
        
        //同步群组
       
        let roomView = UIView()
        roomView.backgroundColor = UIColor.white
        
        let rightRoomImageView = UIImageView()
        
        synGroupRightImage = rightRoomImageView
        rightRoomImageView.image = UIImage(named: "synchro_icon_more_normal")
        roomView.addSubview(rightRoomImageView) //添加图标
        
        rightRoomImageView.snp.makeConstraints { (make) in
            make.right.equalTo(roomView).offset(-10)
            make.centerY.equalTo(roomView)
            make.width.equalTo(13)
            make.height.equalTo(18)
        }
        
        
        let synRoomViewNameLabel = UILabel()
        synRoomViewNameLabel.text = "同步至群组"
        synRoomViewNameLabel.font = UIFont.boldSystemFont(ofSize: 19)
        synRoomViewNameLabel.textColor = UIColor.black
        roomView.addSubview(synRoomViewNameLabel)
        
        synRoomViewNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(roomView.snp.centerY)
            make.left.equalTo(roomView).offset(10)
        }
        
        //展厅数量
        let synRoomViewCountLabel = UILabel()
        synRoomViewCountLabel.font = UIFont.systemFont(ofSize: 15)
        roomView.addSubview(synRoomViewCountLabel)
        synRoomViewCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(roomView.snp.centerY)
            make.left.equalTo(synRoomViewNameLabel.snp.right).offset(2)
        }
        synRoomCountLabel = synRoomViewCountLabel
        
        
        
        scrollView.addSubview(roomView)
        
        
        
        
        
        
        synGroupViewGlobal = roomView
        
        //同步群组--添加手势
        let clicksynGroupViewGesture = UITapGestureRecognizer(target: self, action: #selector(clicksynGroupViewTap))
        roomView.addGestureRecognizer(clicksynGroupViewGesture)
        //群组--添加tableView
        
        let grpCollectionView = groupCollectionView
        scrollView.addSubview(grpCollectionView)
        synGroupCollectionView = grpCollectionView
        
        
        
        //同步话题类型
        
        let typeView = UIView()
        typeView.backgroundColor = UIColor.white
        
        let rightTypeImageView = UIImageView()
        
        synTypeRightImage = rightTypeImageView
        rightTypeImageView.image = UIImage(named: "synchro_icon_more_normal")
        typeView.addSubview(rightTypeImageView) //添加图标
        
        rightTypeImageView.snp.makeConstraints { (make) in
            make.right.equalTo(typeView).offset(-10)
            make.centerY.equalTo(typeView)
            make.width.equalTo(13)
            make.height.equalTo(18)
        }
        
        
        let synTypeViewNameLabel = UILabel()
        synTypeViewNameLabel.text = "同步至话题"
        synTypeViewNameLabel.font = UIFont.boldSystemFont(ofSize: 19)
        synTypeViewNameLabel.textColor = UIColor.black
        typeView.addSubview(synTypeViewNameLabel)
        
        synTypeViewNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(typeView.snp.centerY)
            make.left.equalTo(typeView).offset(10)
        }
        
        
        
        let synTypeViewCountLabel = UILabel()
        synTypeViewCountLabel.font = UIFont.systemFont(ofSize: 15)
        synTypeViewCountLabel.text = "(话题类型)"
        typeView.addSubview(synTypeViewCountLabel)
        synTypeViewCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(typeView.snp.centerY)
            make.left.equalTo(synTypeViewNameLabel.snp.right).offset(2)
        }
        
        scrollView.addSubview(typeView)
        
        
        synTypeViewGlobal = typeView
        
        //同步群组--添加手势
        let clicksynTypeViewGesture = UITapGestureRecognizer(target: self, action: #selector(clicksynTypeViewTap))
        typeView.addGestureRecognizer(clicksynTypeViewGesture)
        //群组--添加tableView
        
        let typesCollectionView = typeCollectionView
        scrollView.addSubview(typesCollectionView)
        synTypeCollectionView = typesCollectionView
        
        
        //4.同步话题
        
        let topicView = UIView()
        topicView.backgroundColor = UIColor.white
        
        let rightTopicImageView = UIImageView()
        
        synTopicRightImage = rightTopicImageView
        rightTopicImageView.image = UIImage(named: "synchro_icon_more_normal")
        topicView.addSubview(rightTopicImageView) //添加图标
        
        rightTopicImageView.snp.makeConstraints { (make) in
            make.right.equalTo(topicView).offset(-10)
            make.centerY.equalTo(topicView)
            make.width.equalTo(13)
            make.height.equalTo(18)
        }
        
        
        let synTopicViewNameLabel = UILabel()
        synTopicViewNameLabel.text = "同步至话题"
        synTopicViewNameLabel.font = UIFont.boldSystemFont(ofSize: 19)
        synTopicViewNameLabel.textColor = UIColor.black
        topicView.addSubview(synTopicViewNameLabel)
        
        synTopicViewNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(topicView.snp.centerY)
            make.left.equalTo(topicView).offset(10)
        }
        
        
        let synTopicViewCountLabel = UILabel()
        synTopicViewCountLabel.font = UIFont.systemFont(ofSize: 15)
        synTopicViewCountLabel.text = "(我的话题)"
        topicView.addSubview(synTopicViewCountLabel)
        synTopicViewCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(topicView.snp.centerY)
            make.left.equalTo(synTopicViewNameLabel.snp.right).offset(2)
        }
        
        
        scrollView.addSubview(topicView)
        
        
        synTopicViewGlobal = topicView
        
        //同步话题--添加手势
        let clicksynTopicViewGesture = UITapGestureRecognizer(target: self, action: #selector(clicksynTopicViewTap))
        topicView.addGestureRecognizer(clicksynTopicViewGesture)
        //群组--添加tableView
        
        let topicstableView = topicTabelView
        scrollView.addSubview(topicstableView)
        synTopicTableView = topicstableView
        
        
    }
    
    //MARK: --视图位置
    func layoutPageSubviews() {
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
       

        synRoomViewGlobal?.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp.top).offset(0)
            make.width.equalTo(kScreen_width)
            make.height.equalTo(56)
        }
        
        synRoomCollectionView?.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo((synRoomViewGlobal?.snp.bottom)!)
            make.height.equalTo(0)
        }
        
        synGroupViewGlobal?.snp.makeConstraints { (make) in
            make.top.equalTo((synRoomCollectionView?.snp.bottom)!).offset(4)
            make.width.equalTo(kScreen_width)
            make.height.equalTo(56)
        }
        synGroupCollectionView?.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo((synGroupViewGlobal?.snp.bottom)!)
            make.height.equalTo(0)
        }
        
        synTypeViewGlobal?.snp.makeConstraints { (make) in
            make.top.equalTo((synGroupCollectionView?.snp.bottom)!).offset(4)
            make.width.equalTo(kScreen_width)
            make.height.equalTo(56)
        }
        
        synTypeCollectionView?.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo((synTypeViewGlobal?.snp.bottom)!)
            make.height.equalTo(0)
        }
 
        synTopicViewGlobal?.snp.makeConstraints { (make) in
            make.top.equalTo((synTypeCollectionView?.snp.bottom)!).offset(4)
            make.width.equalTo(kScreen_width)
            make.height.equalTo(56)
        }
        
        synTopicTableView?.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo((synTopicViewGlobal?.snp.bottom)!)
            make.height.equalTo(0)
        }
       
        
    }
     
    
    
    
    // MARK: --展厅点击事件
    func clicksynRoomViewTap() {
        if RoomClickStatus == 0 {
            RoomClickStatus = 1
            
            //第一次刷新一次
            var refreashRoom = true
            if refreashRoom {
                synRoomCollectionView?.reloadData()
                refreashRoom = false
            }
            
            //计算我管理群组collView的高度
            var myManageRoomTableViewHeight = 0
            if self.synroomArray.count % 4 != 0 {
                myManageRoomTableViewHeight = Int(CGFloat(Int(self.synroomArray.count / 4) + 1) * (kScreen_width / 4 * 1.2))
            }else {
                myManageRoomTableViewHeight = Int(CGFloat(Int(self.synroomArray.count / 4)) * (kScreen_width / 4 * 1.2))
            }
            
            
            let referenceHeight1 = view.frame.maxY
            let referenceHeight2 = synRoomViewGlobal?.frame.maxY
            let referenceHeight = referenceHeight1 - referenceHeight2!
            if (CGFloat(myManageRoomTableViewHeight) > referenceHeight) {
                synRoomCollectionView?.snp.updateConstraints({ (make) in
                    make.height.equalTo(referenceHeight)
                })
            }else{
                synRoomCollectionView?.snp.updateConstraints({ (make) in
                    make.height.equalTo(myManageRoomTableViewHeight)
                })
            }
            
            synRoomRightImage?.transform = CGAffineTransform(rotationAngle: 1.57)
            view.layoutIfNeeded()
            return
        }
        if RoomClickStatus == 1 {
            RoomClickStatus = 0
            synRoomCollectionView?.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            synRoomRightImage?.transform = CGAffineTransform(rotationAngle: .pi*2*360/360)
            view.layoutIfNeeded()
            return
        }
    }
    
    // MARK: --群组点击事件
    func clicksynGroupViewTap() {
        if GroupClickStatus == 0 {
            GroupClickStatus = 1
            
            //第一次刷新一次
            var refreashRoom = true
            if refreashRoom {
                synGroupCollectionView?.reloadData()
                refreashRoom = false
            }
            
            
            //计算collectionview高度
            var myManageGroupTableViewHeight = 0
            if self.syngroupArray.count % 4 == 0 {
                myManageGroupTableViewHeight = Int(CGFloat(Int(self.syngroupArray.count / 4)) * (kScreen_width / 4 * 1.2))
            }else {
                myManageGroupTableViewHeight = Int(CGFloat(Int(self.syngroupArray.count / 4) + 1) * (kScreen_width / 4 * 1.2))
            }
  
            let referenceHeight1 = view.frame.maxY
            let referenceHeight2 = synGroupViewGlobal?.frame.maxY
            let referenceHeight = referenceHeight1 - referenceHeight2!
            if (CGFloat(myManageGroupTableViewHeight) > referenceHeight) {
                synGroupCollectionView?.snp.updateConstraints({ (make) in
                    make.height.equalTo(myManageGroupTableViewHeight)
                })
            }else{
                synGroupCollectionView?.snp.updateConstraints({ (make) in
                    make.height.equalTo(myManageGroupTableViewHeight)
                })
            }
            synGroupRightImage?.transform = CGAffineTransform(rotationAngle: 1.57)
            view.layoutIfNeeded()
            return
        }
        if GroupClickStatus == 1 {
            GroupClickStatus = 0
            synGroupCollectionView?.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            synGroupRightImage?.transform = CGAffineTransform(rotationAngle: .pi*2*360/360)
            view.layoutIfNeeded()
            return
        }
    }
    
    
    // MARK: --话题类型点击事件
    func clicksynTypeViewTap() {
        if TypeClickStatus == 0 {
            TypeClickStatus = 1
            
            //第一次刷新一次
            var refreashRoom = true
            if refreashRoom {
                synTypeCollectionView?.reloadData()
                refreashRoom = false
            }
            
            
            //计算我管理群组tableView的高度
            
            synTypeCollectionView?.snp.updateConstraints({ (make) in
                make.height.equalTo(70)
            })
            
            synTypeRightImage?.transform = CGAffineTransform(rotationAngle: 1.57)
            view.layoutIfNeeded()
            return
        }
        if TypeClickStatus == 1 {
            TypeClickStatus = 0
            synTypeCollectionView?.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            synTypeRightImage?.transform = CGAffineTransform(rotationAngle: .pi*2*360/360)
            view.layoutIfNeeded()
            return
        }
    }
    
    // MARK: --话题类型点击事件
    func clicksynTopicViewTap() {
        if TopicClickStatus == 0 {
            TopicClickStatus = 1
            
            //第一次刷新一次
            var refreashRoom = true
            if refreashRoom {
                synTopicTableView?.reloadData()
                refreashRoom = false
            }
            
            
            var myManageTopicTableViewHeight = 0
            //计算我管理群组tableView的高度
            for model in self.syntopicArray {
                if model.new_type == "0" || model.new_type == "2" || model.new_type == "3" {
                    myManageTopicTableViewHeight += 109
                }else if model.new_type == "1" {
                    myManageTopicTableViewHeight += 98
                }else if model.new_type == "4" {
                    myManageTopicTableViewHeight += 160
                }
            }
            
            
            
            let referenceHeight1 = view.frame.maxY
            let referenceHeight2 = synTopicViewGlobal?.frame.maxY
            let referenceHeight = referenceHeight1 - referenceHeight2!
            if (CGFloat(myManageTopicTableViewHeight) > referenceHeight) {
                synTopicTableView?.snp.updateConstraints({ (make) in
                    make.height.equalTo(myManageTopicTableViewHeight)
                })
            }else{
                synTopicTableView?.snp.updateConstraints({ (make) in
                    make.height.equalTo(myManageTopicTableViewHeight)
                })
            }
            
            synTopicRightImage?.transform = CGAffineTransform(rotationAngle: 1.57)
            view.layoutIfNeeded()
            return
        }
        if TopicClickStatus == 1 {
            TopicClickStatus = 0
            synTopicTableView?.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            synTopicRightImage?.transform = CGAffineTransform(rotationAngle: .pi*2*360/360)
            view.layoutIfNeeded()
            return
        }
    }

}

extension SynchronizationViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.syntopicArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.syntopicArray[indexPath.row]
        
        switch model.new_type ?? "" {
        case "0":  //一图
            let cell = tableView.dequeueReusableCell(withIdentifier: "onePicCell", for: indexPath) as! TalkOnePictureTableViewCell
            cell.synTopicModel = self.syntopicArray[indexPath.row]
            return cell
        case "1":  //无图
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! TalkTravelTableViewCell
            cell.synTopicModel = self.syntopicArray[indexPath.row]
            return cell
        case "2"://一图
            let cell = tableView.dequeueReusableCell(withIdentifier: "onePicCell", for: indexPath) as! TalkOnePictureTableViewCell
            cell.synTopicModel = self.syntopicArray[indexPath.row]
            return cell
        case "3"://一图
            let cell = tableView.dequeueReusableCell(withIdentifier: "onePicCell", for: indexPath) as! TalkOnePictureTableViewCell
            cell.synTopicModel = self.syntopicArray[indexPath.row]
            return cell
        case "4": //三图
            let cell = tableView.dequeueReusableCell(withIdentifier: "threePicCell", for: indexPath) as! TalkThreePictureTableViewCell
            cell.synTopicModel = self.syntopicArray[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        switch self.syntopicArray[indexPath.row].new_type ?? "" {  ////2大图  4三图  3左文右图  1文字
        case "0":
            return 109
        case "1":
            return 87.5 * width_height_ratio
        case "2":
            return 109
        case "3":
            return 109 * width_height_ratio
        case "4":
            let titleH = self.getLabHeight(labelStr: self.syntopicArray[indexPath.row].title!, font: UIFont.systemFont(ofSize: 16), width: kScreen_width - 26)
            if titleH > 20 {
                return 180 * width_height_ratio
            }
            
            return 160 * width_height_ratio
        default:
            return 0
        
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //选中同步话题回答
        for cell in (synTypeCollectionView?.visibleCells)! {
            let btn = cell.contentView.viewWithTag(53) as! UIButton
                btn.isSelected = false
        }
        self.synTypeIdArray.removeAll()
        
        //清空选中话题回答ID数组
        self.synTopicIdArray.removeAll()
        
        let model = self.syntopicArray[indexPath.row]
        self.synTopicIdArray.append(model.id!)
        
        
        let cell = tableView.cellForRow(at: indexPath)
        let tipV = UIImageView()
        self.imageV = tipV
        tipV.image = UIImage.init(named: "synchro_icon_pitch_normal")
        cell?.contentView.addSubview(tipV)
        tipV.snp.makeConstraints { (make) in
            make.center.equalTo((cell?.contentView)!)
            cell?.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        
        cell?.backgroundColor = UIColor.groupTableViewBackground
    }
 
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)

        self.imageV?.removeFromSuperview()
        
        cell?.backgroundColor = UIColor.white
    }
    
    
    
    func getLabHeight(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width: width, height: 1000)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize.height
    }
}



extension SynchronizationViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.isEqual(synRoomCollectionView) { //展厅
            return self.synroomArray.count
        }
        if collectionView.isEqual(synGroupCollectionView) { //群组
            return self.syngroupArray.count
        }
        if collectionView.isEqual(synTypeCollectionView) { // 话题类型
            return self.syntypeArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if self.synroomArray.count != 0 {
            if collectionView.isEqual(synRoomCollectionView) {
                let collctionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "synRoomIndentity", for: indexPath) as! SynCollectionViewCell
                let model = self.synroomArray[indexPath.item]
                collctionCell.synRoomModel = model
                
                let imageV = collctionCell.contentView.viewWithTag(51) as! UIImageView
                if self.synRoomIdArray.contains(model.id!) {
                    imageV.isHidden = false
                }else {
                    imageV.isHidden = true
                }
                return collctionCell
            }
        }
        if self.syngroupArray.count != 0 {
            if collectionView.isEqual(synGroupCollectionView) {
                let collctionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "synGroupIndentity", for: indexPath) as! SynGourpCollectionViewCell
                let model = self.syngroupArray[indexPath.item]
                collctionCell.synGroupModel = model
                let imageV = collctionCell.contentView.viewWithTag(52) as! UIImageView
                if self.synGroupIdArray.contains(model.id!) {
                    imageV.isHidden = false
                }else {
                    imageV.isHidden = true
                }
                return collctionCell
            }
        }
        if self.syntypeArray.count != 0 {
            if collectionView.isEqual(synTypeCollectionView) {
                let collctionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "synTypeIndentity", for: indexPath) as! TypeCollectionViewCell
                let model = self.syntypeArray[indexPath.item]
                
                let btn = collctionCell.contentView.viewWithTag(53) as! UIButton
                if self.synTypeIdArray.contains(model.id!) {
                    btn.isSelected = true
                }else {
                    btn.isSelected = false
                }
                collctionCell.synTypeModel = model
                
                return collctionCell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isEqual(synRoomCollectionView) {
            let cell = collectionView.cellForItem(at: indexPath)
            let imageV = cell?.contentView.viewWithTag(51) as! UIImageView
            let synRoomModel = self.synroomArray[indexPath.item]
            imageV.isHidden = !imageV.isHidden
            
            if !imageV.isHidden {  //选中
                self.synRoomIdArray.append(synRoomModel.id!)
            }else {
                self.synRoomIdArray.remove(at: self.synRoomIdArray.index(of: synRoomModel.id!)!)
            }
            
        }
        if collectionView.isEqual(synGroupCollectionView) {
            let cell = collectionView.cellForItem(at: indexPath)
            let imageV = cell?.contentView.viewWithTag(52) as! UIImageView
            let synGroupModel = self.syngroupArray[indexPath.item]
            imageV.isHidden = !imageV.isHidden
            
            if !imageV.isHidden {  //选中
                self.synGroupIdArray.append(synGroupModel.id!)
            }else {
                self.synGroupIdArray.remove(at: self.synGroupIdArray.index(of: synGroupModel.id!)!)
            }
            
        }
        if collectionView.isEqual(synTypeCollectionView) {
            
            self.imageV?.removeFromSuperview()
            self.synTopicIdArray.removeAll()
            for cell in (synTopicTableView?.visibleCells)! {  //选中话题类型，取消话题回答选中cell
                cell.backgroundColor = UIColor.white
            }

            let cell = collectionView.cellForItem(at: indexPath)
            let synTypeModel = self.syntypeArray[indexPath.item]
            let btn = cell?.contentView.viewWithTag(53) as! UIButton
            
        
            btn.isSelected = !btn.isSelected
            if btn.isSelected {
                if self.synTypeIdArray.count != 0 {  //此时有被选中话题类型
                    for cell in collectionView.visibleCells {
                        let btn = cell.contentView.viewWithTag(53) as! UIButton
                        if btn.isSelected {
                            btn.isSelected = false
                        }
                    }
                    
                }
                self.synTypeIdArray.removeAll()
                btn.isSelected = true
                
                self.synTypeIdArray.append(synTypeModel.id!)
                
            }else {
                self.synTypeIdArray.remove(at: self.synTypeIdArray.index(of: synTypeModel.id!)!)
            }
            
            
            print(self.synTypeIdArray)
        }
    }
    
    
}
