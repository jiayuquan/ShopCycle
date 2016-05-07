//
//  PurchaseCell.swift
//  shop
//
//  Created by mac on 16/5/6.
//  Copyright © 2016年 JiaYQ. All rights reserved.
//

import UIKit

protocol PurchaseCellDelegate: NSObjectProtocol {
    
    func shoppingCartCell(cell: PurchaseCell, button: UIButton, countLabel: UILabel)
    func reCalculateTotalPrice()
}
class PurchaseCell: UITableViewCell {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newPriceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var goodCountLabel: UILabel!
    @IBOutlet weak var addAndsubtraction: UIButton!
    @IBOutlet weak var subtractionButton: UIButton!
    
    weak var delegate: PurchaseCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconView.layer.cornerRadius = 30
        iconView.layer.masksToBounds = true
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    @IBAction func selectButtonClick(button: UIButton) {
        // 选中
        button.selected = !button.selected
        goodModel?.isShopSelected = button.selected
        
        delegate?.reCalculateTotalPrice()
    }
    
    @IBAction func addAndsubtractionClick(button: UIButton) {
        delegate?.shoppingCartCell(self, button: button, countLabel: goodCountLabel)
    }
    
    @IBAction func subtractionButtonClick(button: UIButton) {
        delegate?.shoppingCartCell(self, button: button, countLabel: goodCountLabel)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    var goodModel: DrawerCellModel? {
        didSet {
            selectButton.selected = goodModel!.isShopSelected
            goodCountLabel.text = "\(goodModel!.count)"
            iconView.image = UIImage(named: goodModel!.imageName!)
            titleLabel.text = goodModel?.title
            newPriceLabel.text = "\(goodModel!.newPrice!)"
            oldPriceLabel.text = "\(goodModel!.oldPrice!)"
            
            layoutIfNeeded()
        }
    }
    
    
}
