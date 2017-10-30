//
//  CitySearchViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/7/31.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class CitySearchViewController: BaseViewController {

    // 搜索城市结果
    var citySource: [CityModel]?
    // 搜索关键字
    var keyword: String? {
        willSet {
            self.searchTextField.text = newValue
        }
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfig()
        layoutPageSubviews()
        
        loadSearchResult()
    }

    // MARK: - private method
    func viewConfig() {
        view.addSubview(tableView)
        
        // 添加搜索
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.titleView = searchView
        searchView.addSubview(searchTextField)
        searchView.addSubview(searchImageView)
    }
    
    func layoutPageSubviews() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        searchImageView.snp.makeConstraints { (make) in
            make.right.equalTo(searchView).offset(-10)
            make.centerY.equalTo(searchView)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        searchTextField.snp.makeConstraints { (make) in
            make.left.equalTo(searchView).offset(20)
            make.right.equalTo(searchImageView.snp.left).offset(-10)
            make.centerY.equalTo(searchView)
            make.height.equalTo(30)
        }

    }
    
    func loadSearchResult() {
        NetRequest.citySearchNetRequest(keywords: self.searchTextField.text ?? "") { (success, info, result) in
            if success {
                let array = result!.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                self.citySource = [CityModel].deserialize(from: jsonString) as? [CityModel]
                
                // 先移除再添加
                self.noDataImageView.removeFromSuperview()
                self.noDataLabel.removeFromSuperview()
                // 没有数据的情况
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
                
                self.tableView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: info!)
            }
        }
    }
    
    // MARK: - event response
    func clickSearchButton(sender: UIBarButtonItem) {
        loadSearchResult()
    }
    
    // MARK: - setter and getter
    lazy var tableView: WYPTableView = {
        let tableView = WYPTableView(frame: .zero, style: .plain)
        tableView.sectionIndexColor = UIColor.themeColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCityCell")
        return tableView
    }()
    
    // titleView
    lazy var searchView: UIView = {
        let searchView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_width - 100, height: 30))
        searchView.backgroundColor = UIColor.white
        searchView.layer.cornerRadius = 5.0
        searchView.layer.masksToBounds = true
        return searchView
    }()
    // 设置导航条上的搜索框
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.delegate = self
        searchTextField.placeholder = "搜索内容..."
        searchTextField.returnKeyType = .search
        let attributeString = NSMutableAttributedString(string: searchTextField.placeholder!)
        attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14),range: NSMakeRange(0,(searchTextField.placeholder?.characters.count)!))
        searchTextField.attributedPlaceholder = attributeString
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.addTarget(self, action: #selector(loadSearchResult), for: .allEditingEvents)
        return searchTextField
    }()
    lazy var searchImageView: UIImageView = {
        let searchImageView = UIImageView()
        searchImageView.image = UIImage(named: "common_search_button_normal_iPhone")
        return searchImageView
    }()
    lazy var rightBarButtonItem: UIBarButtonItem = {
        let rightBarButtonItem = UIBarButtonItem(title: "搜索", style: .done, target: self, action: #selector(clickSearchButton(sender:)))
        return rightBarButtonItem
    }()
    
    // 没有数据时的图片
    lazy var noDataImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "common_noResult_icon_normal_iPhone")
        return imageView
    }()
    // 没有数据时的提示文字
    lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "内容已飞外太空"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.init(hexColor: "a1a1a1")
        label.textAlignment = .center
        return label
    }()
}

extension CitySearchViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if citySource?.count == 0 {
            noDataLabel.isHidden = false
            noDataImageView.isHidden = false
        } else {
            noDataLabel.isHidden = true
            noDataImageView.isHidden = true
        }
        return citySource?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCityCell")
        cell?.textLabel?.text = citySource?[indexPath.row].cityName
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let city = citySource?[indexPath.row]
        UserDefaults.standard.set(city?.cityName ?? "", forKey: "cityName")
        
        for city: CityModel in citySource! {
            if city.cityName == city.cityName {
                UserDefaults.standard.set(city.cityId, forKey: "cityId")
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension CitySearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loadSearchResult()
        return true
    }
}
