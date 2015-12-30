//
//  ViewController.swift
//  BlurSlipSideMenuDemo
//
//  Created by 张慈航 on 15/12/1.
//  Copyright (c) 2015年 com.zhangcihang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = UIImage(named: "IMG_0502.jpg")
        self.view.addSubview(imageView)

        self.setupChildrenViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

