//
//  MyQRViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/10/24.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import AVFoundation

class MyQRViewController: BaseViewController {

    let imageW = 250
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGenerateQRCode()
    }
    
    // MARK: - private method
    // 生成二维码
    func setUpGenerateQRCode() {
        // 借助UIImageView显示二维码
        view.addSubview(QRImageView)
        QRImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(CGSize(width: imageW, height: imageW))
        }
        // 显示二维码
        // 获取用户Id
        let userId = AppInfo.shared.user?.userId ?? ""
        QRImageView.image = SGQRCodeGenerateManager.generate(withDefaultQRCodeData: userId + " ####", imageViewWidth: CGFloat(imageW))
        
    }
    
    // MARK: - setter and getter
    // 二维码显示区域
    lazy var QRImageView: UIImageView = {
        let QRImageView = UIImageView()
        QRImageView.backgroundColor = UIColor.clear
        return QRImageView
    }()
}
