//
//  QRCodeViewController.swift
//  WYP
//
//  Created by 赵玉忠 on 2017/11/6.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

class QRCodeViewController: BaseViewController {

    var QRcodeImageViewLocal:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func viewConfig(){
        navigationItem.title = "我的二维码"
        let QRcodeImageView = UIImageView()
        QRcodeImageViewLocal = QRcodeImageView
        view.addSubview(QRcodeImageView)
        QRcodeImageView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.height.equalTo(300)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         let myPhoneNumber = AppInfo.shared.user?.mobilePhoneNumber
        let image:UIImage = self.creatCIQRCodeImage(formdata: myPhoneNumber!, imageWidth: 300)
        QRcodeImageViewLocal?.image = image
    }
    
    //生成二维码
    func creatCIQRCodeImage(formdata:String,imageWidth:CGFloat) -> UIImage {
        //创建一个二维码的滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        
        // 恢复滤镜的默认属性
        qrFilter?.setDefaults()
        
        // 将字符串转换成
        let infoData =  formdata.data(using: .utf8)
        
        // 通过KVC设置滤镜inputMessage数据
        qrFilter?.setValue(infoData, forKey: "inputMessage")
        
        // 获得滤镜输出的图像
        let  outputImage = qrFilter?.outputImage
        
        // 设置缩放比例
        let scale = imageWidth / outputImage!.extent.size.width;
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let transformImage = qrFilter!.outputImage!.applying(transform)
        
        // 获取Image
        let image = UIImage(ciImage: transformImage)
        
        /*
        // 无logo时  返回普通二维码image
//        guard let QRCodeLogo = logo else { return image }
        
        // logo尺寸与frame
        let logoWidth = image.size.width/4
        let logoFrame = CGRect(x: (image.size.width - logoWidth) /  2, y: (image.size.width - logoWidth) / 2, width: logoWidth, height: logoWidth)
        */
        // 绘制二维码
        UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.main.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        /*
        // 绘制中间logo
        QRCodeLogo.draw(in: logoFrame)
        */
        //返回带有logo的二维码
        let QRCodeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return QRCodeImage!
    }


}
