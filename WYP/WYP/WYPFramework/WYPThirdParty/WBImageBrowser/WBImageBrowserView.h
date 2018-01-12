//
//  WBImageBrowserView.h
//  WBImageBrowser
//
//  Created by 李伟宾 on 16/7/29.
//  Copyright © 2016年 李伟宾. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

// 判断是否是iPhone X
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)

@protocol WBImageBrowserViewDelegate <NSObject>

//- (void)pictureBrowserViewhide;
@optional
- (void)getContentWithItem:(NSInteger)item ;
- (void)backButtonToClick;
- (void)shareButtonToClick;
- (void)longPressButtonToClick:(UIImage *)image;
- (void)onceButtonToClick;
- (void)saveImageButtonToClick:(UIImage *)image;

@end

@interface WBImageBrowserView : UIView


/** 图片开始的索引 */
@property (nonatomic, assign) NSInteger startIndex;

@property (nonatomic, assign) id<WBImageBrowserViewDelegate> delegate;



/** 屏幕方向 */
@property (nonatomic, assign) UIDeviceOrientation orientation;

/** 用到的 */
@property (nonatomic, strong) UIViewController *viewController;

@property (nonatomic, assign) NSInteger type;  //哪个界面

@property (nonatomic, strong) UIView   *topBgView;      // 顶部背景视图

@property (nonatomic, strong) UIView   *bottomBgView;      // 顶部背景视图

@property (nonatomic, strong) UIButton  *shareButton;       // 分享按钮

@property (nonatomic, strong) UILabel *indexLabel; // 1/12  2/12

/**
 *  网络图片初始化方式
 */
+ (instancetype)pictureBrowsweViewWithFrame:(CGRect)frame delegate:(id<WBImageBrowserViewDelegate>)delegate browserInfoArray:(NSArray *)browserInfoArray;


/**
 *  显示在父视图
 *
 *  @param view 父视图
 */
- (void)showInView:(UIView *)view;
@end
