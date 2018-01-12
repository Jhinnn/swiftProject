//
//  StatementModel.h
//  HePingNet
//
//  Created by 你个LB on 2016/11/29.
//  Copyright © 2016年 NGeLB. All rights reserved.
//

#import "CXBaseModel.h"
#import "StarAndCommentModel.h"
@interface StatementModel : CXBaseModel

/**
 用户id
 */
@property (copy, nonatomic) NSString * userId;

/**
 数据id
 */
@property (copy, nonatomic) NSString * _id;

/**
 用户头像地址
 */
@property (copy, nonatomic) NSString * headImgUrl;

/**
 用户名
 */
@property (copy, nonatomic) NSString * name;

/**
 时间
 */
@property (copy, nonatomic) NSString * time;

/**
 发布的消息
 */
@property (copy, nonatomic) NSString * message;

/**
 原始图片数组
 */
@property (strong, nonatomic) NSArray * imageUrlArray;

/**
 缩略图数组
 */
@property (strong, nonatomic) NSArray * thumbImageUrlArray;

/**
 点赞数组
 */
@property (strong, nonatomic) NSArray * starArray;

/**
 评论数组
 */
@property (strong, nonatomic) NSArray * commentArray;


/**
 是否点赞  0.点赞  1.未点赞
 */
@property (strong, nonatomic) NSString * isStar;

/**
 是否展开消息
 */
//@property (assign, nonatomic) BOOL isExpandMessage;

@end
