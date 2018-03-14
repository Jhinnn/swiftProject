//
//  StatementModel.m
//  HePingNet
//
//  Created by 你个LB on 2016/11/29.
//  Copyright © 2016年 NGeLB. All rights reserved.
//

#import "StatementModel.h"

@implementation StatementModel

- (instancetype)initWithContentDic:(NSDictionary *)dic {
    self = [super initWithContentDic:dic];
    if (self) {
        NSLog(@"%@", [dic objectForKey:@"create_time"]);
        self.userId = [dic objectForKey:@"uid"];
        self.headImgUrl = [dic objectForKey:@"path"];
        self._id = [dic objectForKey:@"id"];
        self.name = [dic objectForKey:@"nickname"];
        self.time = [self timeWithTimeIntervalString:[dic objectForKey:@"create_time"]];
                     // @"MM-dd HH:mm"
        self.message = [dic objectForKey:@"content"];
        self.thumbImageUrlArray = [dic objectForKey:@"dynamic_path"];
        self.imageUrlArray = [dic objectForKey:@"dynamic_path"];
        
        self.comment_count = [dic objectForKey:@"comment_count"];
        self.fabulous_count = [dic objectForKey:@"fabulous_count"];
        self.share = [dic objectForKey:@"share"];
        
        NSArray * starArray = [dic objectForKey:@"fabulous"];
        NSMutableArray * starModels = [NSMutableArray array];
        for (NSDictionary * starDic in starArray) {
            StarAndCommentModel * star = [[StarAndCommentModel alloc] initWithContentDic:starDic];
            [starModels addObject:star];
        }
        self.starArray = starModels;
        
        NSArray * commentArray = [dic objectForKey:@"comment"];
        NSMutableArray * commentModels = [NSMutableArray array];
        for (NSDictionary * commentDic in commentArray) {
            StarAndCommentModel * comment = [[StarAndCommentModel alloc] initWithContentDic:commentDic];
            [commentModels addObject:comment];
        }
        self.commentArray = commentModels;
        self.isStar = [dic objectForKey:@"is_fabulous"];
    }
    return self;
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
@end
