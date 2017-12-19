//
//  AlbumCell.m
//  CXNews
//
//  Created by 朱思明 on 16/1/26.
//  Copyright © 2016年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import "AlbumCell.h"
#import "UIImageView+WebCache.h"

#define kScreen_width UIScreen.mainScreen.bounds.size.width
#define kScreen_height UIScreen.mainScreen.bounds.size.height

@implementation AlbumCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 1.设置背景颜色
        self.backgroundColor = [UIColor blackColor];
        // 2.创建滑动视图
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, kScreen_width, kScreen_height)];
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.delegate = self;
        [self.contentView addSubview:_scrollView];
        // 3.创建图片视图
        _imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_imageView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 恢复原始比例
    _scrollView.zoomScale = 1.0;
    // 设置图片
    [_imageView sd_setImageWithURL:[NSURL URLWithString:self.imageName]];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
@end
