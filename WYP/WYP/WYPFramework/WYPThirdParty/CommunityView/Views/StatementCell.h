//
//  StatementCell.h
//  HePingNet
//
//  Created by 你个LB on 2016/11/29.
//  Copyright © 2016年 NGeLB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatementFrameModel.h"
#import "StatementModel.h"
#import "ShowImagesView.h"
#import "ShowStarView.h"
#import "ShowCommentView.h"
#import "StartButton.h"
@class StatementCell;

@protocol StatementCellDelegate <NSObject>

// 分享按钮点击事件
- (void)statementCell:(StatementCell *)statementCell shareButtonAction:(UIButton *)button statement:(StatementModel *)statement;
// 删除按钮点击事件
- (void)statementCell:(StatementCell *)statementCell deleteButtonAction:(UIButton *)button statement:(StatementModel *)statement;
// 评论按钮点击事件
- (void)statementCell:(StatementCell *)statementCell commentButtonAction:(UIButton *)button statement:(StatementModel *)statement;
// 点赞按钮点击事件
- (void)statementCell:(StatementCell *)statementCell starButtonAction:(UIButton *)button statement:(StatementModel *)statement;

// 更多按钮点击事件
- (void)statementCell:(StatementCell *)statementCell moreButtonAction:(UIButton *)button statement:(StatementModel *)statement;

@end

typedef void(^selectImg) (NSInteger index, NSArray * imageUrlArray);

@interface StatementCell : UITableViewCell <ShowImagesViewDelegate>
{
    // 头像
    UIImageView * _headImageView;
    // 姓名
    UILabel * _nameLabel;
    // 时间
    UILabel * _timeLabel;
    // 消息
    UILabel * _messageLabel;
    // 图片数组
    ShowImagesView * _imageArrayView;
    
    // 删除按钮
    UIImageView *_zanImageView;
    
    // 点赞数组
    ShowStarView * _starArrayView;
    // 评论数组
    ShowCommentView * _commentArrayView;
}

/** 初始化方法 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong, nonatomic) UIButton *deleteButton;

@property (strong, nonatomic) UILabel *messageLabel;

@property (strong, nonatomic) StartButton *shareButton;;

@property (strong, nonatomic) StartButton *leaveMessageButton;

@property (strong, nonatomic) StartButton *starButton;


@property (strong, nonatomic) StatementFrameModel * statementFrame;

@property (copy, nonatomic) selectImg selectImgBlock;

@property (weak, nonatomic) id<StatementCellDelegate> delegate;

@end
