//
//  GuideViewController.swift
//  WYP
//
//  Created by 你个LB on 2017/3/9.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class GuideViewController: BaseViewController {

    let imageNames = ["guide_page_01", "guide_page_02", "guide_page_03"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear

        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        
        view.addSubview(scrollView)
        
        setupUIFrame()
        
        for i in 0..<imageNames.count {
            // 创建图片视图
            let imageView = UIImageView(frame: CGRect(x: CGFloat(i)*kScreen_width, y: 0, width: kScreen_width, height: kScreen_height))
            
            imageView.image = getImage(imageName: imageNames[i])
            scrollView.addSubview(imageView)
            if i == (imageNames.count - 1) {
                // 最后一张图片，添加按钮
                let skipButton = UIButton(frame: CGRect(x: CGFloat(i)*kScreen_width + 40, y: kScreen_height - 75, width: kScreen_width - 2 * 40, height: 50))
                skipButton.backgroundColor = UIColor.themeColor
                skipButton.setTitle("立即体验", for: .normal)
                skipButton.setTitleColor(UIColor.white, for: .normal)
                skipButton.layer.cornerRadius = 25
                skipButton.addTarget(self, action: #selector(skipButtonAction), for: .touchUpInside)
                scrollView.addSubview(skipButton)
            }
        }
    }
    
    private func setupUIFrame() {
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    // 获取当前设备下对应的图片
    private func getImage(imageName: String) -> UIImage {
        var size: Float = 0
        if deviceTypeIphone5() || deviceTypeIPhone4() {
            // 是4.0寸
            size = 4.0
        } else if deviceTypeIPhone6() {
            // 是4.7寸
            size = 4.7
        } else if deviceTypeIPhone6Plus() {
            // 是5.5寸
            size = 5.5
        } else{
             size = 5.5
        }
        // 拼接图片完整的名字
        let newImageName = "\(imageName)_\(size).png"
        
        return UIImage(named: newImageName)!
    }

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: kScreen_width * CGFloat(self.imageNames.count + 1), height: kScreen_height)
        scrollView.delegate = self
        // 设置翻页效果
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        // 取消弹性效果
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.clear
        
        return scrollView
    }()
    
    func skipButtonAction() {
        // 隐藏window
        view.window?.isHidden = true
        // 释放引导页的window
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        appDelegate?.guidePageWindow = nil
    }
}

extension GuideViewController: UIScrollViewDelegate {
    
    // MARK: - UIScrollView Delegate
    
    // 手指拖拽离开时调用
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if decelerate == true {
//            return
//        }
//    }
    
    // 停止减速时调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 如果当前滑动视图的最大偏移量，隐藏引导页
        if scrollView.contentOffset.x + scrollView.frame.size.width >= scrollView.contentSize.width {
            // 隐藏window
            view.window?.isHidden = true
            // 释放引导页的window
//            let appDelegate = UIApplication.shared.delegate as? AppDelegate
//            appDelegate?.guidePageWindow = nil
        }
    }
}
