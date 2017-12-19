//
//  StarAndCommentModel.h
//  HePingNet
//
//  Created by 你个LB on 2016/11/30.
//  Copyright © 2016年 NGeLB. All rights reserved.
//

#import "CXBaseModel.h"

@interface StarAndCommentModel : CXBaseModel

/**
 用户id
 */
@property (copy, nonatomic) NSString * userId;

/**
 昵称
 */
@property (copy, nonatomic) NSString * nickName;

/**
 头像
 */
@property (copy, nonatomic) NSString * imageUrl;

/**
 评论内容
 */
@property (copy, nonatomic) NSString * comment;

@end
