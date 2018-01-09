//
//  WYPContain.h
//  WYP
//
//  Created by Arthur on 2017/12/19.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

#import <Foundation/Foundation.h>
@import WebKit;
@interface WYPContain : NSObject

+ (BOOL)isNineKeyBoard:(NSString *)string;

+ (BOOL)stringContainsEmoji:(NSString *)string;

+ (NSString*)encodeString:(NSString*)unencodedString;

+ (WKUserScript *)userScript;

@end
