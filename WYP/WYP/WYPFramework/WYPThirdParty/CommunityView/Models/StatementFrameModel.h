//
//  StatementFrameModel.h
//  HePingNet
//
//  Created by 你个LB on 2016/11/29.
//  Copyright © 2016年 NGeLB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "StatementModel.h"
//#import "StarAndCommentModel.h"
@interface StatementFrameModel : NSObject

/**
 头像frame
 */
@property (assign, nonatomic) CGRect headImageF;

/**
 姓名frame
 */
@property (assign, nonatomic) CGRect nameF;

/**
 时间frame
 */
@property (assign, nonatomic) CGRect timeF;

/**
 消息frame
 */
@property (assign, nonatomic) CGRect messageF;

/**
 图片整体视图frame
 */
@property (assign, nonatomic) CGRect imageArrayF;

/**
 分享按钮frame
 */
@property (assign, nonatomic) CGRect shareF;

/**
 删除按钮frame
 */
@property (assign, nonatomic) CGRect deleteF;

/**
 点赞整体视图frame
 */
@property (assign, nonatomic) CGRect starArrayF;

@property (assign, nonatomic) CGRect zanArrayF;

/**
 评论整体视图frame
 */
@property (assign, nonatomic) CGRect commentArrayF;

/**
 所有图片frame的集合
 */
@property (strong, nonatomic) NSMutableArray * allImageF;



/**
 所有点赞昵称frame的集合
 */
@property (strong, nonatomic) NSMutableArray * allStarNickNameF;

/**
 所有评论昵称frame的集合
 */
@property (strong, nonatomic) NSMutableArray * allCommentNickNameF;

/**
 所有评论内容frame的集合
 */
@property (strong, nonatomic) NSMutableArray * allCommentTextF;

/**
 所有评论内容首行缩进距离的集合
 */
@property (strong, nonatomic) NSMutableArray * allCommentTextHeadIndentF;

/**
 *  cell的高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

/**
 说法模型
 */
@property (nonatomic, strong) StatementModel * statement;



@property (assign, nonatomic) CGFloat messageHeight;


@property (assign, nonatomic) BOOL isShowAllMessage;

@property (assign, nonatomic) BOOL isSeachResult;

@end
