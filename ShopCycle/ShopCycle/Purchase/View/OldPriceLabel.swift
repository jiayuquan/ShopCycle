//
//  OldPriceLabel.swift
//  shop
//
//  Created by mac on 16/5/6.
//  Copyright © 2016年 JiaYQ. All rights reserved.
//

import UIKit

class OldPriceLabel: UILabel {

    override func drawRect(rect: CGRect) {
        // 调用父类是为了让Label原有数据正常显示
        super.drawRect(rect)
        
        // 绘制中划线
        let ctx = UIGraphicsGetCurrentContext()
        CGContextMoveToPoint(ctx, 0, rect.size.height * 0.5)
        CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height * 0.5)
        CGContextStrokePath(ctx)
    }

}
