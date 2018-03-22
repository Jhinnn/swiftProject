//
//  ShowStarView.m
//  HePingNet
//
//  Created by 你个LB on 2016/11/30.
//  Copyright © 2016年 NGeLB. All rights reserved.
//


#import "ShowStarView.h"
#import "StarAndCommentModel.h"
#import "UIButton+WebCache.h"
@implementation ShowStarView




- (void)setStarArray:(NSArray *)starArray {
    if (_starArray != starArray) {
        _starArray = starArray;
        
        NSArray * starBtns = self.subviews;
        // 判断是否需要新创建按钮
        if (starBtns.count < starArray.count) {
            for (NSInteger i = 0; i < starArray.count - starBtns.count; i ++) {
                UIButton * starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                starBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                starBtn.layer.masksToBounds = YES;
                starBtn.layer.cornerRadius = 11;
                starBtn.layer.borderColor = [UIColor whiteColor].CGColor;
                starBtn.layer.borderWidth = 1;
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
            NSString * btnTitle = [NSString stringWithFormat:@"%@,", star.nickName];
            if (i == starArray.count - 1) {
                btnTitle = [NSString stringWithFormat:@"%@", star.nickName];
            }
            
            starBtn.backgroundColor = [UIColor clearColor];
            starBtn.hidden = NO;
            // 设置标题
//            [starBtn setTitle:btnTitle forState:UIControlStateNormal];
            [starBtn sd_setImageWithURL:[NSURL URLWithString:star.imageUrl] forState:UIControlStateNormal];
            starBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
    }
}

- (void)setStarFArray:(NSMutableArray *)starFArray {
    if (_starFArray != starFArray) {
        _starFArray = starFArray;
        
        if (_starArray.count >= 4) {
            CGRect lastBtnRect = CGRectZero;
            for (NSInteger i = 0; i < 3; i ++) {
                // 获取点赞昵称frame
                NSValue * starRectValue = starFArray[i];
                CGRect starRect = [starRectValue CGRectValue];
                UIButton * starBtn = self.subviews[i];
                
                // 设置frame
                starBtn.frame = starRect;
                lastBtnRect = starRect;
            }
            
            UIButton *totalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            totalBtn.frame = CGRectMake(CGRectGetMaxX(lastBtnRect) + 10, 8, kScreen_width - 3 * space - 40 - _starArray.count * 22 - 10 - 30, 24);
            totalBtn.tag = 1001;
            totalBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [totalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            NSString *str = [NSString stringWithFormat:@"等%ld个人觉得很赞 >",_starArray.count];
            [totalBtn setTitle:str forState:UIControlStateNormal];
            [totalBtn addTarget:self action:@selector(zanListAction) forControlEvents:UIControlEventTouchUpInside];
            totalBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [self addSubview:totalBtn];
        }else {
            CGRect lastBtnRect = CGRectZero;
            for (NSInteger i = 0; i < starFArray.count; i ++) {
                // 获取点赞昵称frame
                NSValue * starRectValue = starFArray[i];
                CGRect starRect = [starRectValue CGRectValue];
                UIButton * starBtn = self.subviews[i];
                
                // 设置frame
                starBtn.frame = starRect;
                lastBtnRect = starRect;
            }
        }
        
        
    }
}

- (void)zanListAction {
    if ([self.delegate respondsToSelector:@selector(showStarView:list:)]) {
        [self.delegate showStarView:self list:self.starArray];
    }
}

@end
