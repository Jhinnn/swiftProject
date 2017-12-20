//
//  TicketCategoryTableViewCell.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

protocol TicketCategoryTableViewCellDelegate: NSObjectProtocol {
    func ticketCategoryTableViewDidSelected(item: Int, title: String)
}

class TicketCategoryTableViewCell: UITableViewCell {

    let buttonImageArray = ["home_show_button_normal_iPhone","home_travel_button_normal_iPhone","home_incentives_button_normal_iPhone","home_game_button_normal_iPhone","home_moive_button_normal_iPhone","home_column_button_normal_iPhone"]
    let buttonTitleArray = ["演出票","旅游票","会展票","赛事票","电影票","栏目票"]
    var ticketCategory: [TicketNumberModel]?
    // delegate
    weak var delegate: TicketCategoryTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private method
    func viewConfig() {
        contentView.addSubview(backView)
        backView.addSubview(ticketCategoryCollection)
        
        ticketCategoryCollection.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 10, 0))
        }
    }
    
    // MARK: - setter and getter
    lazy var backView: UIView = {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 150))
        backView.backgroundColor = UIColor.init(hexColor: "f4f4f4")
        return backView
    }()

    lazy var ticketCategoryCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kScreen_width / 3, height: 70)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let ticketCategoryCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ticketCategoryCollection.backgroundColor = UIColor.white
        ticketCategoryCollection.delegate = self
        ticketCategoryCollection.dataSource = self
        ticketCategoryCollection.register(ScrambleForTicketCollectionViewCell.self, forCellWithReuseIdentifier: "ticketCategoryCell")
        return ticketCategoryCollection
    }()
}

extension TicketCategoryTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ticketCategoryCell", for: indexPath) as! ScrambleForTicketCollectionViewCell
        cell.categoryImageView.image = UIImage(named: buttonImageArray[indexPath.item])
        cell.categoryTitleLabel.text = buttonTitleArray[indexPath.item]
        cell.ticketNumberLabel.text = String.init(format: "%@张", ticketCategory?[indexPath.item].ticketNumber ?? "0")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let str = buttonTitleArray[indexPath.item]
        let title = str.substring(to: str.index(str.startIndex, offsetBy: 2))
        delegate?.ticketCategoryTableViewDidSelected(item: indexPath.item, title: title)
    }
}
