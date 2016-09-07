//
//  DetectorViewController.swift
//  二维码
//
//  Created by 李贵鹏 on 16/8/21.
//  Copyright © 2016年 李贵鹏. All rights reserved.
//

import UIKit

class DetectorViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension DetectorViewController {
    
    @IBAction func pickerImageClick(sender: AnyObject) {
        //创建照片选择控制器
        let pickerVc = UIImagePickerController()
        //设置来源类型
        pickerVc.sourceType = .PhotoLibrary
        //设置代理
        pickerVc.delegate = self
        //设置弹出样式
        pickerVc.modalTransitionStyle = .CrossDissolve
        //弹出控制器
        presentViewController(pickerVc, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //创建识别器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context:nil, options: nil)
        //获取图片,并将图片转成CIImage
        let image = imageView.image!
        guard let ciImage = CIImage(image: image) else {
            return
        }
        //识别图片中的二维码
        let features = detector.featuresInImage(ciImage)
        //遍历数组中的所有元素
        for f in features {
            guard let qrCodeFeature = f as? CIQRCodeFeature else {
                continue
            }
            print(qrCodeFeature.messageString)
            resultLabel.text = qrCodeFeature.messageString
        }
    }
}

// MARK:- 代理方法
extension DetectorViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //把选中的图片设置到ImageView上
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //dismiss掉照片控制器
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}


