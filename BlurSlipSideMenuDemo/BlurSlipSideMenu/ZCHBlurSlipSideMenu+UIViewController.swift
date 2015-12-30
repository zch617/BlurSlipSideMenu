//
//  ZCHBlurSlipSideMenu+UIViewController.swift
//  BlurSlipSideMenuDemo
//
//  Created by 张慈航 on 15/12/19.
//  Copyright © 2015年 com.zhangcihang. All rights reserved.
//

import UIKit

//enum ZCHBlurEffectStyle : Int {
//    
//    case ExtraLight
//    case Light
//    case Dark
//}

extension RootViewController {
    
    //MARK: - init

    convenience init(menuController:UIViewController)
    {
        self.init(menuController: menuController, contentController: nil, blurredType: .Light, sideControllerWidthScale: 0.8)
    }
    
    convenience init(menuController:UIViewController, contentController:UIViewController?)
    {
        self.init(menuController: menuController, contentController: nil, blurredType: .Light, sideControllerWidthScale: 0.8)
    }
    
    convenience init(menuController:UIViewController, contentController:UIViewController?, blurredType:ZCHBlurEffectStyle, sideControllerWidthScale:CGFloat)
    {
        self.init()
        
        self.menuController = menuController
        self.contentController = contentController
        AssociatedKeys.blurredType = blurredType
        self.sideControllerWidthScale = sideControllerWidthScale
    }
    
    convenience init(menuController:UIViewController, contentController:UIViewController?, blurredType:ZCHBlurEffectStyle,sideControllerWidth:CGFloat)
    {
        self.init()
        
        self.menuController = menuController
        self.contentController = contentController
        AssociatedKeys.blurredType = blurredType
        AssociatedKeys.sideControllerWidth = sideControllerWidth
        self.sideControllerWidthScale = 0
    }
    
    //MARK: - struct
    
    private struct AssociatedKeys {
        
        static var MenuControllerKey = "zch_MenuControllerKey"
        static var ContentControllerKey = "zch_ContentControllerKey"
        static var SideControllerWidthScaleKey = "zch_SideControllerWidthScaleKey"
        
        static var isShowing = false
        static var contentBtn = UIButton(frame: CGRectNull)
        static var contentBackgroudView = UIView(frame: CGRectNull)
        static var originFrame = CGRectNull
        
        static var blurredType:ZCHBlurEffectStyle = .Light
        static var sideControllerWidth:CGFloat = 0
    }
    
