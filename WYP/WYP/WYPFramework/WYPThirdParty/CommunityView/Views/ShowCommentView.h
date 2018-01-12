//
//  ShowCommentView.h
//  HePingNet
//
//  Created by 你个LB on 2016/11/30.
//  Copyright © 2016年 NGeLB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowCommentView : UIView

/**
 评论数组
 */
@property (strong, nonatomic) NSArray * commentArray;

/**
 评论昵称frame数组
 */
@property (strong, nonatomic) NSMutableArray * nickNameFArray;



/**
 设置评论内容的frame和首行缩进距离

 @param commentTextFArray 评论内容frame数组
 @param commentHeadIndentFArray 评论内容首行缩进距离数组
 */
- (void)setCommentTextFArray:(NSMutableArray *)commentTextFArray commentHeadIndentFArray:(NSMutableArray *)commentHeadIndentFArray;
@end
