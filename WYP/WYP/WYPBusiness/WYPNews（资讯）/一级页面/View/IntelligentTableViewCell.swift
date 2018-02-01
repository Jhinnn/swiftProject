//
//  IntelligentTableViewCell.swift
//  WYP
//
//  Created by Arthur on 2018/2/1.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

import UIKit

class IntelligentTableViewCell: UITableViewCell {

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewConfig()
    }
    
    func  viewConfig() {
        self.contentView.addSubview(collectionView)
        self.contentView.backgroundColor = UIColor.init(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 130)
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 35, left: 12, bottom: 23, right: 12)  //外边距
        // 设定header的大小
        layout.headerReferenceSize = CGSize(width: kScreen_width, height: 30)
        
        

        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: 180), collectionViewLayout: layout)
        // 在注册cell 的同时，别忘了注册header
        let nib = UINib.init(nibName: "UICollectionHeader", bundle: nil)
        collectionView.register(nib, forSupplementaryViewOfKind:
            UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView")
        collectionView.register(IntelligentCollectionViewCell.self, forCellWithReuseIdentifier: "intellCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.init(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
        return collectionView
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension IntelligentTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "intellCell", for: indexPath) as! IntelligentCollectionViewCell
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        var reusableView: UICollectionReusableView?
//        if kind  ==  UICollectionElementKindSectionHeader {
//            let header :UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath)
//            reusableView = header
//        }
//        return reusableView!
//    }
    
  
    
}
