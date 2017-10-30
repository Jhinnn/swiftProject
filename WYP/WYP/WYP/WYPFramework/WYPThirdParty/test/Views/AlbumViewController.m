//
//  AlbumViewController.m
//  CXNews
//
//  Created by 朱思明 on 16/1/26.
//  Copyright © 2016年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumCell.h"

#define kScreen_width UIScreen.mainScreen.bounds.size.width
#define kScreen_height UIScreen.mainScreen.bounds.size.height

static NSString *identifierAlbumCellId = @"identifierAlbumCellId";

@interface AlbumViewController ()

@end

@implementation AlbumViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 是否自动为滑动视图添加内填充（）
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 返回你所需要的状态栏样式
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.设置标题
    self.title = [NSString stringWithFormat:@"图片(%ld/%ld)",_selectedIndex + 1,_dataList.count];
    // 3.初始化子视图
    [self _initViews];
    // 4.添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    // 5.设置导航栏为透明的
//    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

// 3.初始化子视图
- (void)_initViews
{
    // 1.创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(kScreen_width + 20, kScreen_height);
    flowLayout.minimumLineSpacing = 0;
    // 2.创建视图
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, -44, kScreen_width + 20, kScreen_height) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    // 设置翻页效果
    _collectionView.pagingEnabled = YES;
    // 注册单元格类
    [_collectionView registerClass:[AlbumCell class] forCellWithReuseIdentifier:identifierAlbumCellId];
    [self.view addSubview:_collectionView];
    // 3.设置现实的图片
    _collectionView.contentOffset = CGPointMake(self.selectedIndex * (kScreen_width + 20), 0);  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 注册的形式获取单元格
    AlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierAlbumCellId forIndexPath:indexPath];
    cell.imageName = _dataList[indexPath.item];
    // 手动的调用layoutSubViews
    [cell setNeedsLayout];
    return cell;
}

#pragma mark - 返回按钮事件
- (void)backAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tap
- (void)tapAction:(UITapGestureRecognizer *)tap
{
//    [[UIApplication sharedApplication] setStatusBarHidden:!self.navigationController.navigationBarHidden withAnimation:UIStatusBarAnimationNone];
//    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO) {
        // 计算当前的页数
        int page = (int)scrollView.contentOffset.x / (int)(kScreen_width + 20);
        self.title = [NSString stringWithFormat:@"图片(%d/%d)",page + 1,(int)_dataList.count];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 计算当前的页数
    int page = (int)scrollView.contentOffset.x / (int)(kScreen_width + 20);
    self.title = [NSString stringWithFormat:@"图片(%d/%d)",page + 1,(int)_dataList.count];
}

@end
