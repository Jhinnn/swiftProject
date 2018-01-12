//
//  ShowCommentView.m
//  HePingNet
//
//  Created by 你个LB on 2016/11/30.
//  Copyright © 2016年 NGeLB. All rights reserved.
//



#import "ShowCommentView.h"
#import "StarAndCommentModel.h"
@implementation ShowCommentView

- (void)setCommentArray:(NSArray *)commentArray {
    if (_commentArray != commentArray) {
        _commentArray = commentArray;
        
        NSMutableArray * nickNameBtnArray = [NSMutableArray array];
        NSMutableArray * commentLabelArray = [NSMutableArray array];
        
        for (UIView * subview in self.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                // 子视图是按钮
                [nickNameBtnArray addObject:subview];
            } else {
                // 子视图是文本标签
                [commentLabelArray addObject:subview];
            }
        }
        
        // 判断是否需要新创建按钮和文本标签
        if (commentLabelArray.count < commentArray.count) {
            NSInteger addNumber = commentArray.count - commentLabelArray.count;
            for (NSInteger i = 0; i < addNumber; i ++) {
                // 创建评论文本标签
                UILabel * commentLabel = [[UILabel alloc] init];
                commentLabel.numberOfLines = 0;
                commentLabel.font = [UIFont systemFontOfSize:13];
                commentLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
                
                [self addSubview:commentLabel];
                [commentLabelArray addObject:commentLabel];
                // 创建昵称按钮
                UIButton * nickNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                nickNameBtn.backgroundColor = [UIColor clearColor];
                nickNameBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                
                [nickNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self addSubview:nickNameBtn];
                [nickNameBtnArray addObject:nickNameBtn];
            }
        } else if (commentLabelArray.count > commentArray.count) {
            NSInteger removeNumber = commentLabelArray.count - commentArray.count;
            // 清除不用的数据
            for (NSInteger i = 0; i < removeNumber; i ++) {
                
                // 移除昵称按钮
                UIButton * nickNameBtn = [nickNameBtnArray lastObject];
                [nickNameBtn removeFromSuperview];
                [nickNameBtnArray removeLastObject];
                
                // 移除评论内容
                UILabel * commentLabel = [commentLabelArray lastObject];
                [commentLabel removeFromSuperview];
                [commentLabelArray removeLastObject];
            }
        }
        // 设置数据
        for (NSInteger i = 0; i < commentArray.count; i ++) {
            // 获取点赞昵称
            StarAndCommentModel * comment = commentArray[i];
            UIButton * nickNameBtn = nickNameBtnArray[i];
            // 设置标题
            [nickNameBtn setTitle:comment.nickName forState:UIControlStateNormal];
            
            UILabel * commentLabel = commentLabelArray[i];
            // 设置内容
            commentLabel.text = [NSString stringWithFormat:@":%@",comment.comment];
        }
    }
}

- (void)setNickNameFArray:(NSMutableArray *)nickNameFArray {
    if (_nickNameFArray != nickNameFArray) {
        _nickNameFArray = nickNameFArray;
        
        NSMutableArray * nickNameBtnArray = [NSMutableArray array];
        NSMutableArray * commentLabelArray = [NSMutableArray array];
        
        for (UIView * subview in self.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                // 子视图是按钮
                [nickNameBtnArray addObject:subview];
            } else {
                // 子视图是文本标签
                [commentLabelArray addObject:subview];
            }
        }
        for (NSInteger i = 0; i < nickNameBtnArray.count; i ++) {
            // 获取昵称frame
            NSValue * nickNameRectValue = nickNameFArray[i];
            CGRect nickNameRect = [nickNameRectValue CGRectValue];
            
            UIButton * nickNameBtn = nickNameBtnArray[i];
            // 设置frame
            nickNameBtn.frame = nickNameRect;
        }
    }
}

- (void)setCommentTextFArray:(NSMutableArray *)commentTextFArray commentHeadIndentFArray:(NSMutableArray *)commentHeadIndentFArray {
    
    NSMutableArray * nickNameBtnArray = [NSMutableArray array];
    NSMutableArray * commentLabelArray = [NSMutableArray array];
    
    for (UIView * subview in self.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            // 子视图是按钮
            [nickNameBtnArray addObject:subview];
        } else {
            // 子视图是文本标签
            [commentLabelArray addObject:subview];
        }
    }
    for (NSInteger i = 0; i < commentLabelArray.count; i ++) {
        // 获取评论文本标签
        UILabel * commentLabel = commentLabelArray[i];
        // 获取评论内容
        StarAndCommentModel * comment = self.commentArray[i];
        // 获取缩进距离
        NSNumber * headIndent = commentHeadIndentFArray[i];
        CGFloat headIndentFloat = [headIndent floatValue];
        // 获取昵称frame
        NSValue * commentTextRectValue = commentTextFArray[i];
        CGRect commentTextRect = [commentTextRectValue CGRectValue];
        
        // 设置frame
        commentLabel.frame = commentTextRect;
        
        // 设置富文本
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:comment.comment];
        // 初始化
        //设置缩进、行距
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        // 设置首行缩进
        style.firstLineHeadIndent = headIndentFloat;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [comment.comment length])];
        commentLabel.attributedText = attributedString;
    }
}

@end
