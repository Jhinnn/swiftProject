//
//  ContactsFriendsViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/4.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import AddressBook

class ContactsFriendsViewController: BaseViewController {

    var tableView: UITableView!
    var dataArray:NSMutableArray?
    var subArray:NSMutableArray?
    var titleArray = NSMutableArray()
    var finalDataArray = NSMutableArray()
    
    
    
    
    
    
    /// 联系人模型数组
    var dataSourceArray = [PersonModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        // 1.获取授权的状态
        let status = ABAddressBookGetAuthorizationStatus()
        if status == ABAuthorizationStatus.authorized {
            UserDefaults.standard.set("1", forKey: "isVisit")
        }
        
        let isVisit = UserDefaults.standard.value(forKey: "isVisit") as? String
        if isVisit == "1" {
            getAddressBook()
        } else if isVisit == "0" {
            alertSetting()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        AddressBookHandle().requestAuthorizationWithSuccessClosure {
            self.getAddressBook()
        }
    }
    
    func viewConfig() {
        navigationItem.title = "通讯录添加好友"
        
        view.addSubview(searchBar)
        view.addSubview(friendsTableView)
        
        searchBar.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(44)
        }
        friendsTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(searchBar.snp.bottom)
        }
        
        // 没有通讯录内容时
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
    }
    
    // MARK: - 获取原始顺序联系人的模型数组
    func getAddressBook() {
        
        GetAddressBook.getOriginalAddressBook(addressBookArray: { (addressBookArray) in
            
            self.dataSourceArray = addressBookArray
            print(self.dataSourceArray)
            self.dealDataWithArray(array: self.dataSourceArray)
//            let nickName = self.returnFirstWordWithString(str: "安全")
//            let charArray:[CChar] = nickName.cString(using: String.Encoding.utf8)!
//            let firstWord = charArray[0]
//            print(firstWord)
            // 刷新单元格
            self.friendsTableView.reloadData()
            self.friendsTableView.mj_header.endRefreshing()
            
        }, authorizationFailure: {
            self.alertSetting()
        })
    }
    
    func alertSetting() {
        let alertViewVC = UIAlertController.init(title: "温馨提示", message: "请在iPhone的“设置-隐私-通讯录”选项中，允许阿拉丁访问您的通讯录", preferredStyle: UIAlertControllerStyle.alert)
        let confirm = UIAlertAction.init(title: "知道啦", style: .default) { (_) in
        }
        alertViewVC.addAction(confirm)
        self.present(alertViewVC, animated: true, completion: nil)
    }
    
    // MARK: - setter
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        
        searchBar.barStyle = .default
        searchBar.barTintColor = UIColor.white
        searchBar.contentMode = .left
        searchBar.placeholder = "输入您要查询的好友昵称"
        
        let searchField: UITextField = searchBar.value(forKey: "_searchField") as! UITextField
        searchField.backgroundColor = UIColor.init(hexColor: "#E8EAEB")
        return searchBar
    }()
    lazy var friendsTableView: WYPTableView = {
        let friendsTableView = WYPTableView()
        friendsTableView.rowHeight = 65
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        friendsTableView.tableFooterView = UIView()
        friendsTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getAddressBook()
        })

        //注册
        friendsTableView.register(AddFriendsTableViewCell.self, forCellReuseIdentifier: "contactsCell")
        
        return friendsTableView
    }()
    
    // 没有数据时的图片
    lazy var noDataImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "common_noResult_icon_normal_iPhone")
        return imageView
    }()
    // 没有找到结果
    lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "内容已飞外太空"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
    
    func returnFirstWordWithString(str:String) -> String {
        //将mutStr中的汉字转化为带音标的拼音（如果是汉字就转换，如果不是则保持原样）
        //2，由于汉字转拼音只能通过CoreFoundation框架转换，所以需要先把字符串转换成cf字符串
        let strToDealWith = NSMutableString.init(string: str) as CFMutableString
        //将带有音标的拼音转换成不带音标的拼音（这一步是从上一步的基础上来的，所以这两句话一句也不能少）
        //3，把cf字符串转换成带有音标的拼音，kCFStringTransformToLatin
         CFStringTransform(strToDealWith,nil, kCFStringTransformToLatin, false);
         CFStringTransform(strToDealWith, nil, kCFStringTransformStripCombiningMarks, false);
        let str2 = strToDealWith as String
        if str2.characters.count > 0{
        let index = str2.index(str.startIndex, offsetBy: 1)  //索引为从开始偏移5个位置
            print(str2.substring(to: index))
            let str3 = str2.substring(to: index)
            let str4 = str3.uppercased()
            print(str4)
            return str4
        }else{
             return ""
        }
    }
    
    func dealDataWithArray(array:[PersonModel]){
        dataArray = NSMutableArray()
        for _ in 0..<27 {
            let subArray = NSMutableArray()
            dataArray?.add(subArray)
            print(dataArray?.count ?? 27)
        }
        for modal:PersonModel in array {
            let nickName:String = returnFirstWordWithString(str: modal.name)
            print(nickName)
            let charArray:[CChar] = nickName.cString(using: String.Encoding.utf8)!
            let firstWord = charArray[0]
            print(firstWord)
            if firstWord >= 65 && firstWord<=90{
                let index:Int = Int(firstWord) - 65
                let arr:NSMutableArray = dataArray![index] as! NSMutableArray
                arr.add(modal)
                print(arr.count)
            }else{
                let arr:NSMutableArray = dataArray?.lastObject as! NSMutableArray
                arr.add(modal)
            }
        }
        print(dataArray)
//        finalDataArray = NSMutableArray()
        for array in dataArray! {
            if (array as AnyObject).count != 0{
                finalDataArray.add(array)
                let array2:NSMutableArray = array as! NSMutableArray
                let personModal:PersonModel = array2[0] as! PersonModel
                let nickName:String = returnFirstWordWithString(str: personModal.name)
                let charArray:[CChar] = nickName.cString(using: String.Encoding.utf8)!
                let firstWord = charArray[0]
                if firstWord >= 65 && firstWord<=90{
                    titleArray.add(nickName)
                }
            }
        }
        if titleArray.count != finalDataArray.count{
            titleArray.add("#")
        }
        self.friendsTableView.reloadData()
        print(finalDataArray)
    }
}

