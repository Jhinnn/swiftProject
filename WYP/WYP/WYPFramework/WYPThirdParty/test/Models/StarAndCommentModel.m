//
//  StarAndCommentModel.m
//  HePingNet
//
//  Created by 你个LB on 2016/11/30.
//  Copyright © 2016年 NGeLB. All rights reserved.
//

#import "StarAndCommentModel.h"

@implementation StarAndCommentModel

- (instancetype)initWithContentDic:(NSDictionary *)dic {
    self = [super initWithContentDic:dic];
    if (self) {
        self.userId = [dic objectForKey:@"uid"];
        self.nickName = [dic objectForKey:@"nickname"];
        self.imageUrl = [dic objectForKey:@"path"];
        self.comment = [NSString stringWithFormat:@" : %@", [dic objectForKey:@"content"]];
    }
    return self;
}

@end
