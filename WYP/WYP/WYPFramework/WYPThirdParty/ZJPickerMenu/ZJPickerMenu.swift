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
    func getMsg(num:Int,pro:[String:String])
}


class ZJPickerMenu: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    var numLabel:UILabel?
    var pro = [String:String]()
    var delegate : ZJPickerMenuDelegate?
    
    private var padding_top:CGFloat = 100
    
    var arr : [String:[String]]?
    
    lazy var backView: UIView =
    {
        var back = UIView.init(frame: UIScreen.main.bounds)
        back.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        return back
        
    }()
    lazy var headerView: UIView =
    {
        var header = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120))
        header.addSubview(self.exitButton)
        header.addSubview(self.goodIm)
        header.addSubview(self.lineView)
        return header
    }()
    lazy var pickerView: UIView =
    {
        var picker = UIView.init(frame: CGRect(x: padding_top, y: 0, width: UIScreen.main.bounds.width - padding_top, height: UIScreen.main.bounds.height))
        picker.backgroundColor = UIColor.white
        picker.addSubview(self.headerView)
        picker.addSubview(self.cv)
        picker.addSubview(self.commitButton)
        return picker
    }()
    lazy var exitButton: UIButton = {
        var button = UIButton.init(frame: CGRect(x: UIScreen.main.bounds.width - 100, y: 0, width: 100, height: 100))
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 60, 60, 5)
        button.setImage(UIImage.init(named: "退出"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(miss), for: UIControlEvents.touchUpInside)
        return button
    }()
    lazy var goodIm: UIImageView = {
        var im = UIImageView.init(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
//        im.backgroundColor = UIColor.red
        im.image = UIImage.init(named: "1")
        return im
    }()
    lazy var lineView: UIView = {
        var line = UIView.init(frame: CGRect(x: 0, y: 120, width: UIScreen.main.bounds.width, height: 1))
        line.backgroundColor = UIColor.init(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        return line
    }()
    
    lazy var commitButton: UIButton =
    {
        var button = UIButton.init(frame: CGRect(x: 0, y:  UIScreen.main.bounds.height - 60 - padding_top, width: UIScreen.main.bounds.width, height: 60))
        button.setTitle("确定", for: UIControlState.normal)
        button.setBackgroundImage(UIImage.init(named: "selected"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(sureCommit), for: UIControlEvents.touchUpInside)
        return button
    }()
    lazy var cv: UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        var cv = UICollectionView.init(frame: CGRect(x: 0, y: 130, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - padding_top - 130 - 60), collectionViewLayout: layout)
        cv.register(ProCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.register(ProHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeader")
        cv.register(ProFoorterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "sectionfoorter")
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
        let result =  Array((arr?.values)!)
        return result[section].count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let result =  Array((arr?.values)!)
        let str = result[indexPath.section][indexPath.row]
        print(str)
        let rect = (str as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)], context: nil)
        return CGSize(width: rect.width + 20, height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if(kind == UICollectionElementKindSectionHeader)
        {
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeader", for: indexPath) as! ProHeaderCollectionReusableView
            let res = Array((arr?.keys)!)
            v.label.text = res[indexPath.section]
            return v
        }
        else
        {
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "sectionfoorter", for: indexPath) as! ProFoorterCollectionReusableView
            numLabel = v.numTf
            return v
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        if section == (arr?.count)! - 1
        {
            return CGSize(width: UIScreen.main.bounds.width, height: 50)
        }
        return CGSize(width: UIScreen.main.bounds.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 8, 8, 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProCollectionViewCell
        let result =  Array((arr?.values)!)
        cell.button.setTitle( (result[indexPath.section][indexPath.row]), for: UIControlState.normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let num = collectionView.numberOfItems(inSection: indexPath.section)
        for i in 0..<num
        {
            let index = NSIndexPath.init(row: i, section: indexPath.section)
            if i != indexPath.row
            {
                let cell1 = collectionView.cellForItem(at: index as IndexPath) as! ProCollectionViewCell
                cell1.button.isSelected = false
            }
            else
            {
                let result =  Array((arr?.values)!)
                 let res =  Array((arr?.keys)!)
                let cell1 = collectionView.cellForItem(at: index as IndexPath) as! ProCollectionViewCell
                cell1.button.isSelected = true
                pro[res[indexPath.section]] = result[indexPath.section][indexPath.row]
            }
        }
        
        
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backView.addSubview(self.pickerView)
        self.pickerView.addSubview(self.cv)
        self.addSubview(self.backView)
    }
    
    func show(v:UIView)
    {
        self.frame = CGRect(x:UIScreen.main.bounds.width, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        v.addSubview(self)
        UIView.animate(withDuration: 0.1)
        {
            self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    
    @objc func miss()
    {
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touc = ((touches.first?.view)!)
        if (touc.frame.height == UIScreen.main.bounds.height)
        {
             miss()
        }
    }
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //提交
    @objc func sureCommit()
    {
        print("数量:\((numLabel?.text)!)")
        print(pro)
        self.delegate?.getMsg(num: Int((numLabel?.text)!)!, pro: pro)
    }
    
}
