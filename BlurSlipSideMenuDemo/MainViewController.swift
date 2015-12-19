//
//  MainViewController.swift
//  BlurSlipSideMenuDemo
//
//  Created by 张慈航 on 15/12/3.
//  Copyright (c) 2015年 com.zhangcihang. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        // Do any additional setup after loading the view.
        
        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = UIImage(named: "IMG_0502.jpg")
        self.view.addSubview(imageView)
        
        
        let leftBarItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: "menuClick")
        self.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    func menuClick()
    {
        let blurMainController = self.blurMainController()
        blurMainController?.showMenu()
    }

    func blurMainController() -> ZCHBlurMainController?
    {
        var controller = self.parentViewController
        while (controller != nil) {
            if controller!.isKindOfClass(ZCHBlurMainController.classForCoder())
            {
                return controller as? ZCHBlurMainController
            }
            else if controller?.parentViewController != nil && controller?.parentViewController != controller
            {
                controller = controller?.parentViewController
            }
            else {
                return nil
            }
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
