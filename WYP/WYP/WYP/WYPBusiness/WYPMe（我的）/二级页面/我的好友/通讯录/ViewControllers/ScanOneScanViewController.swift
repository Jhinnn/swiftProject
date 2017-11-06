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
        
        view.addSubview(messageLabel)
        
    }
    func layoutPageSubViews(){
        messageLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(50)
        }
    }
    lazy var messageLabel:UILabel = {
        let messageLable:UILabel = UILabel()
        messageLable.backgroundColor = UIColor.white
        return messageLable
    }()
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
            // 开始视频捕获
            captureSession?.startRunning()
            // 将显示信息的 label 与 top bar 提到最前面
            view.bringSubview(toFront: messageLabel)
//            view.bringSubview(toFront: topbar)
            // 初始化二维码选框并高亮边框
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
            
        } catch {
            // 如果出现任何错误，仅做输出处理，并返回
            print(error)
            return
        }
    }

}
extension ScanOneScanViewController:AVCaptureMetadataOutputObjectsDelegate{
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // 检查：metadataObjects 对象不为空，并且至少包含一个元素
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // 获得元数据对象
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // 如果元数据是二维码，则更新二维码选框大小与 label 的文本
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
}


