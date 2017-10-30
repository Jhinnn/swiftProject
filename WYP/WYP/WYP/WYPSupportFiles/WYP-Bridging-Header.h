//
//  WYP-Bridging-Header.h
//  WYP
//
//  Created by 你个LB on 2017/3/6.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

#ifndef WYP_Bridging_Header_h
#define WYP_Bridging_Header_h

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#endif /* WYP_Bridging_Header_h */

#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "IQKeyboardManager.h"
#import <RongIMKit/RongIMKit.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
//#import "LHPerformanceStatusBar.h"
#import "XHLaunchAd.h"
//#import <Bugtags/Bugtags.h>
#import "UITextView+PlaceHolder.h"
#import "PYSearch.h"
#import "YBPopupMenu.h"
//#import "MJExtension.h"
#import "CCPScrollView.h"
#import "PooCodeView.h"
#import "UIButton+WebCache.h"
#import "StatementFrameModel.h"
#import "StarAndCommentModel.h"
#import "StatementCell.h"
#import "AlbumViewController.h"
#import "PublicGroupViewController.h"
#import "CMInputView.h"
#import "FYLCityPickView.h"
#import "WMPlayer.h"
#import "UIImageView+WebCache.h"

// 支付相关
#import "WXApi.h"

// 开屏广告
#import "XHLaunchAd.h"


//中文排序
#import "ChineseString.h"

// 图集
#import "WBImageBrowserCell.h"
#import "WBImageBrowserView.h"

// 二维码扫描
#import "SGQRCode.h"
