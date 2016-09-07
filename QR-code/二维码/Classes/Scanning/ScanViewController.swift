//
//  ScanViewController.swift
//  二维码
//
//  Created by 李贵鹏 on 16/8/21.
//  Copyright © 2016年 李贵鹏. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController {

    @IBOutlet weak var qrCodeView: UIView!
    @IBOutlet weak var scanViewBottomCons: NSLayoutConstraint!

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addScanningAnimation()
        // 2.扫描二维码
        startScanningQRCode()
    }

    private func addScanningAnimation() {
        // 1.改变约束
        scanViewBottomCons.constant = -240
        
        // 2.执行动画
        UIView.animateWithDuration(0.7) {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.imageView.layoutIfNeeded()
        }
    }
    
        private func startScanningQRCode() {
             // 1.创建捕捉会话
            let session = AVCaptureSession()
            // 2.设置输入(摄像头)
            let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            guard let input = try? AVCaptureDeviceInput(device: device) else {
                return
            }
            session.addInput(input)
             // 3.设置输出(Metadata)
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            session.addOutput(output)
             // 设置output的输出的类型(该类型的设置必须在添加到session之后)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            // 设置扫描的区域
            let screenW = UIScreen.mainScreen().bounds.width
            let screenH = UIScreen.mainScreen().bounds.height
            let x : CGFloat = qrCodeView.frame.origin.x / screenW
            let y : CGFloat = qrCodeView.frame.origin.y / screenH
            let w : CGFloat = qrCodeView.frame.width / screenW
            let h : CGFloat = qrCodeView.frame.height / screenH
            output.rectOfInterest = CGRect(x: y, y: x, width: h, height: w)
            
              // 4.添加预览图层(可以没有)
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.frame = view.frame
            view.layer.insertSublayer(previewLayer, atIndex: 0)
            // 5.开始扫描
            session.startRunning()
    }
}


extension ScanViewController : AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        guard let objc = metadataObjects.last as? AVMetadataMachineReadableCodeObject else {
            return
        }
        print(objc.stringValue)
    }
}
