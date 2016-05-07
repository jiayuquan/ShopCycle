//
//  MainViewController.swift
//  shop
//
//  Created by mac on 16/5/4.
//  Copyright © 2016年 JiaYQ. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.orangeColor()
        
        addChildViewController()
    }
    
    func addChildViewController() {

       addChildViewController("HomeViewController", title: "首页", imageName: "tabbar_home")
       addChildViewController("MessageViewController", title: "消息", imageName: "tabbar_message_center")
       addChildViewController("DiscoverViewController", title: "发现", imageName: "tabbar_discover")
       addChildViewController("ProfileViewController", title: "我", imageName: "tabbar_profile")

    }
    
    private func addChildViewController(childControllerName: String, title:String, imageName:String) {
        
        let namespace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        let cls:AnyClass = NSClassFromString(namespace + "." + childControllerName)!
        let vcCls = cls as! UIViewController.Type
        
        let vc = vcCls.init()
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        let navi = UINavigationController()
        navi.addChildViewController(vc)
        
        addChildViewController(navi)
    }
}
