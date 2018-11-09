//
//  TCTabView.h
//  TCTabView
//
//  Created by pengpeng on 2017/3/7.
//  Copyright © 2017年 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCTabViewDelegate <NSObject>

- (void)selectedGroup:(NSInteger)type;

@end

@interface TCTabView : UIView

@property (nonatomic,weak) __weak id <TCTabViewDelegate> delegate;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) UIButton * liveButton;

@property (nonatomic, strong) UIButton * inteButton;

@property (nonatomic, strong) UIButton * riceButton;

@property (nonatomic, strong) UIView * lineView;

- (void)switchToTab:(NSInteger)tab; // 1  2 3

@end
