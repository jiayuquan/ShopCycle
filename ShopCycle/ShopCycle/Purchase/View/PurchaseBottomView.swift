//
//  PurchaseBottomView.swift
//  shop
//
//  Created by mac on 16/5/6.
//  Copyright © 2016年 JiaYQ. All rights reserved.
//

import UIKit

protocol PurchaseBottomViewDelegate: NSObjectProtocol {
    func selectorAllButtonClick()
}
class PurchaseBottomView: UIView {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    weak var delegate: PurchaseBottomViewDelegate?
    
    @IBAction func buyButtonClick(sender: AnyObject) {
        
    }

    @IBAction func selectButtonClick(sender: AnyObject) {
        delegate?.selectorAllButtonClick()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
