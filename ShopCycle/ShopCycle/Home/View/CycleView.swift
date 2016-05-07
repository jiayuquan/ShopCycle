//
//  CycleView.swift
//  shop
//
//  Created by mac on 16/5/4.
//  Copyright © 2016年 JiaYQ. All rights reserved.
//

import UIKit

class CycleCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(cycleView)
    }
    
    override func layoutSubviews() {
        setupUI()
        super.layoutSubviews()
        cycleView.frame = bounds
    }
    
    lazy var cycleView: CycleView = {
        let cyc = CycleView(frame: self.bounds, imagesStr: ["scr0", "scr1", "scr2", "scr3", "scr4"])
        cyc.timerCount = 3.0
        
        return cyc
    }()
}

@objc protocol CycleViewDelegate {
    optional func cycleView(didClickPage : UIImageView, index: Int)
}
class CycleView: UIView {
    
    /**
     初始化轮播器
     
     - parameter frame:     轮播器的frame
     - parameter imagesStr: 图片数组(存放图片名字)
     
     - returns: nil
     */
    init(frame: CGRect, imagesStr: [String]) {
        super.init(frame: frame)
        
        setupUI()
        addTap()
        addImages = imagesStr
        pageControll.numberOfPages = addImages.count
        reloadImage()
    }
    
    func setupUI() {
        addSubview(autoCycleScrollView)
        addScrollViewContent()
        addSubview(pageControll)
    }
    
    /**
     添加滚动轮播器的3个imageView
     */
    func addScrollViewContent() {
        autoCycleScrollView.addSubview(leftView)
        autoCycleScrollView.addSubview(centerView)
        autoCycleScrollView.addSubview(rightView)
        
        leftView.contentMode = .ScaleToFill
        centerView.contentMode = .ScaleToFill
        rightView.contentMode = .ScaleToFill
    }
    
    /**
     手势方法
     */
    func tapAction(tap: UITapGestureRecognizer) {
        self.delegate?.cycleView!(tap.view as! UIImageView, index: self.currentPage)
    }
    
    /**
     添加手势
     */
    func addTap() {
        leftView.userInteractionEnabled = true
        centerView.userInteractionEnabled = true
        rightView.userInteractionEnabled = true
        let tapL = UITapGestureRecognizer(target: self, action: #selector(CycleView.tapAction(_:)))
        let tapC = UITapGestureRecognizer(target: self, action: #selector(CycleView.tapAction(_:)))
        let tapR = UITapGestureRecognizer(target: self, action: #selector(CycleView.tapAction(_:)))
        leftView.addGestureRecognizer(tapL)
        centerView.addGestureRecognizer(tapC)
        rightView.addGestureRecognizer(tapR)
    }
    
    /**
     刷新ScrollView的图片
     */
    func reloadImage() {
        //移除3个imageView
        for view in autoCycleScrollView.subviews {
            view.removeFromSuperview()
        }
        
        //加载图片用的索引
        let left = (currentPage - 1 + addImages.count) % addImages.count
        let center = currentPage
        let right = (currentPage + 1 + addImages.count) % addImages.count
        
        leftView.image = UIImage(named: addImages[left])
        centerView.image = UIImage(named: addImages[center])
        rightView.image = UIImage(named: addImages[right])
        
        //重新添加3个imageView
        addScrollViewContent()
        
        if addImages.count == 1 {
            showPageControl = false
            autoCycleScrollView.contentSize = CGSizeMake(frame.width, frame.height)
            autoCycleScrollView.setContentOffset(CGPointMake(0, 0), animated: false)
        } else {
            showPageControl = true
            timeInterval = timerCount

            autoCycleScrollView.contentSize = CGSizeMake(frame.width * CGFloat(addImages.count == 2 ? 3: addImages.count), frame.height)
            autoCycleScrollView.setContentOffset(CGPointMake(frame.width, 0), animated: false)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        pageControll.frame = CGRectMake(0, frame.height - 15, frame.width, 10)
        leftView.frame = CGRectMake(0, 0, frame.width, frame.height)
        centerView.frame = CGRectMake(frame.width, 0, frame.width, frame.height)
        rightView.frame = CGRectMake(frame.width * 2, 0, frame.width, frame.height)
    }

     //MARK:定时执行的方法
    func startAutoCycle(){
        autoCycleScrollView.setContentOffset(CGPointMake(frame.width * 2, 0), animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: CycleViewDelegate?
//MARK: 加载控件
    //scrollView上面通过3个imageView进行循环轮播,每轮播一次就重新加载一次3个imageVIew控件
    private var leftView = UIImageView()
    private var centerView = UIImageView()
    private var rightView = UIImageView()
    private lazy var pageControll: UIPageControl = {
       let pageControll = UIPageControl()
        pageControll.enabled = false
        pageControll.currentPage = 0
        
        return pageControll
    }()
    private lazy var autoCycleScrollView: UIScrollView = {
        let autoScroll = UIScrollView()
        autoScroll.bounces = false
        autoScroll.delegate = self
        autoScroll.pagingEnabled = true
        autoScroll.showsHorizontalScrollIndicator = false
        autoScroll.showsVerticalScrollIndicator = false
        autoScroll.frame = self.bounds
        
        return autoScroll
    }()
    
     //MARK: page相关
    private var currentPage = 0 {
        didSet {
            pageControll.currentPage = currentPage
        }
    }
    //设置是否显示pagecontrol
    var showPageControl: Bool = true {
        didSet {
            pageControll.hidden = !showPageControl
        }
    }
    
    //MARK: 数据源图片
    private var addImages: [String] = []
    
    //MARK:定时器相关变量
    //记录间隔时间
    var timerCount = 5.0 {
        didSet {
            if lastTimeInterval != timerCount {
                lastTimeInterval = timerCount
                timer?.invalidate()
                timer = NSTimer.scheduledTimerWithTimeInterval(timerCount, target: self, selector: #selector(CycleView.startAutoCycle), userInfo: nil, repeats: true)
                //把time加入运行循环
                NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
            }
        }
    }
    private var timer: NSTimer? = nil
    //记录最后一次时间间隔
    private var lastTimeInterval = 0.0
    private var timeInterval = 0.0 {
        didSet {
            if timer == nil {
                lastTimeInterval = timerCount
                timer = NSTimer.scheduledTimerWithTimeInterval(timerCount, target: self, selector: #selector(CycleView.startAutoCycle), userInfo: nil, repeats: true)
                //把time加入运行循环
                NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
            }
        }
    }
}

extension CycleView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if self.timer != nil {
            if self.timer!.valid {
                self.timer!.fireDate = NSDate.distantFuture() as NSDate
            }
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.timer != nil {
            //self.timer!.fireDate = NSDate.distantFuture() as NSDate
            self.timer!.fireDate = NSDate(timeIntervalSinceNow: timeInterval) as NSDate
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if addImages.count <= 0 { return }
        let x = scrollView.contentOffset.x
        if x >= (frame.width * 2) {
            currentPage = (currentPage + 1 + addImages.count) % addImages.count
            reloadImage()
        }else if x <= 0 {
            currentPage = (currentPage - 1 + addImages.count) % addImages.count
            reloadImage()
        }
    }
    
    //拖拽减速即将停止时,将偏移量移至中间的imageView
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        autoCycleScrollView.setContentOffset(CGPointMake(frame.width, 0), animated: true)
    }
}
