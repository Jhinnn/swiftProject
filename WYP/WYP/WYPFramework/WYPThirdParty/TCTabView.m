//
//  TCTabView.m
//  TCTabView
//
//  Created by pengpeng on 2017/3/7.
//  Copyright © 2017年 Arthur. All rights reserved.
//

#import "TCTabView.h"
#import "Masonry.h"
@implementation TCTabView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIButton *liveBtn = [UIButton new];
    liveBtn.tag = 1;
    [liveBtn setTitle:@"直播" forState:UIControlStateNormal];
    [liveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [liveBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    liveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [liveBtn addTarget:self action:@selector(tabBtnSwitch:) forControlEvents:UIControlEventTouchUpInside];
    liveBtn.selected = YES;
    _type = 1;
    [self addSubview:liveBtn];
    self.liveButton = liveBtn;
    
    UIButton *inteBtn = [UIButton new];
    inteBtn.tag = 2;
    [inteBtn setTitle:@"达人" forState:UIControlStateNormal];
    [inteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [inteBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    inteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [inteBtn addTarget:self action:@selector(tabBtnSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:inteBtn];
    self.inteButton = inteBtn;
    
    UIButton *riceBtn = [UIButton new];
    riceBtn.translatesAutoresizingMaskIntoConstraints = NO;
    riceBtn.tag = 3;
    [riceBtn setTitle:@"饭团" forState:UIControlStateNormal];
    [riceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [riceBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    riceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [riceBtn addTarget:self action:@selector(tabBtnSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:riceBtn];
    self.riceButton = riceBtn;
    
    UIView *singleView = [[UIView alloc] init];
    singleView.backgroundColor = [UIColor orangeColor];
    self.lineView = singleView;
    [self addSubview:singleView];
    
    [liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self);
        make.width.equalTo(inteBtn.mas_width);
    }];
    
    [inteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.equalTo(riceBtn.mas_width);
    }];
    
    [riceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self);
        make.width.equalTo(liveBtn.mas_width);
    }];
    
    [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(3);
        make.bottom.mas_equalTo(self);
        make.centerX.equalTo(liveBtn.mas_centerX);
    }];
}

- (void)tabBtnSwitch:(UIButton *)btn {
    if (btn.selected) {
        return;
    }
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            ((UIButton *)obj).selected = NO;
            ((UIButton *)obj).titleLabel.font = [UIFont systemFontOfSize:15];
        }
    }];
    
    btn.selected = YES;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _type = btn.tag;
    
    
    [UIView animateWithDuration:0.7 animations:^{
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(3);
            make.bottom.mas_equalTo(self);
            make.centerX.equalTo(btn.mas_centerX);
        }];
        
    }];
    
    if ([self.delegate respondsToSelector:@selector(selectedGroup:)]) {
        [self.delegate selectedGroup:btn.tag];
    }
}

- (void)switchToTab:(NSInteger)tab {
    if (tab == 1) {
        [self.liveButton sendAction:@selector(tabBtnSwitch:) to:self forEvent:[UIEvent new]];
    }else if (tab == 2) {
        [self.inteButton sendAction:@selector(tabBtnSwitch:) to:self forEvent:[UIEvent new]];
    }else if (tab == 3) {
        [self.riceButton sendAction:@selector(tabBtnSwitch:) to:self forEvent:[UIEvent new]];
    }
}



@end
