//
//  GroupNoteTableViewCell.swift
//  WYP
//
//  Created by 曾雪峰 on 2017/12/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class GroupNoteTableViewCell: UITableViewCell {

    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setUIFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI(){
        
         contentView.addSubview(noteTitle)
        
      
        
    }
    
    func setUIFrame(){
        noteTitle.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
            make.size.equalTo(contentView)
            
        }
        
    }
    
    //标题
    lazy var noteTitle: UILabel = {
        let noteTitle = UILabel()
        noteTitle.text = "公告"
        return noteTitle
    }()
    //发布人
    lazy var people: UILabel = {
        let people = UILabel()
        return people
    }()
    
    lazy var pubTime: UILabel = {
        let pubTime = UILabel()
        return pubTime
    }()
    
    
    

}
