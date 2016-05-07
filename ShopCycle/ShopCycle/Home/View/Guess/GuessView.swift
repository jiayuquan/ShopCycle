//
//  GuessView.swift
//  shop
//
//  Created by mac on 16/5/5.
//  Copyright © 2016年 JiaYQ. All rights reserved.
//

import UIKit

@objc protocol GuessCellDelegate {
    func cellDidClickChangeBtn(GuessView: GuessCell)
    func cellDidClickImageViewBg(GuessView: GuessCell)
}


class GuessCell: UITableViewCell {
    
    weak var delegate: GuessCellDelegate?
    @IBOutlet weak var imageViewBg: UIImageView!
    override func awakeFromNib() {
        addTap()
        imageViewBg.userInteractionEnabled = true
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    @IBAction func changeBtnClick(sender: AnyObject) {
        delegate?.cellDidClickChangeBtn(self)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    //点击图片执行
    func tapAction(tap: UITapGestureRecognizer) {
        delegate?.cellDidClickImageViewBg(self)
    }
    
    /**
     添加手势
     */
    func addTap() {
        imageViewBg.userInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(GuessCell.tapAction(_:)))
        imageViewBg.addGestureRecognizer(tap)

    }
}