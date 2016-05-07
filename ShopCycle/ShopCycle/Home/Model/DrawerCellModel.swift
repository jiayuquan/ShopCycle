//
//  DrawerCellModel.swift
//  shop
//
//  Created by mac on 16/5/6.
//  Copyright © 2016年 JiaYQ. All rights reserved.
//

import UIKit

class DrawerCellModel: NSObject {
    
    var title: String?
    var subTitle: String?
    var imageName: String?
    //判断是否选中了
    var isSelected = false
    //购物车中判断是否选中了
    var isShopSelected = true
    // 商品购买个数,默认0
    var count: Int = 1
    // 新价格
    var newPrice: NSNumber?
    // 老价格
    var oldPrice: NSNumber?
    
    
    class func loadData() -> [DrawerCellModel] {
        let path = NSBundle.mainBundle().pathForResource("DrawerCellModel", ofType: "plist")
        let data = NSArray(contentsOfFile: path!)
        var models = [DrawerCellModel]()
        for dict in data! {
            models.append(DrawerCellModel(dict: dict as! [String : AnyObject]))
        }
        
        return models
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
