//
//  ZCHBlurMainController.swift
//  BlurSlipSideMenuDemo
//
//  Created by 张慈航 on 15/12/1.
//  Copyright (c) 2015年 com.zhangcihang. All rights reserved.
//

import UIKit

public enum ZCHBlurEffectStyle : Int {
    
    case ExtraLight
    case Light
    case Dark
}

class ZCHBlurMainController: UIViewController {

    //MARK: - public property
    
    /// 主控制器 （必须实现）
    var contentController:UIViewController?
    
    /// 侧滑栏控制器（必须实现）
    var menuController:UIViewController?
    
    /// 侧滑滑出时的背景模糊风格
    var blurredType:ZCHBlurEffectStyle = ZCHBlurEffectStyle.Light
    
    /// 侧滑栏宽度 （sideControllerWidth 和 sideControllerWidthScale 使用其中一个，默认用sideControllerWidthScale）
    var sideControllerWidth: CGFloat = 0
    
    /// 侧滑栏占整个屏幕宽度的百分比
    var sideControllerWidthScale: CGFloat = 0.8
    
    //MARK: - init
    
    convenience init(contentController:UIViewController, menuController:UIViewController, blurredType:ZCHBlurEffectStyle, sideControllerWidthScale:CGFloat)
    {
        self.init(nibName: nil, bundle: nil)
        self.contentController = contentController
        self.menuController = menuController
        self.blurredType = blurredType
        self.sideControllerWidthScale = sideControllerWidthScale
    }
    
    convenience init(contentController:UIViewController, menuController:UIViewController, blurredType:ZCHBlurEffectStyle)
    {
        self.init(contentController:contentController, menuController:menuController, blurredType:blurredType, sideControllerWidthScale: 0.8)
    }

    convenience init(contentController:UIViewController, menuController:UIViewController)
    {
        self.init(contentController:contentController, menuController:menuController, blurredType:ZCHBlurEffectStyle.Light)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    //MARK: - setup UI
    
    private var contentView:UIView?
    private var menuView:UIView?
    private var contentBtn:UIButton?
    private var gestureRecognizer:UIScreenEdgePanGestureRecognizer?
    private var originFrame:CGRect?
    private func setupChildrenViewController()
    {
        self.addChildViewController(contentController!)
        self.contentView = self.contentController?.view
        self.contentView?.frame = self.view.frame
        self.view.addSubview(self.contentView!)
        
        self.addChildViewController(menuController!)
        self.menuView = self.menuController?.view
        self.originFrame = CGRectMake(-CGRectGetWidth(self.view.frame) * sideControllerWidthScale, 0, CGRectGetWidth(self.view.frame) * sideControllerWidthScale, CGRectGetHeight(self.view.frame))
        self.menuView?.frame = originFrame!
        self.menuView?.alpha = 0.9
        self.menuView?.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.menuView!)
        
        self.contentBtn = UIButton(frame: CGRectNull)
        self.contentBtn?.addTarget(self, action: "clickToHiddenMenu", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.gestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "pantoShowOrHidden:")
        self.gestureRecognizer?.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(self.gestureRecognizer!)
    }
    
    private var contentBackgroudView:UIView?
    private func setupcontentBackgroudView() -> UIView
    {
        var view:UIView

        if #available(iOS 8.0, *) {
            
            var type:UIBlurEffectStyle
            switch self.blurredType
            {
            case .Dark:
                type = .Dark
                break
            case .ExtraLight:
                type = .ExtraLight
                break
            case .Light:
                type = .Light
                break
            }
            
            let blureffect = UIBlurEffect(style: type)
            view = UIVisualEffectView(effect: blureffect)
            view.frame = self.contentView!.bounds
        } else {
            view = UIImageView(frame: self.contentView!.bounds)
            let image = self.blurredSnapshot(self.contentView!.bounds, blurredType: self.blurredType)
            (view as! UIImageView).image = image
        }

