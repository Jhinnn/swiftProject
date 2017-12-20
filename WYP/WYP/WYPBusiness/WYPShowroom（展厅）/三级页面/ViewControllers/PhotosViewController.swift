//
//  PhotosViewController.swift
//  WYP
//
//  Created by ShuYan Feng on 2017/4/10.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    
    
    var currentIndex: NSInteger? {
        willSet {
            indexLabel.text = "\(newValue ?? 0  + 1)/\(imageArray?.count ?? 0)"
        }
    }
    
    // 图集视图
    var pictureBrowserView: WBImageBrowserView?
    // 存放图片的数组
    var imageArray: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfig()
        addNotificationCenter()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = true
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let window = UIApplication.shared.keyWindow!
        window.backgroundColor = UIColor.themeColor
        // 强制翻转屏幕，Home键在下边
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    // 在
    private func viewConfig() {
        
        let window = UIApplication.shared.keyWindow!
        window.backgroundColor = UIColor.black
        self.view.backgroundColor = UIColor.black
        
        
        
        pictureBrowserView = WBImageBrowserView.pictureBrowsweView(withFrame: CGRect(x: 0, y: -64, width: kScreen_width, height: kScreen_height), delegate: self, browserInfoArray: imageArray)
        pictureBrowserView?.orientation = UIDevice.current.orientation
        pictureBrowserView?.viewController = self
        pictureBrowserView?.shareButton.isHidden = true
        pictureBrowserView?.startIndex = currentIndex ?? 0 + 1
        pictureBrowserView?.show(in: window)
    
        window.addSubview(indexLabel)
        indexLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(window)
            make.top.equalTo(window).offset(80)
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
        
        
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientation), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    
    }

    
    // 处理旋转过程中需要的操作
    func orientation(notification: NSNotification) {
        
        let orientation = UIDevice.current.orientation
        var newVCH = kScreen_height
        var newVCW = kScreen_width
        
        switch orientation {
        case .portrait:
            // 屏幕竖直
            print("屏幕竖直")
            newVCH = kScreen_height
            newVCW = kScreen_width
            indexLabel.isHidden = false
            
        case .landscapeLeft:
            // 屏幕向左转
            print("屏幕向左转")
            // 横屏
            newVCH = kScreen_width
            newVCW = kScreen_height
            indexLabel.isHidden = true
            
        case .landscapeRight:
            // 屏幕向右转
            print("屏幕向右转")
            // 横屏
            newVCH = kScreen_width
            newVCW = kScreen_height
            indexLabel.isHidden = true
        default:
            break
        }
        
        self.view.frame = CGRect(x: 0, y: 0, width: newVCW, height: newVCH)
        pictureBrowserView?.orientation = orientation
    }
    
    lazy var indexLabel: UILabel = {
        let indexLabel = UILabel()
        indexLabel.textColor = UIColor.white
        indexLabel.font = UIFont.systemFont(ofSize: 17)
        indexLabel.textAlignment = .center
        indexLabel.text = "1/\(self.imageArray?.count ?? 0)"
        return indexLabel
    }()
}

extension PhotosViewController: WBImageBrowserViewDelegate {
    func getContentWithItem(_ item: Int) {
        indexLabel.text = "\(item+1)/\(imageArray?.count ?? 0)"
        print(item)
    }
    func backButtonToClick() {
        pictureBrowserView?.removeFromSuperview()
        indexLabel.removeFromSuperview()
            
        self.dismiss(animated: false, completion: nil)
    }
    func shareButtonToClick() {
        
    }
}
