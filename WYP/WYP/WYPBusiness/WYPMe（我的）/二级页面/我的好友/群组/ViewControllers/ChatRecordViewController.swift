//
//  ChatRecordViewController.swift
//  WYP
//
//  Created by aLaDing on 2017/12/20.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class ChatRecordViewController: UIViewController {
    
    var groupId : String?
    
    var numberTextField : UITextField?
    
    var totalMessageLabel : UILabel?
    
    var messages : [RCMessage]?
    
    var pageMessages : [RCMessage]?
    
    lazy var rightBtn : UIButton = {
       let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        rightBtn.setImage(UIImage.init(named: "friend_icon_search_normal"), for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBtnClicked(sender:)), for: .touchUpInside)
        return rightBtn
    }()
    
    func rightBtnClicked(sender : UIButton) {
        
    }
    
    lazy var tableView : UITableView = {
       let tableView = UITableView.init(frame: CGRect.init(x: 0, y: -64, width: kScreen_width, height: kScreen_height - 50 - 64), style: .plain)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "chatRecordCell")
        return tableView
    }()
    
    lazy var menuView: UIView = {
        let menuView = UIView()
        menuView.backgroundColor = UIColor.white
        let frontBtn = UIButton()
        frontBtn.setImage(UIImage.init(named: "chat_icon_front_normal"), for: .normal)
        frontBtn.addTarget(self, action: #selector(frontBtnClicked(sender:)), for: .touchUpInside)
        menuView.addSubview(frontBtn)
        frontBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(12)
            make.size.equalTo(CGSize.init(width: 16, height: 27))
            make.centerY.equalTo(menuView.snp.centerY)
        })
        let textField = UITextField()
        textField.text = "1"
        textField.textColor = UIColor.init(hexColor: "666666")
        textField.font = UIFont.systemFont(ofSize: 13)
        self.numberTextField = textField
        menuView.addSubview(textField)
        textField.snp.makeConstraints({ (make) in
            make.centerY.equalTo(frontBtn)
            make.left.equalTo(frontBtn.snp.right).offset(12)
            make.size.equalTo(CGSize.init(width: 30, height: 20))
        })
        let totalLable = UILabel()
        totalLable.textColor = UIColor.init(hexColor: "666666")
        totalLable.font = UIFont.systemFont(ofSize: 13)
        self.totalMessageLabel = totalLable
        menuView.addSubview(totalLable)
        totalLable.snp.makeConstraints({ (make) in
            make.left.equalTo(textField.snp.right).offset(6)
            make.centerY.equalTo(textField.snp.centerY)
        })
        let behindBtn = UIButton()
        behindBtn.setImage(UIImage.init(named: "chat_icon_behind_normal"), for: .normal)
        behindBtn.addTarget(self, action: #selector(behindBtnClicked(sender:)), for: .touchUpInside)
        menuView.addSubview(behindBtn)
        behindBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(totalLable.snp.right).offset(12)
            make.centerY.equalTo(totalLable)
            make.size.equalTo(CGSize.init(width: 30, height: 20))
        })
        let deleteBtn = UIButton()
        deleteBtn.backgroundColor = UIColor.init(hexColor: "db3920")
        deleteBtn.setTitle("清空聊天记录", for: .normal)
        deleteBtn.setTitleColor(UIColor.white, for: .normal)
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        deleteBtn.addTarget(self, action: #selector(deleteBtnClicked(sender:)), for: .touchUpInside)
        menuView.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(behindBtn)
            make.right.equalTo(0)
            make.size.equalTo(CGSize.init(width: 95, height: 50))
        })
        return menuView
    }()
    
    func frontBtnClicked(sender: UIButton) {
        if Int((self.numberTextField?.text)!)! == 1 {
            return
        }
        self.numberTextField?.text = "\(Int((self.numberTextField?.text)!)! + 1)"
        
    }
    
    func behindBtnClicked(sender: UIButton) {
//        if Int((self.numberTextField?.text)!)! == 1 {
//            return
//        }
    }
    
    func deleteBtnClicked(sender: UIButton) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "聊天记录"
        view.addSubview(tableView)
        view.addSubview(menuView)
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(-50)
        }
        menuView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom)
            make.left.bottom.right.equalTo(0)
        }
        getChatRecordNetRequest()
    }
    // 调融云接口 获取聊天记录
    func getChatRecordNetRequest() {
        self.messages = (RCIMClient.shared().getLatestMessages(.ConversationType_GROUP, targetId: self.groupId, count: 50) as! [RCMessage])
        if self.messages?.count != 0 {
            if (self.messages?.count)! % 10 == 0 {
                self.totalMessageLabel?.text = "/ " + "\((self.messages?.count)! / 10)"
            }else {
                self.totalMessageLabel?.text = "/ " + "\((self.messages?.count)! / 10 + 1)"
            }
        }
//        self.tableView.reloadData()
//        if self.messages != nil {
//            for message in self.messages! {
//                NetRequest.getUserNickNameAndHeadImgUrlNetRequest(userId: message.senderUserId, complete: { (success, info, result) in
//                    if success {
//                        let person = PersonModel.deserialize(from: result)
//                        self.userInfos.append(person!)
//                        self.tableView.reloadData()
//                    }else {
//                        print(info!)
//                    }
//                })
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func formatterTime(time: Int64) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date.init(timeIntervalSince1970: TimeInterval(time)))
    }
    
}

extension ChatRecordViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatRecordTableViewCell(style: .default, reuseIdentifier: "chatRecordCell")
        let message : RCMessage = (self.messages?[indexPath.row])!
        cell.headImageView.sd_setImage(with: URL.init(string: message.content.senderUserInfo.portraitUri ?? ""))
        cell.nameLabel.text = message.content.senderUserInfo.name
        cell.contentLabel.text = message.content.mentionedInfo.mentionedContent
        cell.timeLabel.text = self.formatterTime(time: message.sentTime)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
