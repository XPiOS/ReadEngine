//
//  ScrollModeViewController.h
//  创新版
//
//  Created by XuPeng on 16/6/15.
//  Copyright © 2016年 cxb. All rights reserved.
//  滚动模式

#import <UIKit/UIKit.h>
@class ScrollModeViewController;

@protocol ScrollModeViewControllerDelegate <NSObject>

/**
 *  获取下一页展示内容控制器
 *
 *  @param scrollModeViewController 当前控制器
 *
 *  @return 下一页展示内容控制器
 */
- (UIViewController *)ScrollModeViewControllerNextViewController:(ScrollModeViewController *)scrollModeViewController;

/**
 *  退出自动阅读
 */
- (void)ScrollModeViewControllerExit;

@end

@interface ScrollModeViewController : UIViewController

@property (nonatomic, weak) id<ScrollModeViewControllerDelegate>delegate;

/**
 *  创建滚动自动阅读
 *
 *  @param currentViewController 下层展示控制器
 *  @param nextViewController    上层展示控制器
 *  @param topHeight             顶部高度
 *  @param bottomHeight          底部高度
 *  @param speed                 速度
 *
 *  @return 滚动自动阅读控制器
 */
- (instancetype)initWithCurrentViewController:(UIViewController *)currentViewController nextViewController:(UIViewController *)nextViewController topHeight:(CGFloat)topHeight bottomHeight:(CGFloat)bottomHeight speed:(NSInteger)speed;

/**
 *  初始化视图
 */
- (void)initializeView;

/**
 *  暂停自动阅读
 */
- (void)automaticStopReading;

/**
 *  恢复自动阅读
 */
- (void)continueAutomaticReading;

/**
 *  设置自动阅读速度
 *
 *  @param speed 速度值
 */
- (void)automaticReadingSpeed:(NSInteger)speed;

@end
