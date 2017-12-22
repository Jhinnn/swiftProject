//
//  DeleteGroupMemberViewController.swift
//  WYP
//
//  Created by aLaDing on 2017/12/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class DeleteGroupMemberViewController: UIViewController {
    
    var members : [PersonModel]?
    
    var groupId : String?
    
    lazy var collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: kScreen_width / 5 - 10, height: 75)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: kScreen_height), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GroupMemberCollectionViewCell.self, forCellWithReuseIdentifier: "groupMemberCell")
        collectionView.register(DeleteHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "deleteHeaderView")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "群成员"
        view.addSubview(collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deleteMember(person: PersonModel, index: Int) {
        let sheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction.init(title: "踢出该群", style: .default, handler: { (action) in
            NetRequest.deleteGroupMemberNetRequest(open_id: AppInfo.shared.user?.token, uid: person.peopleId, gid: self.groupId!, complete: { (success, info) in
                if success {
                    self.members?.remove(at: index)
                    self.collectionView.reloadData()
                }else {
                    print(info!)
                }
            })
        }))
        sheet.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        self.present(sheet, animated: true, completion: nil)
    }
}

extension DeleteGroupMemberViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.members?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupMemberCell", for: indexPath) as! GroupMemberCollectionViewCell
        cell.groupModel = self.members?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(25, 17, 25, 17)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "deleteHeaderView", for: indexPath) as! DeleteHeaderCollectionReusableView
        headerView.numLabel.text = "群成员 " + "(\(self.members?.count ?? 0))"
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: kScreen_width, height: 47)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let personModel = self.members![indexPath.item]
        self.deleteMember(person: personModel, index: indexPath.item)
    }
}