extension ContactsFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if finalDataArray.count == 0 {
            noDataLabel.isHidden = false
            noDataImageView.isHidden = false
            
        } else {
            noDataLabel.isHidden = true
            noDataImageView.isHidden = true
        }
        return finalDataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if finalDataArray.count == 0 {
//            noDataLabel.isHidden = false
//            noDataImageView.isHidden = false
//
//        } else {
//            noDataLabel.isHidden = true
//            noDataImageView.isHidden = true
//        }
//        return finalDataArray.count
        let array:NSMutableArray = finalDataArray[section] as! NSMutableArray
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell") as! AddFriendsTableViewCell
        cell.delegate = self
        let array:NSMutableArray = finalDataArray[indexPath.section] as! NSMutableArray
        let model:PersonModel = array[indexPath.row] as! PersonModel
        
        cell.friendsTitleLabel.text = model.name
        cell.friendsImageView.image = model.headerImage ?? UIImage.init(named: "mine_header_icon_normal_iPhone")
        cell.addAttentionButton.tag = 170 + indexPath.row
        cell.addAttentionButton.backgroundColor = UIColor(red: 212/250, green: 97/250, blue: 81/250, alpha: 1)
        cell.addAttentionButton.setTitle("添加好友", for: .normal)
        cell.addAttentionButton.setTitleColor(UIColor.white, for: .normal)
        cell.addAttentionButton.titleLabel?.textColor = UIColor.white
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title:String = titleArray[section] as! String
        return title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let array:NSMutableArray = finalDataArray[indexPath.section] as! NSMutableArray
        let model:PersonModel = array[indexPath.row] as! PersonModel
//        let model = dataSourceArray[indexPath.row]
     
        SYAlertController.showAlertController(view: self, title: model.name, message: "\(model.mobileArray)")
    }
 
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let array = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"];
        return array
    }
    
}

extension ContactsFriendsViewController: AddFriendsTableViewCellDelegate {
    func applyAddFriends(sender: UIButton) {
        let ver = VerifyApplicationViewController()
        ver.applyMobile = dataSourceArray[sender.tag - 170].mobileArray[0]
        navigationController?.pushViewController(ver, animated: true)
    }
}

extension ContactsFriendsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var row: Int?
        var arr = [String]()
        for i in 0..<dataSourceArray.count {
            arr.append(dataSourceArray[i].name)
        }
        for i in 0..<arr.count {
            if arr[i] == searchBar.text {
                row = arr.index(of: searchBar.text ?? "")
            }
        }
       friendsTableView.scrollToRow(at: IndexPath(row: row ?? 0, section: 0), at: .top, animated: true)
    }
}
