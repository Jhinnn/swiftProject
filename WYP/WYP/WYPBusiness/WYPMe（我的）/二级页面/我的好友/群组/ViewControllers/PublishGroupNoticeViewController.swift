//
//  PublishGroupNoticeViewController.swift
//  WYP
//
//  Created by aLaDing on 2017/12/19.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class PublishGroupNoticeViewController: UIViewController {
    
    var groupId : String?
    
    var images = [UIImage]()
    
    var titleText : String?
    
    var contentText : String?

    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: kScreen_height), style: .grouped)
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "publishGroupNoteCell")
        return tableView
    }()
    
    lazy var rightBtn: UIButton = {
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        rightBtn.setTitle("发布", for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBtnClicked(sender:)), for: .touchUpInside)
        return rightBtn
    }()
    
    func rightBtnClicked(sender : UIButton?) -> Void {
        if contentText?.count == 0 {
            SVProgressHUD.showError(withStatus: "请填写公告内容")
            return
        }
        if titleText?.count == 0 {
            SVProgressHUD .showError(withStatus: "请填写公告标题")
            return
        }
        sender?.isEnabled = false
        var imgStrs = [String]()
        if self.images.count != 0 {
            for img in self.images {
                let imgStr = UIImagePNGRepresentation(img)?.base64EncodedString()
                imgStrs.append(imgStr!)
            }
        }
        NetRequest.publishGroupNoteNetRequest(rid: self.groupId, open_id: AppInfo.shared.user?.token, title: self.titleText, content: self.contentText, images: imgStrs) { (success, info) in
            if success {
                SVProgressHUD.showSuccess(withStatus: info)
                self.navigationController?.popViewController(animated: true)
            }else {
                print(info)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "编辑群公告"
        view.addSubview(tableView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.rightBtn)
    }
}

extension PublishGroupNoticeViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PublishGroupNoteTableViewCell(style: .default, reuseIdentifier: "publishGroupNoteCell")
        cell.titleText = { (text) in
            self.titleText = text
        }
        cell.contentText = { (text) in
            self.contentText = text
        }
        cell.photoChange = { (images) in
            self.images = images ?? []
        }
        cell.images = self.images
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
