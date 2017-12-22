//
//  SettingManagerTableViewCell.swift
//  WYP
//
//  Created by aLaDing on 2017/12/22.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class SettingManagerTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
//        setUIFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var members : [PersonModel]? {
        willSet {
            self.collectionView.reloadData()
        }
    }
    
    var memberInfoBack: ((PersonModel?) -> Void)?
    
    func setUI() {
        contentView.addSubview(collectionView)
    }
    
//    func setUIFrame() {
//        collectionView.snp.makeConstraints { (make) in
//            make.left.top.right.bottom.equalTo(self)
//        }
//    }

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: kScreen_width / 5 - 10, height: 75)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: 220), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GroupMemberCollectionViewCell.self, forCellWithReuseIdentifier: "groupMemberCell")
        collectionView.register(DeleteHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "deleteHeaderView")
        return collectionView
    }()
}

extension SettingManagerTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.memberInfoBack != nil {
            let model = self.members![indexPath.item]
            self.memberInfoBack!(model)
        }
    }
}
