//
//  CMNetwork.h
//  CMWeibo
//
//  Created by jiachen on 16/5/23.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AFNetwork : NSObject


/**
 GET数据请求
 
 @param urlString  URL
 @param parameters 参数
 @param success    成功回调
 @param failure    失败回调
 */
+ (void)GET:(NSString *)urlString parameters:(id)parameters success:(void (^)(id  responseObject))success failure:(void (^) (NSError * error))failure;

/**
 POST数据请求
 
 @param urlString  URL
 @param parameters 参数
 @param success    成功回调
 @param failure    失败回调
 */
+ (void)POST:(NSString *)urlString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^) (NSError * error))failure;


/**
 单张或多张图片上传
 
 @param urlString  URL
 @param parameters 参数
 @param imageArray 图片数组（这里是UIImage  可以根据项目自行修改）
 @param successs   成功回调
 @param failure    失败回调
 */
+ (void)uploadPost:(NSString *)urlString parameters:(id)parameters UploadImage:(NSArray *)imageArray success:(void (^)(id responseObject))successs failure:(void (^)(NSError * error))failure;


/**
 实时监测网络变化
 
 @param netStatus 当前网络状态
 */
+ (void)ReachabilityStatus:(void (^)(id netStatus))netStatus;
@end
