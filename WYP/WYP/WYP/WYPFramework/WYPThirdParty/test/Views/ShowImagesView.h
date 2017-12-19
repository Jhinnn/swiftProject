//
//  ImageView.h
//  HePingNet
//
//  Created by 你个LB on 2016/11/29.
//  Copyright © 2016年 NGeLB. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShowImagesView;

@protocol ShowImagesViewDelegate <NSObject>

- (void)showImagesView:(ShowImagesView *)showImagesView DidSelectedImageIndex:(NSInteger)imageIndex imageUrlArray:(NSArray *)imageUrlArray;

@end

@interface ShowImagesView : UIView


/**
 图片地址数组
 */
@property (strong, nonatomic) NSArray * imageUrlArray;

/**
 缩略图数组
 */
@property (strong, nonatomic) NSArray * thumbImageUrlArray;

/**
 图片frame数组
 */
@property (strong, nonatomic) NSMutableArray * imageFArray;

/**
 代理对象
 */
@property (weak, nonatomic) id <ShowImagesViewDelegate> delegate;
@end
