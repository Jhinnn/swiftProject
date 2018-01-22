//
//  ProFoorterCollectionReusableView.swift
//  商城属性
//
//  Created by zj on 2017/12/8.
//  Copyright © 2017年 zj. All rights reserved.
//

import UIKit

class ProFoorterCollectionReusableView: UICollectionReusableView
{
    var num = 1
    lazy var label: UILabel =
    {
        var label = UILabel()
        label.textAlignment = .left
        label.text = "购买数量"
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    lazy var lineView: UIView = {
        var line = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
        line.backgroundColor = UIColor.init(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        return line
    }()
    
    lazy var addButton: UIButton =
    {
        var button = UIButton()
        button.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        button.setTitle("＋", for: UIControlState.normal)
        button.setTitleColor(UIColor.init(red: 153/255.0, green:  153/255.0, blue:  153/255.0, alpha: 1.0), for: UIControlState.normal)
            button.addTarget(self, action: #selector(countAdd), for: UIControlEvents.touchUpInside)
        return button
    }()
    lazy var numTf: UILabel =
    {
        var tf = UILabel()
//        tf.text = String(num)
        tf.textAlignment = .center
        tf.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        return tf
    }()
    lazy var delButton: UIButton =
        {
            var button = UIButton()
            button.setTitle("－", for: UIControlState.normal)
            button.setTitleColor(UIColor.init(red: 153/255.0, green:  153/255.0, blue:  153/255.0, alpha: 1.0), for: UIControlState.normal)
            button.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
            button.addTarget(self, action: #selector(countDel), for: UIControlEvents.touchUpInside)
            
            return button
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.addSubview(self.lineView)
        self.addSubview(self.label)
        self.addSubview(self.addButton)
        self.addSubview(self.numTf)
        self.addSubview(self.delButton)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.label.frame = CGRect(x: 10, y: 0, width: 100 , height: self.bounds.height)
         self.delButton.frame = CGRect(x: self.bounds.width - 45, y: self.bounds.height/2 - 17.5, width: 35 , height: 35)
         self.numTf.frame = CGRect(x: self.bounds.width - 81, y: self.bounds.height/2 - 17.5, width: 35 , height: 35)
         self.addButton.frame = CGRect(x: self.bounds.width - 117, y: self.bounds.height/2 - 17.5, width: 35 , height: 35)
        
    }
    
    @objc func countAdd()
    {
        num+=1
        self.numTf.text = String(num)
    }
    
    @objc func countDel()
    {
        if num == 1
        {
            return
        }
        num-=1
        self.numTf.text = String(num)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

