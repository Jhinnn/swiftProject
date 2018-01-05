//
//  ShowStarView.m
//  HePingNet
//
//  Created by 你个LB on 2016/11/30.
//  Copyright © 2016年 NGeLB. All rights reserved.
//

// 控件之间的间距
#define space 15
// 姓名字体大小
#define nameFont [UIFont systemFontOfSize:14]

#import "ShowStarView.h"
#import "StarAndCommentModel.h"
@implementation ShowStarView


- (void)setStarArray:(NSArray *)starArray {
    if (_starArray != starArray) {
        _starArray = starArray;
        
        NSArray * starBtns = self.subviews;
        // 判断是否需要新创建按钮
        if (starBtns.count < starArray.count) {
            for (NSInteger i = 0; i < starArray.count - starBtns.count; i ++) {
                UIButton * starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                starBtn.backgroundColor = [UIColor whiteColor];
                starBtn.titleLabel.font = nameFont;
                [starBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateNormal];
                [self addSubview:starBtn];
            }
        } else if (starBtns.count > starArray.count) {
            // 复用的图片小于复用的图片，清除不用的图片数据(不是清除掉)
            for (NSInteger i = 0; i < starBtns.count - starArray.count; i ++) {
                UIButton * starBtn = self.subviews[starBtns.count - 1 - i];
                starBtn.hidden = YES;
            }
        }
        // 设置数据
        for (NSInteger i = 0; i < starArray.count; i ++) {
            // 获取点赞昵称
            StarAndCommentModel * star = starArray[i];
        
            UIButton * starBtn = self.subviews[i];
            NSString * btnTitle = [NSString stringWithFormat:@"%@、", star.nickName];
            if (i == starArray.count -1) {
                btnTitle = [NSString stringWithFormat:@"%@", star.nickName];
            }
            
            starBtn.backgroundColor = [UIColor clearColor];
            starBtn.hidden = NO;
            // 设置标题
            [starBtn setTitle:btnTitle forState:UIControlStateNormal];

            starBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
    }
}

- (void)setStarFArray:(NSMutableArray *)starFArray {
    if (_starFArray != starFArray) {
        _starFArray = starFArray;
        
        for (NSInteger i = 0; i < starFArray.count; i ++) {
            // 获取点赞昵称frame
            NSValue * starRectValue = starFArray[i];
            CGRect starRect = [starRectValue CGRectValue];
            UIButton * starBtn = self.subviews[i];
            
            // 设置frame
            starBtn.frame = starRect;
        }
    }
}

@end
