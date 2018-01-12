//
//  ImageView.m
//  HePingNet
//
//  Created by 你个LB on 2016/11/29.
//  Copyright © 2016年 NGeLB. All rights reserved.
//

#import "ShowImagesView.h"
#import "UIButton+WebCache.h"
@implementation ShowImagesView


/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)setThumbImageUrlArray:(NSArray *)thumbImageUrlArray {
    if (_thumbImageUrlArray != thumbImageUrlArray) {
        _thumbImageUrlArray = thumbImageUrlArray;
        
        NSArray * imageBtns = self.subviews;
        
        // 判断是否需要新创建按钮
        if (imageBtns.count < thumbImageUrlArray.count) {
            // 之前复用的图片不够，需要新创建
            for (NSInteger i = 0; i < thumbImageUrlArray.count - imageBtns.count; i ++) {
                UIButton * imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                imageBtn.backgroundColor = [UIColor whiteColor];                
                imageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [imageBtn addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:imageBtn];
            }
        } else if (imageBtns.count > thumbImageUrlArray.count) {
            // 复用的图片小于复用的图片，清除不用的图片数据(不是清除掉)
            for (NSInteger i = 0; i < imageBtns.count - thumbImageUrlArray.count; i ++) {
                UIButton * imageBtn = self.subviews[imageBtns.count - 1 - i];
                imageBtn.hidden = YES;
                //                [imageBtn removeFromSuperview];
            }
        }
        // 设置数据
        for (NSInteger i = 0; i < thumbImageUrlArray.count; i ++) {
            // 获取图片地址
            UIButton * imageBtn = self.subviews[i];
            imageBtn.tag = 200 + i;
            imageBtn.hidden = NO;
            NSString * imageUrl = thumbImageUrlArray[i];
            // 设置图片
            
            [imageBtn sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"beijingbuxianshi_"]];
        }
    }
}
- (void)setImageUrlArray:(NSArray *)imageUrlArray {
    if (_imageUrlArray != imageUrlArray) {
        _imageUrlArray = imageUrlArray;
        
            }
}

- (void)setImageFArray:(NSMutableArray *)imageFArray {
    if (_imageFArray != imageFArray) {
        _imageFArray = imageFArray;
        
        for (NSInteger i = 0; i < imageFArray.count; i ++) {
            // 获取点赞昵称
            NSValue * imageRectValue = imageFArray[i];
            CGRect imageRect = [imageRectValue CGRectValue];
            UIButton * imageBtn = self.subviews[i];
            
            // 设置标题
            imageBtn.frame = imageRect;
        }
    }
}

- (void)imageBtnAction:(UIButton *)button {
    NSInteger index = button.tag - 200;
    if ([self.delegate respondsToSelector:@selector(showImagesView:DidSelectedImageIndex:imageUrlArray:)]) {
        [self.delegate showImagesView:self DidSelectedImageIndex:index imageUrlArray:self.imageUrlArray];
    }
}
@end
