//
//  MyAnswerQViewController.swift
//  WYP
//
//  Created by aLaDing on 2018/3/19.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class MyAnswerQViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "阿拉丁问答"
        view.backgroundColor = UIColor.white
        
        layoutPageSubviews()
    }
    
    private func layoutPageSubviews() {
        
        view.addSubview(newAllTableView)
        
        newAllTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }

    // MARK: - setter and getter
    lazy var newAllTableView: WYPTableView = {
        let newAllTableView = WYPTableView(frame: .zero, style: .plain)
        newAllTableView.backgroundColor = UIColor.init(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
        newAllTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        newAllTableView.separatorColor = UIColor.init(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
        newAllTableView.delegate = self
        newAllTableView.dataSource = self
        newAllTableView.rowHeight = 40
        
        newAllTableView.register(UINib.init(nibName: "MyAnswerHeadCell", bundle: nil), forCellReuseIdentifier: "answerQcell")
        
        return newAllTableView
    }()
    
    // MARK: - setter and getter
//    lazy var navTabBar: SYNavTabBar = {
//        let navTabBar = SYNavTabBar(frame:CGRect(x: 0, y: 0, width: kScreen_width / 3 * 2, height: 42) )
//        navTabBar.delegate = self
//        navTabBar.backgroundColor = UIColor.white
//        navTabBar.navTabBarHeight = 42
//        navTabBar.buttonTextColor = UIColor.black
//        navTabBar.line?.isHidden = false
//        navTabBar.lineColor = UIColor.red
//        return navTabBar
//    }()

}


extension MyAnswerQViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "answerQcell", for: indexPath) as! MyAnswerHeadCell
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 163
            }
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0.0001
        }
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0001
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: 40))
        view.backgroundColor = UIColor.groupTableViewBackground
        view.text = "10"
        return view
    }
}
