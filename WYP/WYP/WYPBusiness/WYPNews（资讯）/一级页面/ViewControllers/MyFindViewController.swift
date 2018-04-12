
//
//  MyQuestionViewController.swift
//  WYP
//
//  Created by aLaDing on 2018/4/2.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class MyFindViewController: UITableViewController {
    
    // 刷新加载
    enum RequestType {
        case update
        case loadMore
    }
    // 加载页数
    var pageNumber: Int = 1
    

    var newsGambitData = [GimbitModel]()
    
    var newExpertData = [ExpertModel]()
    
    var choiceTopicData = [ChoiceTopicModel]()
    
    lazy var sectionTitleArray: [String] = {
        let sectionTitleArray = ["推荐", "专家团", "编辑精选"]
        return sectionTitleArray
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        self.navigationItem.titleView = searchTitleView
        
        loadData()
        loadData1()
        
        loadNewsData(requestType: .update)
        
        viewConfig()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    //MARK: --请求话题推荐类型
    func loadData() {
        NetRequest.findTypeListNetRequest { (success, info, dataArr) in
            if success {
                
                let data = try! JSONSerialization.data(withJSONObject: dataArr!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                self.newsGambitData = [GimbitModel].deserialize(from: jsonString)! as! [GimbitModel]
                
                self.tableView.reloadData()
            }
        }
    }
    
    func loadData1() {
        NetRequest.findExpertListNetRequest(limit: "2",page: "1") { (success, info, dataArr) in
            if success {
                let data = try! JSONSerialization.data(withJSONObject: dataArr!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                self.newExpertData = [ExpertModel].deserialize(from: jsonString)! as! [ExpertModel]
                
                self.tableView.reloadData()
            }
        }
        
    }
    
    func loadNewsData(requestType: RequestType) {
        if requestType == .update {
            pageNumber = 1
        } else {
            pageNumber = pageNumber + 1
        }
        
        NetRequest.findChoiceTopicListNetRequest(page: "\(pageNumber)") { (success, info, dataArr) in
            if success {
                let data = try! JSONSerialization.data(withJSONObject: dataArr!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                if requestType == .update {
                    self.choiceTopicData = [ChoiceTopicModel].deserialize(from: jsonString)! as! [ChoiceTopicModel]
                }
//                else { //下拉刷新
//                    let data = [ChoiceTopicModel].deserialize(from: jsonString)! as! [ChoiceTopicModel]
//                    self.choiceTopicData = self.choiceTopicData + data
//                }
                
//                self.tableView.mj_footer.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    



    func viewConfig() {
        

        tableView.register(UINib.init(nibName: "FindExpTableViewCell", bundle: nil), forCellReuseIdentifier: "expCell")
        tableView.register(UINib.init(nibName: "ChoiceTopicTableViewCell", bundle: nil), forCellReuseIdentifier: "choiceCell")
        tableView.separatorColor = UIColor.groupTableViewBackground

        let leftBarBtn = UIBarButtonItem(image: UIImage(named: "common_blackback_button_normal_iPhone"), style: .done, target: self, action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
    }
    
    // 导航栏上的view
    lazy var searchTitleView: qusesearchView = {
        let searchTitleView = qusesearchView(frame: CGRect(x: 0, y: 0, width: 260 * width_height_ratio, height: 25))
        // 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchNews))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        searchTitleView.addGestureRecognizer(tap)
        
        return searchTitleView
    }()
    
    
    func searchNews() {
        self.navigationController?.pushViewController(MyAqSearchViewController(), animated: true)
    }

    
    func backToPrevious() {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 2
        }else if section == 2 {
            if self.choiceTopicData.count != 0 {
                return self.choiceTopicData.count
            }
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gambitCell")
            let collectionView = cell?.viewWithTag(100) as! UICollectionView
            collectionView.reloadData()
            return cell!
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "expCell", for: indexPath) as? FindExpTableViewCell
            cell?.delegate = self
            if self.newExpertData.count != 0 {
                cell?.expertModel = self.newExpertData[indexPath.row]
            }
            return cell!
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "choiceCell", for: indexPath) as? ChoiceTopicTableViewCell
            if self.newExpertData.count != 0 {
                cell?.choiceTopicData = self.choiceTopicData[indexPath.row]
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 110
        }else if indexPath.section == 1 {
            return 84
        }
        return 180
    }
    
    // MARK: - 设置组头
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 40))
        sectionHeaderView.backgroundColor = UIColor.white
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = UIColor.init(hexColor: "333333")
        titleLabel.text = sectionTitleArray[section]
        sectionHeaderView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sectionHeaderView.snp.left).offset(16)
            make.top.bottom.equalTo(sectionHeaderView)
            make.width.equalTo(150)
        }
        
        let lineLabel = UILabel()
        lineLabel.backgroundColor = UIColor.groupTableViewBackground
        sectionHeaderView.addSubview(lineLabel)
        lineLabel.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.bottom.right.equalTo(sectionHeaderView)
        }
        
        if section == 1 {
            let titleButton = UIButton()
            titleButton.setTitle("查看全部", for: .normal)
            titleButton.setTitleColor(UIColor.init(hexColor: "333333"), for: .normal)
            titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            titleButton.titleLabel?.textAlignment = NSTextAlignment.left
            titleButton.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
            sectionHeaderView.addSubview(titleButton)
            titleButton.snp.makeConstraints({ (make) in
                make.top.bottom.right.equalTo(sectionHeaderView)
                make.width.equalTo(90)
            })
        }
        
        
        return sectionHeaderView
    }
    
    // MARK: - 设置组头
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: 5))
        view.backgroundColor = UIColor.init(red: 244/255.0, green: 245/255.0, blue: 247/255.0, alpha: 1)
        return view
    }
    
    // 设置组头高度
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
        }
    }
    
    //专家团
    func moreAction(){
        self.navigationController?.pushViewController(ExpertListViewController(), animated: true)
    }
}

extension MyFindViewController: FindExpAttentionDelegate{
    
    func attentionActionCell(_ findExpTableViewCell: FindExpTableViewCell, expertModel model: ExpertModel) {
        if !findExpTableViewCell.attentionBtn.isSelected {    //normal  已关注  //未关注
            NetRequest.addOrCancelAttentionNetRequest(method: "DELETE", mid: AppInfo.shared.user?.userId ?? "", follow_who: model.uid ?? "") { (success, info) in
                
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    
                    self.loadData1()
                    model.is_follow = "0"
                    self.tableView.reloadData()
                    
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
        }else {
            NetRequest.addOrCancelAttentionNetRequest(method: "POST", mid: AppInfo.shared.user?.userId ?? "", follow_who: model.uid ?? "") { (success, info) in
                
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    model.is_follow = "1"
                    self.loadData1()
                    self.tableView.reloadData()
                    
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
            
        }
    }
    
    
    
}




extension MyFindViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.newsGambitData.count != 0 {
            return self.newsGambitData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 话题推荐类型
        if self.newsGambitData.count != 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as! FindTypeCollectionViewCell
            cell.gambitModel = self.newsGambitData[indexPath.item]
            return cell
        }
        return UICollectionViewCell()

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
    
    
    
}


