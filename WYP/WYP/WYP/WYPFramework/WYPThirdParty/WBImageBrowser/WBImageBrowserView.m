//
//  WBImageBrowserView.m
//  WBImageBrowser
//
//  Created by 李伟宾 on 16/7/29.
//  Copyright © 2016年 李伟宾. All rights reserved.
//

#import "WBImageBrowserView.h"
#import "WBImageBrowserCell.h"
#import "UIImageView+WebCache.h"

#define HeightForTopView 45
static  NSString *cellID = @"cellID";

@interface WBImageBrowserView () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView  *collectionView;

@property (nonatomic, strong) NSArray           *browserArray;      // 数据源

@property (nonatomic, strong) UIScrollView      *currentScrollView; // 当前scrollview
@property (nonatomic, strong) UIImage           *currentImage;      // 当前图片
@property (nonatomic, assign) NSInteger         currentIndex;       // 当前选中的index

@property (nonatomic, strong) UIView    *topBgView;          // 顶部背景视图
@property (nonatomic, strong) UIButton  *backButton;         // 返回


@end

@implementation WBImageBrowserView



#pragma mark - Instant Methods

+ (instancetype)pictureBrowsweViewWithFrame:(CGRect)frame delegate:(id<WBImageBrowserViewDelegate>)delegate browserInfoArray:(NSArray *)browserInfoArray {
    WBImageBrowserView *pictureBrowserView = [[self alloc] initWithFrame:frame];
    pictureBrowserView.delegate = delegate;
    pictureBrowserView.browserArray = browserInfoArray;
    
    return pictureBrowserView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.collectionView];
        
        [self addSubview:self.topBgView];
        [self.topBgView addSubview:self.backButton];
        [self.topBgView addSubview:self.shareButton];
    }
    return self;
}
- (void)showInView:(UIView *)view {
    [view addSubview:self];
    
    self.alpha = 0.0;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1.0;
    }];

}


#pragma mark - 横竖屏时重设frame

- (void)setOrientation:(UIDeviceOrientation)orientation {
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.topBgView.frame = CGRectMake(0, 20, SCREEN_WIDTH, HeightForTopView);
    self.backButton.frame = CGRectMake(10, 0, HeightForTopView, HeightForTopView);
    self.shareButton.frame = CGRectMake(SCREEN_WIDTH - 50, 5, HeightForTopView, HeightForTopView);
    
    self.collectionView.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    [self.collectionView setContentOffset:CGPointMake(self.currentIndex * SCREEN_WIDTH, 0)];
}

// 横竖屏时需重新设置尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}

#pragma mark - UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.browserArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WBImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    cell.bgScrollView.delegate = self;
    cell.bgScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    cell.bgImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [cell.bgImageView sd_setImageWithURL:self.browserArray[indexPath.item] placeholderImage: [UIImage imageNamed:@"loading..."]];

    // 添加手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [cell.bgScrollView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [cell.bgScrollView addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    WBImageBrowserCell *cell1 = (WBImageBrowserCell *)cell;
    cell1.bgScrollView.zoomScale = 1;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentScrollView.zoomScale = 1;
    // 当前显示页数
    int itemIndex = (scrollView.contentOffset.x + self.collectionView.frame.size.width * 0.5) / self.collectionView.frame.size.width;
    [self.delegate getContentWithItem:itemIndex];
    self.currentIndex = itemIndex;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return scrollView.subviews[0];
}

#pragma mark - 图片缩放相关方法
// 单击手势
- (void)singleTapAction:(UITapGestureRecognizer *)tap {
    [_viewController dismissViewControllerAnimated:NO completion:^{
        [self removeFromSuperview];
        [_viewController.view removeFromSuperview];
    }];
}

// 双击手势
- (void)doubleTapAction:(UITapGestureRecognizer *)tap {
    
    self.currentScrollView = (UIScrollView *)tap.view;
    CGFloat scale = self.currentScrollView.zoomScale == 1 ? 3 : 1;
    CGRect zoomRect = [self zoomRectForScale:scale withCenter:[tap locationInView:tap.view]];
    [self.currentScrollView zoomToRect:zoomRect animated:YES];
}

// 双击时的中心点
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = self.currentScrollView.frame.size.height / scale;
    zoomRect.size.width  = self.currentScrollView.frame.size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

#pragma mark - Setter

- (void)setbrowserArray:(NSArray *)browserArray {
    _browserArray = browserArray;
}

- (void)setStartIndex:(NSInteger)startIndex {
    _currentIndex = startIndex - 1;
    [self.collectionView setContentOffset:CGPointMake((startIndex - 1) * SCREEN_WIDTH, 0)];
}

- (UIView *)topBgView {
    if (!_topBgView) {
        _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, HeightForTopView)];
        _topBgView.backgroundColor = [UIColor clearColor];
    }
    return _topBgView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, HeightForTopView, HeightForTopView)];
        [_backButton setImage:[UIImage imageNamed:@"news_photo_button_normal_iPhone"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"news_photo_button_normal_iPhone"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(SCREEN_WIDTH - 50, 0, HeightForTopView, HeightForTopView);
        [_shareButton setImage:[UIImage imageNamed:@"common_share_button_highlight_iPhone"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

#pragma mark - 懒加载

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;   // item横向间距
        layout.minimumLineSpacing      = 0;   // item竖向间距
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[WBImageBrowserCell class] forCellWithReuseIdentifier:cellID];

    }
    return _collectionView;
}

#pragma mark - 按钮事件
- (void)backButtonClick {

    [self.delegate backButtonToClick];
}
- (void)shareButtonButtonClick {
    [self.delegate shareButtonToClick];
}

@end
