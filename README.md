# BlurSlipSideMenu

#使用方法
  1. 需要三个控制器： 一个作为父控制器存在，一个作为展示主界面的控制器，一个作为侧滑出来的控制器：
  
        let sideMenuController = SlidsidTableViewController()
        let nav = UINavigationController(rootViewController: MainViewController())
        let controller = RootViewController()
        controller.menuController = sideMenuController
        controller.contentController = nav
        controller.sideControllerWidthScale = 0.5
        controller.blurredType = .Dark
  
  2.需要两个控制器：一个作为父控制器并且作为展示主界面的控制器，另一个作为侧滑出来的控制器：
  
        let controller = ViewController()
        controller.menuController = sideMenuController
        controller.sideControllerWidthScale = 0.5
        controller.blurredType = .Light
        
  另外，在扩展中提供了几个便利构造器方法可以使用。
  
  3. 完成1或者2之后，在父控制器的viewDidLoad()方法中添加下面这句话：
  
        self.setupChildrenViewController()
        
  就此可以滑出左边菜单栏
  
