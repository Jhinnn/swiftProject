//
//  AlbumViewController.h
//  CXNews
//
//  Created by 朱思明 on 16/1/26.
//  Copyright © 2016年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AlbumViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    UICollectionView *_collectionView;
}

@property (nonatomic, strong) NSArray *dataList; // 所有图片地址的数组
@property (nonatomic, assign) NSInteger selectedIndex;  // 进入相册后显示图片的索引位置

@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIButton *saveButton;
@end
