//
//  DrawerCell.swift
//  shop
//
//  Created by mac on 16/5/6.
//  Copyright © 2016年 JiaYQ. All rights reserved.
//

import UIKit

@objc protocol DrawerCellDelegate {
    optional func drawerCell(drawerCell : DrawerCell, model: DrawerCellModel)
}
class DrawerCell: UITableViewCell {

    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftSubTitle: UILabel!
    @IBOutlet weak var leftTitle: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var leftBtn: UIButton!
    
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var rightTitle: UILabel!
    @IBOutlet weak var rightSubTitle: UILabel!
    @IBOutlet weak var rightBtn: UIButton!
    
    weak var delegate:DrawerCellDelegate?
    
    @IBAction func leftButtonClick(sender: AnyObject) {
        leftDrawerModel?.isSelected = !(leftDrawerModel?.isSelected)!
        leftBtn.selected = (leftDrawerModel?.isSelected)!
        delegate?.drawerCell!(self, model: leftDrawerModel!)
    }
    
    @IBAction func rightButtonClick(sender: AnyObject) {
        rightDrawerModel?.isSelected = !(rightDrawerModel?.isSelected)!
        rightBtn.selected = (rightDrawerModel?.isSelected)!
        delegate?.drawerCell!(self, model: rightDrawerModel!)
    }
    var leftDrawerModel: DrawerCellModel? {
        didSet {
            leftImage.image = UIImage.init(named: leftDrawerModel!.imageName!)
            leftTitle.text = leftDrawerModel!.title
            leftSubTitle.text = leftDrawerModel!.subTitle
            leftBtn.selected = leftDrawerModel!.isSelected
        }
    }
    
    var rightDrawerModel: DrawerCellModel? {
        didSet {
            rightImage.image = UIImage.init(named: rightDrawerModel!.imageName!)
            rightTitle.text = rightDrawerModel!.title
            rightSubTitle.text = rightDrawerModel!.subTitle
            rightBtn.selected = rightDrawerModel!.isSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.None
        leftImage.layer.masksToBounds = true
        leftImage.layer.cornerRadius = 25
        
        rightImage.layer.masksToBounds = true
        rightImage.layer.cornerRadius = 25
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
