//
//  GroupDeailsViewController.swift
//  WYP
//
//  Created by 曾雪峰 on 2017/12/13.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class GroupDeailsViewController: BaseViewController {
    let tableview: UITableView = UITableView()
    var groupId: String?
    var titleimage: UIImage?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupUIFrame()
        tableview.dataSource = self
        tableview.delegate = self
       
    
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 设置导航条透明度
        DispatchQueue.main.async {
            self.navBarBgAlpha = 0
            
          
        }
        
    }
    
    func setupUI(){
        tableview.tableHeaderView = tableViewHeaderView
        tableViewHeaderView.addSubview(headerImgView)
    }
    func setupUIFrame() {
        view.addSubview(tableview)
       
        self.navigationController?.setToolbarHidden(true, animated: false)
        
        tableview.snp.makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsetsMake(-64, 0, 0, 0))
        })
        
        headerImgView.snp.makeConstraints { (make) in
//            make.bottom.equalTo(tableViewHeaderView).offset(-20)
//            make.left.equalTo(tableViewHeaderView).offset(20)
            make.centerY.equalTo(tableViewHeaderView.snp.bottom)
            make.centerX.equalTo(tableview.snp.centerX)
            make.size.equalTo(75)
        }
    }
    
    
    // 表视图的头视图
    lazy var tableViewHeaderView: UIImageView = {
        let tableViewHeaderView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 140))
        tableViewHeaderView.backgroundColor = UIColor.yellow
        tableViewHeaderView.image = UIImage(named: "grzy_porfile_bg")
        
        return tableViewHeaderView
    }()
    // 头像
    lazy var headerImgView: UIImageView = {
        let headerImgView = UIImageView()
        headerImgView.layer.cornerRadius = 37.5
        headerImgView.layer.masksToBounds = true
        headerImgView.backgroundColor = UIColor.init(hexColor: "a1a1a1")
        
        return headerImgView
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


   

}
extension GroupDeailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = StatementCell(style: .default, reuseIdentifier: "StatementCellIdentifier")
        cell.textLabel?.text = "测试"
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10
    }
    func numberOfSections(in tableView: UITableView) -> Int{
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var tatle: String?
        if section == 0 {
            tatle = "北京"
        
        }
        if section == 1 {
            tatle = "上海"
        }
        return tatle
    }
    
}
