//
//  AlbumCell.h
//  CXNews
//
//  Created by 朱思明 on 16/1/26.
//  Copyright © 2016年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumCell : UICollectionViewCell<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    
}

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, strong) UIImage *image;
@end
