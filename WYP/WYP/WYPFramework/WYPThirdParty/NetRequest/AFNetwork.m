//
//  CMNetwork.m
//  CMWeibo
//
//  Created by jiachen on 16/5/23.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "AFNetwork.h"

@implementation AFNetwork


// GET
+ (void)GET:(NSString *)urlString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^) (NSError * error))failure {
    
    // 初始化管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    manager.requestSerializer.timeoutInterval = 60;
    
    [manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        // 请求进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

// POST
+ (void)POST:(NSString *)urlString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^) (NSError * error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    manager.requestSerializer.timeoutInterval = 60.f;
    
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        // 请求进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success ) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

// 上传
+ (void)uploadPost:(NSString *)urlString parameters:(id)parameters UploadImage:(NSArray *)imageArray success:(void (^)(id responseObject))successs failure:(void (^)(NSError * error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 60.f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UIImage *image in imageArray) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
            NSData *data = UIImageJPEGRepresentation(image, 0.7);
            [formData appendPartWithFileData:data name:@"uploadimage" fileName:fileName mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 请求进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successs) {
            successs(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

// 网络监测
+ (void)ReachabilityStatus:(void (^)(id netStatus))netStatus
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
                
            case AFNetworkReachabilityStatusUnknown:
                
                if (netStatus) {
                    netStatus(@"未知网络类型");
                }
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                
                if (netStatus) {
                    netStatus(@"无可用网络");
                }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                if (netStatus) {
                    netStatus(@"当前WIFE下");
                }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
                if (netStatus) {
                    netStatus(@"使用蜂窝流量");
                }
                break;
                
            default:
                
                break;
                
        }
        
    }];
    [manager startMonitoring];
}
@end
