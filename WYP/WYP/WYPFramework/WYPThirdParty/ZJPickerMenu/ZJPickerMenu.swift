//
//  ZJPickerMenu.swift
//  商城属性
//
//  Created by zj on 2017/12/7.
//  Copyright © 2017年 zj. All rights reserved.
//

import UIKit
protocol ZJPickerMenuDelegate:NSObjectProtocol
{
    func getMsg(pro:[String:String])
}


class ZJPickerMenu: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var numLabel:UILabel?
    var pro = [String:String]()
    var delegate : ZJPickerMenuDelegate?

    
    private var padding_top:CGFloat = 100
    
    var arr : [String:[ExhibitionModel]]?
    var arrTitle : [String]?
    
    lazy var backView: UIView = {
        var back = UIView.init(frame: UIScreen.main.bounds)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(miss(_ :)))
//        back.addGestureRecognizer(tap)
        back.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        return back
    }()
    
    lazy var hiddenView: UIView = {
        var back = UIView.init(frame: CGRect(x: 0, y: 0, width: 100, height: UIScreen.main.bounds.height))
        let tap = UITapGestureRecognizer(target: self, action: #selector(miss(_ :)))
        back.addGestureRecognizer(tap)
        back.backgroundColor = UIColor.clear
        return back
    }()
    
    
    
    lazy var headerView: UIView = {
        var header = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        header.backgroundColor = UIColor.menuColor
        header.addSubview(self.titleLabel)
        return header
    }()
    
    lazy var titleLabel: UILabel = {
        var titleLabel = UILabel.init(frame: CGRect(x: 14, y: 40, width: kScreen_width - 100, height: 30))
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.gray
        titleLabel.text = "筛选"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        return titleLabel
    }()

    lazy var commitButton: UIButton = {
        var button = UIButton()
        if deviceTypeIPhoneX() {
            button.frame = CGRect(x: 0, y:  UIScreen.main.bounds.height - 50 - 34, width: UIScreen.main.bounds.width - 100, height: 50)
            
        }else {
            button.frame = CGRect(x: 0, y:  UIScreen.main.bounds.height - 50, width: UIScreen.main.bounds.width - 100, height: 50)
        }
        button.setTitle("确定", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.themeColor
        button.addTarget(self, action: #selector(sureCommit), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var pickerView: UIView = {
        var picker = UIView.init(frame: CGRect(x: 100, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        picker.backgroundColor = UIColor.white
//        let tap = UITapGestureRecognizer(target: self, action: #selector(misss(_ :)))
//        picker.addGestureRecognizer(tap)
        picker.addSubview(self.headerView)
        picker.addSubview(self.cv)
        picker.addSubview(self.commitButton)
        return picker
    }()
    
    lazy var cv: UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        var cv = UICollectionView.init(frame: CGRect(x: 0, y:90, width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 90 - 50 - 34), collectionViewLayout: layout)
        cv.register(ProCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.register(ProHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeader")
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.white
        return cv
    }()
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return arr?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        let result =  Array((arr?.values)!)
        
        return (arr![self.arrTitle![section]]?.count)!
        
        
//        return result[section].count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
//        let result =  Array((arr?.values)!)
//        let str = result[indexPath.section][indexPath.row]
//        let rect = (str as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 38), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:nil, context: nil)
//        return CGSize(width: rect.width + 58, height: 38)
        return CGSize(width: 80, height: 38)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeader", for: indexPath) as! ProHeaderCollectionReusableView
//        let res = Array((arr?.keys)!)
        
        v.label.text = self.arrTitle?[indexPath.section]
        return v
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { //行间距
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {  //列间距
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 15, 8, 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        
        if arr?.count != 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProCollectionViewCell
//            let exhibitionModelArray =  Array((arr?.values)!)
            let exhibitionModelArray = arr![self.arrTitle![indexPath.section]]
            let model = exhibitionModelArray![indexPath.row]
            cell.button.isSelected = false
            cell.button.setTitle(model.title, for: UIControlState.normal)
            cell.button.backgroundColor = UIColor.menuColor
            cell.button.setTitleColor(UIColor.black, for: .normal)
            return cell
        }
       
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let num = collectionView.numberOfItems(inSection: indexPath.section)
        for i in 0..<num
        {
            let index = NSIndexPath.init(row: i, section: indexPath.section)
            if i != indexPath.row
            {
                let cell1 = collectionView.cellForItem(at: index as IndexPath) as? ProCollectionViewCell
                cell1?.button.isSelected = false
            }
            else
            {
            
//                let exhibitionModelArray =  Array((arr?.values)!)
                let exhibitionModelArray = arr![self.arrTitle![indexPath.section]]
                let model = exhibitionModelArray![indexPath.row]
//                let model = exhibitionModelArray[indexPath.section][indexPath.row]
                let res =  Array((arr?.keys)!)
                let cell1 = collectionView.cellForItem(at: index as IndexPath) as? ProCollectionViewCell
                cell1?.button.isSelected = true
                pro[res[indexPath.section]] = model.id
            }
       
        }
        
        
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backView.addSubview(self.pickerView)
        self.pickerView.addSubview(self.cv)
        self.backView.addSubview(self.hiddenView)
    }
    
    func show() {
        self.frame = CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.backView.frame = CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let guidePageWindow = UIApplication.shared.keyWindow
        guidePageWindow?.addSubview(self.backView)
        UIView.animate(withDuration: 0.1)
        {
            self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        cv.reloadData()
    }
    
    @objc func miss(_ tap: UITapGestureRecognizer)
    {

        UIView.animate(withDuration: 0.1) {
            self.backView.transform = (self.backView.transform.translatedBy(x: kScreen_width, y: 0))
        }
    }
    
//    @objc func misss(_ tap: UITapGestureRecognizer)
//    {
//
//    }
    

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //提交
    @objc func sureCommit()
    {
        UIView.animate(withDuration: 0.1) {
            self.backView.transform = (self.backView.transform.translatedBy(x: kScreen_width, y: 0))
        }
        self.delegate?.getMsg(pro: pro)
        
        pro.removeAll()
    }
    
}
