//
//  ContactsViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/3/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ContactsViewController: BaseViewController {

    var indexArray : NSMutableArray? = NSMutableArray()
    var letterResultArray : NSMutableArray? = NSMutableArray()
    var titleArray = ["通过手机号/阿拉丁号添加好友","通过通讯录添加好友"]
    var firstSectionArray = ["address_icon_cellphone_normal","address_icon_telephone_normal"]
    var personSource = [PersonModel]()
    
    var timer: Timer?
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        layoutPageSubViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        
    }
    
    
    // MARK: - private method
    func viewConfig() {
        view.addSubview(friendsTableView)
        view.addSubview(sectionTitleView)
    }
    func layoutPageSubViews() {
        friendsTableView.snp.makeConstraints { (make) in
            if deviceTypeIPhoneX() {
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 108 + 34, 0))
            }else {
                make.edges.equalTo(UIEdgeInsetsMake(0, 0, 108, 0))
            }
            
        }
        sectionTitleView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
    }
    // 显示当前所在组
    func showSectionTitle(_ sender : String){
        sectionTitleView.text = sender
        sectionTitleView.isHidden = false
        sectionTitleView.alpha = 1.0
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerSelector), userInfo: nil, repeats: false)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    func loadData() {
        NetRequest.friendsListNetRequest(openId: AppInfo.shared.user?.token ?? "", page: "") { (success, info, result) in
            if success {
                let array = result!.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                self.personSource = [PersonModel].deserialize(from: jsonString) as! [PersonModel]
                
                
                // 先移除再添加
                self.noDataImageView.removeFromSuperview()
                self.noDataLabel.removeFromSuperview()
                // 没有数据的时候
                self.view.addSubview(self.noDataImageView)
                self.view.addSubview(self.noDataLabel)
                self.noDataImageView.snp.makeConstraints { (make) in
                    if deviceTypeIphone5() || deviceTypeIPhone4() {
                        make.top.equalTo(self.view).offset(130)
                    }
                    make.top.equalTo(self.view).offset(180)
                    make.centerX.equalTo(self.view)
                    make.size.equalTo(CGSize(width: 100, height: 147))
                }
                self.noDataLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(self.noDataImageView.snp.bottom).offset(10)
                    make.centerX.equalTo(self.view)
                    make.height.equalTo(11)
                }
                
                self.loadDataSource()
                self.friendsTableView.reloadData()
            } else {
                print(info!)
            }
        }
    }
    //初始化数据
    func loadDataSource() {
        var nameArr = [String]()
        for person in personSource {
            nameArr.append(person.name)
        }
        indexArray = ChineseString.indexArray(nameArr)
        letterResultArray = ChineseString.letterSortArray(nameArr)
    }
    
    // MARK: - event response
    // 定时器响应事件
    func timerSelector(_ timer : Timer){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.sectionTitleView.alpha = 0
                }, completion: { (finished) in
                    self.sectionTitleView.isHidden = true
            })
        }
    }
    
    // MARK: - setter
    lazy var friendsTableView: WYPTableView = {
        let friendsTableView = WYPTableView()
        friendsTableView.backgroundColor = UIColor.white
        friendsTableView.sectionIndexColor = UIColor.themeColor
        friendsTableView.tableFooterView = UIView()
        friendsTableView.rowHeight = 65
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        //注册
        friendsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        friendsTableView.register(GroupsTableViewCell.self, forCellReuseIdentifier: "friendCell")
        
        return friendsTableView
    }()
    lazy var sectionTitleView: UILabel = {
        let sectionTitleView = UILabel()
        sectionTitleView.textAlignment = NSTextAlignment.center
        sectionTitleView.font = UIFont.boldSystemFont(ofSize: 60)
        sectionTitleView.textColor = UIColor.themeColor
        sectionTitleView.backgroundColor = UIColor.white
        sectionTitleView.layer.cornerRadius = 6
        sectionTitleView.layer.borderWidth = 0.3 * UIScreen.main.scale
        sectionTitleView.layer.borderColor = UIColor.lightGray.cgColor
        sectionTitleView.isHidden = true
        return sectionTitleView
    }()
    
    // 没有数据时的图片
    lazy var noDataImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "common_noData_icon_normal_iPhone")
        return imageView
    }()
    // 没有数据时的提示文字
    lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "暂无好友"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if indexArray?.count == 0 {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
            
        }
        
        return indexArray!.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            if letterResultArray == nil {
                return 0
            }
            return (letterResultArray?[section - 1] as AnyObject).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            cell.textLabel?.text = titleArray[indexPath.row]
            cell.imageView?.image = UIImage(named: firstSectionArray[indexPath.row])
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! GroupsTableViewCell
            
            if letterResultArray == nil {
                return cell
            }
            
            let sectionTitles : NSArray = letterResultArray?.object(at: indexPath.section-1) as! NSArray
            print(sectionTitles)
            cell.groupTitleLabel.text = sectionTitles.object(at: indexPath.row) as? String
            
            for people in personSource {
                if people.name == cell.groupTitleLabel.text {
                    let imageUrl = URL(string: people.userImage ?? "")
                    cell.groupImageView.kf.setImage(with: imageUrl)
                }
            }
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: 20))
            view.backgroundColor = UIColor.groupTableViewBackground
            let label = UILabel.init(frame: CGRect.init(x: 13, y: 0, width: kScreen_width - 50, height: 20))
            label.backgroundColor = UIColor.groupTableViewBackground
            label.text = indexArray?[section-1] as? String
            label.textColor = UIColor.black
            view.addSubview(label)
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        showSectionTitle(title)
        return index
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return (indexArray! as NSArray) as? [String]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        } else {
           return 20
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0{
            navigationController?.pushViewController(SearchFriendsViewController(), animated: true)
        } else if indexPath.section == 0 && indexPath.row == 1 {
        navigationController?.pushViewController(ContactsFriendsViewController(), animated: true)
        } else {
            // 跳转朋友圈
//            let community = MyCommunityViewController()
//            let sectionTitles : NSArray = letterResultArray?.object(at: indexPath.section-1) as! NSArray
//            for people in personSource {
//                if people.name == sectionTitles.object(at: indexPath.row) as! String {
//                    community.userId = people.peopleId ?? ""
//                    community.headImageUrl = people.userImage ?? ""
//                    community.nickName = people.name
//                    community.fansCount = String.init(format: "粉丝:%@人", people.peopleFans ?? "0")
//                    community.friendsCountLabel.text = String.init(format: "好友:%@人", people.peopleFriends ?? "0")
//                }
//            }
//            community.type = "2"
//            community.isFollowed = true
//            navigationController?.pushViewController(community, animated: true)
            
            
//            // 跳转到聊天页面
//            let sectionTitles : NSArray = letterResultArray?.object(at: indexPath.section-1) as! NSArray
//            for people in personSource {
//                if people.name == sectionTitles.object(at: indexPath.row) as! String {
//                    let conversationVC = ChatDeatilViewController()
//                    conversationVC.conversationType = RCConversationType.ConversationType_PRIVATE
//                    conversationVC.targetId = people.peopleId
//                    conversationVC.title = people.name
//                    conversationVC.flag = 11
//                    navigationController?.pushViewController(conversationVC, animated: true)
//                }
//            }
            
            
            
            
            let sectionTitles : NSArray = letterResultArray?.object(at: indexPath.section-1) as! NSArray
            for people in personSource {
                if people.name == sectionTitles.object(at: indexPath.row) as! String {
                    // 跳转到个人资料页面
                    let personalInformationVC = PersonalInformationViewController()
                    personalInformationVC.conversationType = Int(RCConversationType.ConversationType_PRIVATE.rawValue)
                    personalInformationVC.targetId = people.peopleId
                    personalInformationVC.name = people.name
                    navigationController?.pushViewController(personalInformationVC, animated: true)
                }
            }
            
            
            
            
        }
    }
}
