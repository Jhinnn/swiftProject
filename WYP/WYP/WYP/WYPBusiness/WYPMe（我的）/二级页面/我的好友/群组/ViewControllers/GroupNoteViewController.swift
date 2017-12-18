//
//  GroupNoteViewController.swift
//  WYP
//
//  Created by 曾雪峰 on 2017/12/17.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class GroupNoteViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
       
        setupUI()
        layoutPageSubviews()
        

        // Do any additional setup after loading the view.
    }
    
  
    
    func setupUI(){
        
        self.title = "群公告"
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.delegate = self
       
        
    }
    
    func layoutPageSubviews(){
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
          
        }
    }
   
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    lazy var tableView: UITableView = {
    let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "groupNoteCellIdentifier")
    return tableView
  
    }()

}

extension GroupNoteViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = GroupNoteTableViewCell(style: .default, reuseIdentifier: "groupNoteCellIdentifier")
        
        
        return cell
        
        
    }
    
    
}
