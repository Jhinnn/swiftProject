//
//  ShowStarView.h
//  HePingNet
//
//  Created by 你个LB on 2016/11/30.
//  Copyright © 2016年 NGeLB. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShowStarView;

@protocol ShowStarViewDelegate <NSObject>

// 更多点赞按钮点击事件
- (void)showStarView:(ShowStarView *)starView list:(NSArray *)array;

@end

@interface ShowStarView : UIView

/**
 点赞昵称数组
 */
@property (strong, nonatomic) NSArray * starArray;

/**
 点赞frame数组
 */
@property (strong, nonatomic) NSMutableArray * starFArray;


@property (weak, nonatomic) id<ShowStarViewDelegate> delegate;

@end
