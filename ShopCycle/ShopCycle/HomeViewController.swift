//
//  ViewController.swift
//  shop
//
//  Created by mac on 16/5/3.
//  Copyright © 2016年 JiaYQ. All rights reserved.
//

import UIKit

let screenBounds = UIScreen.mainScreen().bounds
private let shopCellIdentifier = "shopCellIdentifier "
let cycleViewIdentifier = "cycleViewIdentifier"
let guessCellIdentifier = "guessCellIdentifier"
let drawerCellIdentifier = "drawerCellIdentifier"
let scrollCollectionCellH:CGFloat = 200
class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupData()
    }
    
    func setupData() {
        drawers = DrawerCellModel.loadData()
    }
    
    override func viewWillLayoutSubviews() {
        tableView.frame = view.frame
        addCountLabel.frame = CGRectMake(screenBounds.width - 30, 20, 15, 15)
    }
    
    private func setupUI(){
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        navigationController?.navigationBar.addSubview(addCountLabel)
    }
    
    func shopButtonClick(button: UIButton) {
        let vc = PurchaseViewController()
        vc.shopArray = selecDrawers
        presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    //图片当前索引
    var indexImg: NSInteger = 0
    var drawers: [DrawerCellModel]?
    //要购买的
    var selecDrawers: [DrawerCellModel] = [DrawerCellModel]()
    let changeImagesArray: [String] = ["Guess0", "Guess1", "Guess2", "Guess3"]
    
    /// cartButton顶部购物车按钮
    lazy var cartButton: UIButton = {
        let carButton = UIButton(type: UIButtonType.Custom)
        carButton.setImage(UIImage(named: "button_cart"), forState: UIControlState.Normal)
        carButton.addTarget(self, action: #selector(HomeViewController.shopButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        carButton.sizeToFit()
        return carButton
    }()
    
    /// 已经添加进购物车的商品数量
    lazy var addCountLabel: UILabel = {
        let addCountLabel = UILabel()
        addCountLabel.backgroundColor = UIColor.whiteColor()
        addCountLabel.textColor = UIColor.redColor()
        addCountLabel.font = UIFont.boldSystemFontOfSize(11)
        addCountLabel.textAlignment = NSTextAlignment.Center
        addCountLabel.text = "\(self.selecDrawers.count)"
        addCountLabel.layer.cornerRadius = 7.5
        addCountLabel.layer.masksToBounds = true
        addCountLabel.layer.borderWidth = 1
        addCountLabel.layer.borderColor = UIColor.redColor().CGColor
        addCountLabel.hidden = true
        return addCountLabel
    }()
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.registerClass(CycleCell.self, forCellReuseIdentifier: cycleViewIdentifier)
        tableView.registerNib(UINib.init(nibName: "GuessView", bundle: nil), forCellReuseIdentifier: guessCellIdentifier)
        tableView.registerNib(UINib.init(nibName: "DrawerCell", bundle: nil), forCellReuseIdentifier: drawerCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate, CycleViewDelegate, GuessCellDelegate, DrawerCellDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            return (drawers?.count)! / 2
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cycleViewIdentifier, forIndexPath: indexPath) as! CycleCell
            cell.cycleView.delegate = self

            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(guessCellIdentifier, forIndexPath: indexPath) as! GuessCell
            cell.imageViewBg.image = UIImage(named: changeImagesArray[0])
            cell.delegate = self
            
            return cell
        } else if indexPath.section == 2 {
            

            let cell = tableView.dequeueReusableCellWithIdentifier(drawerCellIdentifier, forIndexPath: indexPath) as! DrawerCell
            cell.delegate = self
            
            if drawers?.count > indexPath.row * 2{
                cell.leftDrawerModel = drawers![indexPath.row * 2]
            }
            
            if drawers?.count > indexPath.row * 2 + 1 {
                cell.rightDrawerModel = drawers![indexPath.row * 2 + 1]
            }

            
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cycleViewIdentifier, forIndexPath: indexPath) as! CycleCell
        cell.cycleView.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 130
        }
        if indexPath.section == 2 {
            return 80
        }
        return scrollCollectionCellH
    }
    
    func cycleView(didClickPage: UIImageView, index: Int) {
        let vc = CyclePushVC()
        vc.index = index
        let navi = UINavigationController.init(rootViewController: vc)
        presentViewController(navi, animated: true, completion: nil)
    }
    
    func cellDidClickChangeBtn(guessView: GuessCell) {
        let imageView = guessView.imageViewBg
        imageView.tag += 1
        indexImg = imageView.tag % changeImagesArray.count
        let imageStr = changeImagesArray[indexImg]
        imageView.image = UIImage(named: imageStr)
        
        let anim = CATransition()
        anim.type = "push"
        anim.subtype = kCATransitionFromTop
        anim.duration = 0.3
        
        imageView.layer.addAnimation(anim, forKey: nil)
        }
    
    func cellDidClickImageViewBg(GuessView: GuessCell) {
        let vc = CyclePushVC()
        vc.index = indexImg
        let navi = UINavigationController.init(rootViewController: vc)
        self.presentViewController(navi, animated: true, completion: nil)
    }
    
    func drawerCell(drawerCell: DrawerCell, model: DrawerCellModel) {
        if selecDrawers.contains(model) {
            selecDrawers.removeAtIndex(selecDrawers.indexOf(model)!)
        } else {
            selecDrawers.append(model)
        }
        
        // 如果商品数大于0，显示购物车里的商品数量
        if self.selecDrawers.count > 0 {
            addCountLabel.hidden = false
        }
        
        let goodCountAnimation = CATransition()
        goodCountAnimation.duration = 0.25
        addCountLabel.text = "\(self.selecDrawers.count)"
        addCountLabel.layer.addAnimation(goodCountAnimation, forKey: nil)
        
        // 购物车抖动
        let cartAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        cartAnimation.duration = 0.25
        cartAnimation.fromValue = -5
        cartAnimation.toValue = 5
        cartAnimation.autoreverses = true
        cartButton.layer.addAnimation(cartAnimation, forKey: nil)
    }
}







