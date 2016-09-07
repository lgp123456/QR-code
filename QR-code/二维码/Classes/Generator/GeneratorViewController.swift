//
//  GeneratorViewController.swift
//  二维码
//
//  Created by 李贵鹏 on 16/8/21.
//  Copyright © 2016年 李贵鹏. All rights reserved.
//

import UIKit
import CoreImage

class GeneratorViewController: UIViewController {
    @IBOutlet weak var textFiled: UITextField!

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //获取输入的内容
        guard let inputMsg = textFiled.text else {
            return
        }
        //将信息生成二维码图片
        //创建滤镜
        let fileter = CIFilter(name: "CIQRCodeGenerator")
        //给滤镜设置内容
        //将字符串转成二进制数据
        guard let inputData = inputMsg.dataUsingEncoding(NSUTF8StringEncoding) else {
            return
        }
        fileter?.setValue(inputData, forKey: "inputMessage")
        //获取生成的二维码图片
        guard let outputImage = fileter?.outputImage else {
            return
        }
        //获取高清二维码图片
        let hdImage = createHDImage(outputImage)
        let fgImage = UIImage(named: "erha")!
        
        //显示二维码图片
        imageView.image = addFgImage(hdImage, fgImage: fgImage)
    }
}

// MARK:- 生成高清图片
extension GeneratorViewController {
    ///生成高清图片
    func createHDImage(image : CIImage) ->UIImage {
        //创建Transform
        let scale = imageView.bounds.width / image.extent.width
        let transform = CGAffineTransformMakeScale(scale, scale)
        
        //放大图片
        let hdImage = image.imageByApplyingTransform(transform)
        
        return UIImage(CIImage: hdImage)
    }
    
    // MARK:- 设置前景图片
    ///设置前景图片
    func addFgImage(image : UIImage , fgImage : UIImage) -> UIImage {
        
        //开启图形上下文
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
        
        //将二维码画到上下文
        image.drawInRect(CGRect(origin: CGPointZero, size:image.size))
        
        //计算前景图片的位置
        let w : CGFloat = 50
        let h : CGFloat = 50
        let x :CGFloat = (image.size.width - w) * 0.5
        let y :CGFloat = (image.size.height - h) * 0.5
        //将前景图片画上去
        fgImage.drawInRect(CGRect(x: x, y: y, width: w, height: h))
        //获取图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //关闭图形上下文
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}