    //MARK: - public property
    /// 侧滑栏控制器（必须实现）
    var menuController:UIViewController? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.MenuControllerKey) as? UIViewController
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.MenuControllerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    /// 主显示内容的控制器
    var contentController:UIViewController? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ContentControllerKey) as? UIViewController
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.ContentControllerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    /// 侧滑栏占整个屏幕宽度的百分比
    var sideControllerWidthScale: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.SideControllerWidthScaleKey) as? CGFloat
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.SideControllerWidthScaleKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //MARK: - private perporty
    
    /// 侧滑滑出时的背景模糊风格
    private var blurredType:ZCHBlurEffectStyle? {
        return AssociatedKeys.blurredType
    }
    
    /// 侧滑栏宽度 （sideControllerWidth 和 sideControllerWidthScale 使用其中一个，默认用sideControllerWidthScale）
    private var sideControllerWidth: CGFloat? {
        return AssociatedKeys.sideControllerWidth
    }
    
    private func originFrame() -> CGRect
    {
        return CGRectMake(-CGRectGetWidth(self.view.frame) * sideControllerWidthScale!, 0, CGRectGetWidth(self.view.frame) * sideControllerWidthScale!, CGRectGetHeight(self.view.frame))
    }
    
    private var menuView: UIView? {
        return self.menuController?.view
    }
    
    private var contentView: UIView {
        return self.contentController?.view ?? self.view
    }
    
    //MARK: - setup ui
    
    /// 必须在viewDidLoad中调用
    func setupChildrenViewController()
    {
        self.setupSideControllerWidthScale()
        AssociatedKeys.originFrame = originFrame()
        
        if self.contentController != nil {
            self.addChildViewController(self.contentController!)
            self.contentView.frame = self.view.frame
            self.view.addSubview(self.contentView)
        }
        
        self.addChildViewController(menuController!)
        self.menuView?.frame = AssociatedKeys.originFrame
        self.menuView?.alpha = 0.9
        self.menuView?.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.menuView!)
        
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "pantoShowOrHidden:")
        gestureRecognizer.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(gestureRecognizer)
        
        AssociatedKeys.contentBtn.addTarget(self, action: "clickToHiddenMenu", forControlEvents: UIControlEvents.TouchUpInside)
        AssociatedKeys.contentBackgroudView = setupcontentBackgroudView()
    }
    
    //MARK: - animation
    
    func showMenu()
    {
        AssociatedKeys.isShowing = true
        self.menuView?.hidden = false
        self.menuController?.beginAppearanceTransition(true, animated: true)
        
        self.addBlurBackgroundView()
        
        UIView.animateWithDuration(0.25, delay: 0, options: ([UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut]), animations: { () -> Void in
            
            self.view.layoutIfNeeded()
            self.menuView?.frame = CGRectOffset(AssociatedKeys.originFrame, self.maxOffset(), 0)
            AssociatedKeys.contentBackgroudView.alpha = 0.8
            
            }) { (finished) -> Void in
                
                self.addContentBtn()
        }
    }
    
    func hiddenMenu()
    {
        AssociatedKeys.isShowing = false
        UIView.animateWithDuration(0.25, delay: 0, options: ([UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut]), animations: { () -> Void in
            
            self.menuView?.frame = AssociatedKeys.originFrame
            AssociatedKeys.contentBackgroudView.alpha = 0.0
            
            }) { (finished) -> Void in
                
                self.menuView?.hidden = true
                self.removeContentBtn()
                AssociatedKeys.contentBackgroudView.removeFromSuperview()
        }
    }
    
    //MARK: - change UI
    
    private func addContentBtn()
    {
        if AssociatedKeys.contentBtn.superview != nil
        {
            return
        }
        
        AssociatedKeys.contentBtn.frame = self.contentView.bounds
        self.contentView.addSubview(AssociatedKeys.contentBtn)
        self.contentView.bringSubviewToFront(self.menuView!)
    }
    
    private func removeContentBtn()
    {
        if AssociatedKeys.contentBtn.superview == nil
        {
            return
        }
        AssociatedKeys.contentBtn.removeFromSuperview()
    }
    
    private func addBlurBackgroundView()
    {
        if AssociatedKeys.contentBackgroudView.superview == nil
        {
            self.contentView.addSubview(AssociatedKeys.contentBackgroudView)
            self.contentView.bringSubviewToFront(self.menuView!)
        }
    }
    
    //MARK: - Action
    
    
    func pantoShowOrHidden(pan:UIScreenEdgePanGestureRecognizer)
    {
        if AssociatedKeys.isShowing
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
            self.menuView?.frame = CGRectOffset(AssociatedKeys.originFrame, min(translation.x, maxOffset()), 0)
            AssociatedKeys.contentBackgroudView.alpha = alphaWithOffset(min(translation.x, maxOffset()))
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
    
    private func setupcontentBackgroudView() -> UIView
    {
        var view:UIView
        
        if #available(iOS 8.0, *) {
            
            var type:UIBlurEffectStyle
            switch self.blurredType!
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
            view.frame = self.contentView.bounds
        } else {
            view = UIImageView(frame: self.contentView.bounds)
            let image = self.blurredSnapshot(self.contentView.bounds, blurredType: self.blurredType!)
            (view as! UIImageView).image = image
        }
        
        view.alpha = 0.0
        return view
    }
    
    private func setupSideControllerWidthScale()
    {
        if self.sideControllerWidth > 0
        {
            self.sideControllerWidthScale = self.sideControllerWidth! / CGRectGetWidth(self.view.frame)
        }
        else {
            if self.sideControllerWidthScale == nil
            {
                self.sideControllerWidthScale = 0.8
            }
        }
    }

    //MARK: - Snapshot
    
    private func blurredSnapshot(frame:CGRect, blurredType:ZCHBlurEffectStyle) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 1.0)
        self.contentView.drawViewHierarchyInRect(frame, afterScreenUpdates: false)
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
}
