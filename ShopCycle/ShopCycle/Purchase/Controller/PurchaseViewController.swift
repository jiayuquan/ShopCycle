//
//  PurchaseViewController.swift
//  shop
//
//  Created by mac on 16/5/6.
//  Copyright © 2016年 JiaYQ. All rights reserved.
//

import UIKit

let purchaseCellIdentifier = "purchaseCellIdentifier"

class PurchaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    
    private func setupUI() {
        navigationItem.title = "购物车"
        // 导航栏左边返回
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PurchaseViewController.cancelClick))
        
        // view背景颜色
        view.backgroundColor = UIColor.whiteColor()
        
        // cell行高
        tableView.rowHeight = 80
        
        tableView.registerNib(UINib.init(nibName: "PurchaseCell", bundle: nil), forCellReuseIdentifier: purchaseCellIdentifier)
        
        // 添加子控件
        view.addSubview(tableView)
        view.addSubview(bottomView)
    }
    
    override func viewWillLayoutSubviews() {
        setUIFrame()
    }
    
    private func setUIFrame() {
        tableView.frame = CGRectMake(0, 0, screenBounds.width, screenBounds.height - 49)
        bottomView.frame = CGRectMake(0, screenBounds.height - 49, screenBounds.width, 49)
    }
    
    func cancelClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func selectButtonClick(button: UIButton) {
        
    }
    
    /// 总金额，默认0.00
    var price: CFloat = 0.00
    //所有的商品
    var shopArray: [DrawerCellModel]?
    // MARK: - 懒加载
    /// tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        // 指定数据源和代理
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    /// 底部视图
    lazy var bottomView: PurchaseBottomView = {
        let bottomView = NSBundle.mainBundle().loadNibNamed("PurchaseBottomView", owner: nil, options: nil)[0] as! PurchaseBottomView
        bottomView.delegate = self
        
        return bottomView
    }()
}

extension PurchaseViewController: UITableViewDelegate, UITableViewDataSource, PurchaseCellDelegate, PurchaseBottomViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(purchaseCellIdentifier, forIndexPath: indexPath) as! PurchaseCell
        cell.goodModel = shopArray?[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func shoppingCartCell(cell: PurchaseCell, button: UIButton, countLabel: UILabel) {
        guard let indexPath = tableView.indexPathForCell(cell) else {
            return
        }
        
        let model = shopArray![indexPath.row]
        
        if button.tag == 100 {
            
            if model.count < 1 {
                print("数量不能低于0")
                return
            }
            
            // 减
            model.count -= 1
            countLabel.text = "\(model.count)"
        } else {
            // 加
            model.count += 1
            countLabel.text = "\(model.count)"
        }
        reCalculateTotalPrice()
    }
    
    func reCalculateTotalPrice() {
        // 遍历模型
        for model in shopArray! {
            
            // 只计算选中的商品
            if model.isShopSelected == true {
                price += Float(model.count) * model.newPrice!.floatValue
            }
        }
        
        // 赋值价格
        let attributeText = NSMutableAttributedString(string: "\(self.price)")
        attributeText.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(0, attributeText.length ))
        bottomView.totalPriceLabel.attributedText = attributeText
        
        // 清空price
        price = 0
        
        for model in shopArray! {
            if model.isShopSelected != true {
                // 只要有一个不等于就不全选
                bottomView.selectButton.selected = false
                break
            } else {
                bottomView.selectButton.selected = true
            }
        }
        
        // 刷新表格
        tableView.reloadData()
    }
    
    func selectorAllButtonClick() {
        for model in shopArray! {
             model.isShopSelected = !model.isShopSelected
        }
        reCalculateTotalPrice()
    }
}
