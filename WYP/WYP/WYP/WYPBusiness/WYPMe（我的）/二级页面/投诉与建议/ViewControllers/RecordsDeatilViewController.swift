//
//  RecordsDeatilViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/5/12.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class RecordsDeatilViewController: UIViewController {

    // 反馈Id
    var recordId: String?
    // 反馈唯一标识
    var recordCode: String?
    // 反馈详情数据
    var recordData: [RecordsDetailModel]?
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfig()
        loadRecordDetail()
    }
    
    func viewConfig() {
        self.title = "反馈记录"
        view.addSubview(detailTableView)
        view.addSubview(commentView)
        commentView.addSubview(commentTextField)
        commentView.isHidden = true
        
        // layout
        detailTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        commentView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.size.equalTo(CGSize(width: kScreen_width, height: 50))
        }
        commentTextField.snp.makeConstraints { (make) in
            make.left.equalTo(commentView).offset(13)
            make.right.equalTo(commentView).offset(-13)
            make.centerY.equalTo(commentView)
            make.height.equalTo(35)
        }
    }
    
    func loadRecordDetail() {
        NetRequest.recordsDetailNetRequest(recordId: recordId ?? "", code: recordCode ?? "") { (success, info, result) in
            if success {
                let array = result!.value(forKey: "data")
                let data = try! JSONSerialization.data(withJSONObject: array!, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                self.recordData = [RecordsDetailModel].deserialize(from: jsonString) as? [RecordsDetailModel]
                self.detailTableView.reloadData()
            } else {
                print(info!)
            }
        }
    }

    // MARK: - setter and getter
    lazy var detailTableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = UIColor.groupTableViewBackground
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        
        tableview.register(RecordsDetailTableViewCell.self, forCellReuseIdentifier: "recordDetailCell")
        return tableview
    }()
    // 底部的view
    lazy var commentView: UIView = {
        let commentView = UIView()
        commentView.backgroundColor = UIColor.white
        return commentView
    }()
    // 评论框
    lazy var commentTextField: UITextField = {
        let commentTextField = UITextField()
        commentTextField.delegate = self
        commentTextField.borderStyle = .roundedRect
        commentTextField.placeholder = "期待你的神评论"
        commentTextField.returnKeyType = .send
        let attributeString = NSMutableAttributedString(string: commentTextField.placeholder!)
        attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 13),range: NSMakeRange(0,(commentTextField.placeholder?.characters.count)!))
        commentTextField.attributedPlaceholder = attributeString
        let imageView = UIImageView(frame: CGRect(x: 12, y: 7.5, width: 13.5, height: 13.5))
        imageView.image = UIImage(named: "common_editorGary_button_normal_iPhone")
        commentTextField.leftView = imageView
        commentTextField.leftViewMode = .always
        return commentTextField
    }()
}

extension RecordsDeatilViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recordData != nil {
            return recordData?.count ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordDetailCell", for: indexPath) as! RecordsDetailTableViewCell
        if recordData != nil {
            let recordFrame = RecordsDetailFrameModel()
            recordFrame.recordModel = recordData?[indexPath.row]
            cell.recordDetailFrame = recordFrame
            if recordData?[indexPath.row].recordType == 1 {
                cell.backgroundColor = UIColor.groupTableViewBackground
            }
        }
        

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if recordData != nil {
            let recordFrame = RecordsDetailFrameModel()
            recordFrame.recordModel = recordData?[indexPath.row]
            return recordFrame.cellHeight!
        }
        return 0
    }
}

extension RecordsDeatilViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        NetRequest.feedbackIdeaNetRequest(token: AppInfo.shared.user?.token ?? "", text: textField.text ?? "", pid: recordId ?? "", vyid: recordCode ?? "") { (success, info) in
            if success {
                // 反馈成功
                SVProgressHUD.showSuccess(withStatus: info)
                self.loadRecordDetail()
            } else {
                // 反馈失败
                SVProgressHUD.showError(withStatus: info)
            }
        }

        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if PublicGroupViewController().stringContainsEmoji(string) {
            if PublicGroupViewController().isNineKeyBoard(string) {
                return true
            }
            SVProgressHUD.showError(withStatus: "暂不支持特殊字符")
            return false
        }
        return true
    }
}