        view.alpha = 0.0
        return view
    }
    
    private func setupSideControllerWidthScale()
    {
        if self.sideControllerWidth > 0
        {
            self.sideControllerWidthScale = self.sideControllerWidth / CGRectGetWidth(self.view.frame)
        }
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSideControllerWidthScale()
        
        self.setupChildrenViewController()
        
        self.contentBackgroudView = setupcontentBackgroudView()
    }
    
    //MARK: - animation
    
    func showMenu()
    {
        self.isShowing = true
        self.menuView?.hidden = false
        self.menuController?.beginAppearanceTransition(true, animated: true)
        
        self.addBlurBackgroundView()

        UIView.animateWithDuration(0.25, delay: 0, options: ([UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut]), animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.menuView?.frame = CGRectOffset(self.originFrame!, self.maxOffset(), 0)
            self.contentBackgroudView?.alpha = 0.8
        }) { (finished) -> Void in
            self.addContentBtn()
        }
    }
    
    func hiddenMenu()
    {
        self.isShowing = false
        UIView.animateWithDuration(0.25, delay: 0, options: ([UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut]), animations: { () -> Void in
            self.menuView?.frame = self.originFrame!
            self.contentBackgroudView?.alpha = 0.0
        }) { (finished) -> Void in
            self.menuView?.hidden = true
            self.removeContentBtn()
            self.contentBackgroudView?.removeFromSuperview()
        }
    }
    
    //MARK: - change UI
    
    private func addContentBtn()
    {
        if self.contentBtn?.superview != nil
        {
            return
        }
        
        self.contentBtn?.frame = self.contentView!.frame
        self.contentView?.addSubview(self.contentBtn!)
    }
    
    private func removeContentBtn()
    {
        if self.contentBtn?.superview == nil
        {
            return
        }
        self.contentBtn?.removeFromSuperview()
    }
    
    private func addBlurBackgroundView()
    {
        if self.contentBackgroudView?.superview == nil
        {
            self.contentView?.addSubview(self.contentBackgroudView!)
        }
    }
    
    //MARK: - Action
    
    private var isShowing = false
    func pantoShowOrHidden(pan:UIScreenEdgePanGestureRecognizer)
    {
        if isShowing
        {
            return
        }
        switch pan.state
        {
        case .Began:
            self.addBlurBackgroundView()
            self.menuView?.hidden = false
            break
            
        case .Changed:
            let translation = pan.translationInView(self.view)
            self.menuView?.frame = CGRectOffset(self.originFrame!, min(translation.x, maxOffset()), 0)
            self.contentBackgroudView?.alpha = alphaWithOffset(translation.x)
            break
            
        case .Ended:
            let velocity = pan.velocityInView(self.view)
            if velocity.x > 0
            {
                self.showMenu()
            }
            else {
                self.hiddenMenu()
            }
            break
            
        default:
            break
        }
    }
    
    func clickToHiddenMenu()
    {
        hiddenMenu()
    }
    
    //MARK: private method
    
    private func maxOffset() -> CGFloat
    {
        return CGRectGetWidth(self.menuView!.frame)
    }

    private func alphaWithOffset(offset:CGFloat) -> CGFloat
    {
        return max(min(1.0, offset/maxOffset()), 0.0)
    }
    
    //MARK: - Snapshot
    
    private func blurredSnapshot(frame:CGRect, blurredType:ZCHBlurEffectStyle) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 1.0)
        self.contentView?.drawViewHierarchyInRect(frame, afterScreenUpdates: false)
        let currentImage = UIGraphicsGetImageFromCurrentImageContext()
        var blurredSnapshotImage:UIImage
        switch blurredType
        {
        case .Light:
            blurredSnapshotImage = currentImage.applyLightEffect()
            break
        case .Dark:
            blurredSnapshotImage = currentImage.applyDarkEffect()
            break
        case .ExtraLight:
            blurredSnapshotImage = currentImage.applyExtraLightEffect()
        }
        
        UIGraphicsEndImageContext()
        
        return blurredSnapshotImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
