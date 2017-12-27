//
//  ScanOneScanViewController.swift
//  WYP
//
//  Created by 赵玉忠 on 2017/11/6.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit
import AVFoundation
class ScanOneScanViewController: BaseViewController {

    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var scanLine:UIView?
    var scanSession:AVCaptureSession?
    var zhiXingCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        layoutPageSubViews()
        scan()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func viewConfig(){
        navigationItem.title = "二维码/条码"
        navigationItem.titleView?.backgroundColor = UIColor.black
        navigationItem.titleView?.tintColor = UIColor.white
        
        
        
    }
    func layoutPageSubViews(){
        
    }
   
    func scan(){
        // 获得 AVCaptureDevice 对象，用于初始化捕获视频的硬件设备，并配置硬件属性
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            // 通过之前获得的硬件设备，获得 AVCaptureDeviceInput 对象
            let input = try AVCaptureDeviceInput(device: captureDevice)
            // 初始化 captureSession 对象
            captureSession = AVCaptureSession()
            // 给 session 添加输入设备
            captureSession?.addInput(input)
            // 初始化 AVCaptureMetadataOutput 对象，并将它作为输出
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            // 设置 delegate 并使用默认的 dispatch 队列来执行回调
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            // 初始化视频预览 layer，并将其作为 viewPreview 的 sublayer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            // 初始化二维码选框并高亮边框
            qrCodeFrameView = UIView()
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 1
                view.addSubview(qrCodeFrameView)
                qrCodeFrameView.snp.makeConstraints({ (make) in
                    make.center.equalTo(view)
                    make.width.height.equalTo(200)
                })
                view.bringSubview(toFront: qrCodeFrameView)
            }
            //让横线在扫描的区域内上下移动
            scanLine = UIView()
            if let scanLine = scanLine {
                scanLine.backgroundColor = UIColor.green
                view.addSubview(scanLine)
                scanLine.snp.makeConstraints({ (make) in
                    make.center.equalTo(view)
                    make.width.equalTo(170)
                    make.height.equalTo(1)
                })
                view.bringSubview(toFront: scanLine)
                let startPoint = CGPoint(x: view.center.x  , y: view.center.y - 100)
                let endPoint = CGPoint(x: view.center.x, y: view.center.y + 50)
                let translation = CABasicAnimation(keyPath: "position")
                    translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    translation.fromValue = NSValue(cgPoint: startPoint)
                    translation.toValue = NSValue(cgPoint: endPoint)
                    translation.duration = 4.0
                    translation.repeatCount = MAXFLOAT
                    translation.autoreverses = true
                scanLine.layer.add(translation, forKey: "position")
            }
            // 开始视频捕获
            captureSession?.startRunning()
            // 将显示信息的 label 与 top bar 提到最前面

        } catch {
            // 如果出现任何错误，仅做输出处理，并返回
            print(error)
            return
        }
    }
    
    let addFriend: () = {
        print("Not coming back here.")
    }()
    

}
extension ScanOneScanViewController:AVCaptureMetadataOutputObjectsDelegate{
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // 检查：metadataObjects 对象不为空，并且至少包含一个元素
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            
            return
        }
        
        // 获得元数据对象
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // 如果元数据是二维码，则更新二维码选框大小与 label 的文本
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                
                let vc = VerifyApplicationViewController()
               
                let str = metadataObj.stringValue
                if metadataObj.stringValue.hasPrefix("group") {
                    vc.flag = 2
                    
//                    let str2 = str.substringFromIndex(metadataObj.stringValue.startIndex.advancedBy(6)) //Swift
                    let startIndex = str?.index((str?.startIndex)!, offsetBy:6)//获取d的索引
                    let result = str?.substring(from: startIndex!)
                    vc.groupId = result
                }else {
                    vc.flag = 1
                    vc.applyMobile = str
                }
            
                if zhiXingCount == 0 {
                    navigationController?.pushViewController(vc, animated: true)
                    zhiXingCount = zhiXingCount + 1
                }
                
                
                
               

            }
        }
    }
    
    
}


