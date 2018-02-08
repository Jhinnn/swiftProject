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
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSectionThree), name: NSNotification.Name(rawValue: "IntelligentNotifaction"), object: nil)
    }
    
    //MARK :达人榜关注返回刷新
    func reloadSectionThree() {
        
        NetRequest.getIntelligentListNetRequest(page: "1", new_id: "") { (success, info, result) in
            if success {
            self.intelligentModel?.removeAll()
                for dic in result! {
                    let model = IntelligentModel.deserialize(from: dic)
                    self.intelligentModel?.append(model!)
                }
                self.collectionView.reloadData()
            }
        }
        
        collectionView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var intelligentModel: [IntelligentModel]? {
        willSet {
            self.collectionView.reloadData()
        }
    }
    
    func  viewConfig() {
        self.contentView.addSubview(collectionView)
        self.contentView.backgroundColor = UIColor.init(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 168)
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)  //外边距
   
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreen_width, height: 190), collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
     
        
        collectionView.register(UINib(nibName: "IntelligentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "intellCell")
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
        return (self.intelligentModel?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "intellCell", for: indexPath) as! IntelligentCollectionViewCell
        cell.delegate = self
        cell.model = self.intelligentModel?[indexPath.item]
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let personalInformationVC = PersonalInformationViewController()
        let model = self.intelligentModel?[indexPath.item]
        personalInformationVC.targetId = model?.uid ?? ""
        personalInformationVC.name = model?.nickname ?? ""
        self.viewController?.navigationController?.pushViewController(personalInformationVC, animated: true)
    }
    
   
    
  
    
}


//MARK : 关注delegate
extension IntelligentTableViewCell: IntelligentAttentionDelegate {
    func attentionActionCell(_ IntelligentCell: IntelligentCollectionViewCell, intelligentModel model: IntelligentModel) {
        
        if model.is_follow == "1" { //已关注
            
            NetRequest.addOrCancelAttentionNetRequest(method: "DELETE", mid: AppInfo.shared.user?.userId ?? "", follow_who: model.uid ?? "") { (success, info) in
                
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    
                    IntelligentCell.attentionButton.adjustsImageWhenHighlighted = false
                    IntelligentCell.attentionButton.backgroundColor = UIColor.themeColor
                    IntelligentCell.attentionButton.setTitle("关注", for: .normal)
                    IntelligentCell.attentionButton.setTitleColor(UIColor.white, for: .normal)
                    model.is_follow = "0"
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
            
            
        } else {
            NetRequest.addOrCancelAttentionNetRequest(method: "POST", mid: AppInfo.shared.user?.userId ?? "", follow_who: model.uid ?? "") { (success, info) in
                
                if success {
                    SVProgressHUD.showSuccess(withStatus: info)
                    
                    IntelligentCell.attentionButton.adjustsImageWhenHighlighted = false
                    IntelligentCell.attentionButton.backgroundColor = UIColor.white
                    IntelligentCell.attentionButton.setTitle("已关注", for: .normal)
                    IntelligentCell.attentionButton.setTitleColor(UIColor.themeColor, for: .normal)
                    model.is_follow = "1"
                   
                } else {
                    SVProgressHUD.showError(withStatus: info)
                }
            }
        }
    
    }
}
