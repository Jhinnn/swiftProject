//
//  PublicGroupViewController.h
//  HePingNet
//
//  Created by 武思彤 on 2016/12/20.
//  Copyright © 2016年 NGeLB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PublicGroupViewController : UIViewController
{
    UIImagePickerController * _imagePickerController;
}

@property (copy, nonatomic) NSString * uid;

@property (copy, nonatomic) NSString * userToken;

// 判断是否含有表情
- (BOOL)stringContainsEmoji:(NSString *)string;
// 判断是否是九宫格
- (BOOL)isNineKeyBoard:(NSString *)string;
    
@end
