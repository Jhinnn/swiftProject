//
//  CityListViewController.swift
//  CityListDemo
//
//  Created by ShuYan Feng on 2017/3/29.
//  Copyright © 2017年 ShuYan Feng. All rights reserved.
//

import UIKit

class CityListViewController: BaseViewController {
    
    private var timer: Timer?
    
    // 城市名称数组
    var cityNameArr = [[String]]()
    
    // 存放城市名称
    var citySource: [CityModel]?
    // 存放热门城市名称
    var hotCitySource: [CityModel]?
    // 城市首字母
    var initialArray: NSMutableArray?
    // 城市名称
    var letterResultArray: NSMutableArray?
    // 当前城市名称
    var currentCityName: String?
    // 定位城市数据
    var locationCityArray: [String]? {
        willSet {
            locationGroupView.items = newValue
//            locationViewLabel.text = String.init(format: "当前 : %@", newValue![0])
        }
    }
    // 热门城市数据
    var hotCityArray = [String]()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        viewConfig()
        layoutPageSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 显示当前所选择的城市
        let cityName = UserDefaults.standard.object(forKey: "cityName") as? String ?? "北京"
        locationViewLabel.text = String.init(format: "当前 : %@", cityName)
    
    }
    
    // MARK: - private method
    private func loadData() {
        let path: String = Bundle.main.path(forResource: "cityList.json", ofType: nil)!
        // 处理文件
        guard let data = try? Data.init(contentsOf: URL(fileURLWithPath: path)) else {
            print("获取文件data失败")
            return
        }
        let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        citySource = [CityModel].deserialize(from: jsonString) as? [CityModel]
        
        var array = [String]()
        for dict in citySource! {
            array.append(dict.cityName ?? "")
        }
        initialArray = ChineseString.indexArray(array)
        letterResultArray = ChineseString.letterSortArray(array)
        
        // 获取热门城市
        let hotPath: String = Bundle.main.path(forResource: "hotCityList.json", ofType: nil)!
        // 处理文件
        guard let hotData = try? Data.init(contentsOf: URL(fileURLWithPath: hotPath)) else {
            print("获取文件data失败")
            return
        }
        let hotjsonString = NSString(data: hotData, encoding: String.Encoding.utf8.rawValue)! as String
        hotCitySource = [CityModel].deserialize(from: hotjsonString) as? [CityModel]
        for i in 0..<(hotCitySource?.count)! {
            hotCityArray.append(hotCitySource?[i].cityName ?? "")
        }
        hotCityGroupView.items = hotCityArray
    
        for dict in citySource! {
            hotCityArray.append(dict.cityName ?? "")
        }
    }
    
    // MARK: - private method
    private func viewConfig() {
        title = "城市选择"
        view.addSubview(warningLabel)
        view.addSubview(searchBar)
        view.addSubview(locationView)
        locationView.addSubview(locationViewLabel)
        view.addSubview(tableView)
        view.addSubview(sectionTitleView)
        headerView.addSubview(locationLabel)
        headerView.addSubview(locationGroupView)
        headerView.addSubview(hotCityLabel)
        headerView.addSubview(hotCityGroupView)
        tableView.tableHeaderView = headerView
    }
    private func layoutPageSubviews() {
        warningLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(20)
        }
        searchBar.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(warningLabel.snp.bottom)
            make.height.equalTo(44)
        }
        locationView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.equalTo(view)
            make.height.equalTo(44)
        }
        locationViewLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(locationView)
            make.left.right.equalTo(locationView).offset(20)
        }
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(108, 0, 0, 0))
        }
        locationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headerView).offset(20)
            make.top.equalTo(headerView).offset(20)
            make.height.equalTo(15)
        }
        locationGroupView.snp.makeConstraints { (make) in
            make.left.equalTo(headerView)
            make.top.equalTo(locationLabel.snp.bottom).offset(20)
            make.right.equalTo(headerView).offset(-20)
            make.height.equalTo(40)
        }
        hotCityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headerView).offset(20)
            make.top.equalTo(locationGroupView.snp.bottom).offset(20)
            make.height.equalTo(15)
        }
        hotCityGroupView.snp.makeConstraints { (make) in
            make.left.equalTo(headerView)
            make.top.equalTo(hotCityLabel.snp.bottom).offset(20)
            make.right.equalTo(headerView).offset(-20)
            make.height.equalTo(128)
        }
        sectionTitleView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
    }
    
    // 显示当前所在组
    fileprivate func showSectionTitle(_ sender : String){
        sectionTitleView.text = sender
        sectionTitleView.isHidden = false
        sectionTitleView.alpha = 1.0
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerSelector), userInfo: nil, repeats: false)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
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
    
    // MARK: - setter and getter
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        
        searchBar.barStyle = .default
        searchBar.barTintColor = UIColor.white
        searchBar.contentMode = .left
        searchBar.placeholder = "输入城市名或拼音查询"
        
        let searchField: UITextField = searchBar.value(forKey: "_searchField") as! UITextField
        searchField.backgroundColor = UIColor.init(hexColor: "#E8EAEB")
        return searchBar
    }()
    lazy var locationView: UIView = {
        let locationView = UIView()
        locationView.backgroundColor = UIColor.white
        return locationView
    }()
    lazy var locationViewLabel: UILabel = {
        let locationViewLabel = UILabel()
        locationViewLabel.textColor = UIColor.init(hexColor: "333333")
        locationViewLabel.text = "当前：上海"
        return locationViewLabel
    }()
    lazy var tableView: WYPTableView = {
        let tableView = WYPTableView(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .grouped)
        tableView.sectionIndexColor = UIColor.themeColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cityCell")
        return tableView
    }()
    lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 280))
        headerView.backgroundColor = UIColor.init(hexColor: "f4f4f4")
        return headerView
    }()
    lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.textColor = UIColor.init(hexColor: "606060")
        locationLabel.font = UIFont.systemFont(ofSize: 15)
        locationLabel.text = "当前定位城市"
        return locationLabel
    }()
    lazy var locationGroupView: ButtonGroupView = {
        let locationGroupView = ButtonGroupView()
        locationGroupView.columns = 3
        locationGroupView.delegate = self
        return locationGroupView
    }()
    lazy var hotCityLabel: UILabel = {
        let hotCityLabel = UILabel()
        hotCityLabel.textColor = UIColor.init(hexColor: "606060")
        hotCityLabel.font = UIFont.systemFont(ofSize: 15)
        hotCityLabel.text = "热门城市"
        return hotCityLabel
    }()
    lazy var hotCityGroupView: ButtonGroupView = {
        let hotCityGroupView = ButtonGroupView()
        hotCityGroupView.columns = 3
        hotCityGroupView.delegate = self
        return hotCityGroupView
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
    lazy var warningLabel: UILabel = {
        let warningLabel = UILabel()
        warningLabel.text = "  当前您所选择的城市将关联到抢票所在地区"
        warningLabel.font = UIFont.systemFont(ofSize: 11)
        warningLabel.numberOfLines = 2
        warningLabel.textColor = UIColor.init(hexColor: "a1a1a1")
        return warningLabel
    }()
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if initialArray!.count > 0 {
            return (initialArray?.count)!
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if letterResultArray == nil {
            return 0
        }
        return (letterResultArray?[section] as AnyObject).count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell")
        let sectionTitles : NSArray = letterResultArray?.object(at: indexPath.section) as! NSArray
     
        cell?.textLabel?.text = sectionTitles.object(at: indexPath.row) as? String
        return cell!
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 20, height: 20))
        label.text = initialArray?[section] as! String?
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionTitles : NSArray = letterResultArray?.object(at: indexPath.section) as! NSArray
        locationViewLabel.text = sectionTitles[indexPath.row] as? String
        UserDefaults.standard.set(locationViewLabel.text, forKey: "cityName")
        
        for city: CityModel in citySource! {
            if city.cityName == locationViewLabel.text {
                UserDefaults.standard.set(city.cityId, forKey: "cityId")
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        showSectionTitle(title)
        return index
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return (initialArray! as NSArray) as? [String]
    }
}

extension CityListViewController: ButtonGroupViewDelegate {
    func buttonGroupViewDidClickItem(buttonGroup: ButtonGroupView, item: CityButton) {

        locationViewLabel.text = item.title(for: .normal)
        UserDefaults.standard.set(locationViewLabel.text, forKey: "cityName")
        for city: CityModel in hotCitySource! {
            if city.cityName == locationViewLabel.text {
                UserDefaults.standard.set(city.cityId, forKey: "cityId")
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension CityListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let citySearch = CitySearchViewController()
        citySearch.keyword = searchBar.text ?? ""
        self.navigationController?.pushViewController(citySearch, animated: true)
        
    }
}
