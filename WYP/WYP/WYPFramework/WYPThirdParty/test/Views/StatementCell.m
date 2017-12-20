//
//  StatementCell.m
//  HePingNet
//
//  Created by 你个LB on 2016/11/29.
//  Copyright © 2016年 NGeLB. All rights reserved.
//

// 控件之间的间距
#define space 15
// 姓名字体大小
#define nameFont [UIFont systemFontOfSize:13]
// 消息字体大小
#define messageFont [UIFont systemFontOfSize:14]
// 图片之间的间距
#define imageSpace 5
// 图片的宽度
#define imageW (kScreen_width - 2 * space - 2 * imageSpace) / 3

#define kScreen_width UIScreen.mainScreen.bounds.size.width
#define kScreen_height UIScreen.mainScreen.bounds.size.height

#import "StatementCell.h"

#import "UIImageView+WebCache.h"

@implementation StatementCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"identifier";
    StatementCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[StatementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 头像
        _headImageView = [[UIImageView alloc] init];
        _headImageView.backgroundColor = [UIColor whiteColor];
        _headImageView.layer.cornerRadius = 20;
        _headImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_headImageView];
        // 姓名
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        _nameLabel.font = nameFont;
        [self.contentView addSubview:_nameLabel];
        // 时间
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor whiteColor];
        _timeLabel.textColor = [[UIColor alloc] initWithRed:135/255.0 green:137/255.0 blue:143/255.0 alpha:1];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_timeLabel];
        // 消息
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.backgroundColor = [UIColor whiteColor];
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = messageFont;
        [self.contentView addSubview:_messageLabel];
        // 所有图片视图
        _imageArrayView = [[ShowImagesView alloc] init];
        _imageArrayView.delegate = self;
        _imageArrayView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_imageArrayView];
        
        // 删除按钮
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setImage:[UIImage imageNamed:@"info_delete_button_normal_iPhone"] forState:UIControlStateNormal];
        _deleteButton.tag = 300 + 53;
        [_deleteButton addTarget:self action:@selector(moreSubBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteButton];
        
        // 分享按钮
        _shareButton = [[UIButton alloc] init];
        [_shareButton setImage:[UIImage imageNamed:@"community_grayShare_button_normal_iPhone"] forState: UIControlStateNormal];
        _shareButton.tag = 300 + 52;
        [_shareButton addTarget:self action:@selector(moreSubBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_shareButton];
    
        // 评论按钮
        _leaveMessageButton = [[UIButton alloc] init];
        [_leaveMessageButton setImage:[UIImage imageNamed:@"community_comment_button_normal_iPhone"] forState:UIControlStateNormal];
        _leaveMessageButton.tag = 300 + 51;
        [_leaveMessageButton addTarget:self action:@selector(moreSubBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_leaveMessageButton];
        
        // 点赞按钮
        _starButton = [[UIButton alloc] init];
        [_starButton setImage:[UIImage imageNamed:@"community_grayStar_button_normal_iPhone"] forState:UIControlStateNormal];
        _starButton.tag = 300 + 50;
        [_starButton addTarget:self action:@selector(moreSubBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_starButton];
        
        // kaishigenduo_btn_s
        // 所有点赞视图
        _starArrayView = [[ShowStarView alloc] init];
        _starArrayView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_starArrayView];
        // 所有评论视图
        _commentArrayView = [[ShowCommentView alloc] init];
        _commentArrayView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_commentArrayView];
    }
    return self;
}

/**
 在这个方法中设置子控件的frame和显示数据

 @param statementFrame statementFrame
 */
- (void)setStatementFrame:(StatementFrameModel *)statementFrame {
    _statementFrame = statementFrame;
    
    // 设置数据
    [self settingData];
    
    // 设置frame
    [self settingFrame];
}

/**
 设置数据
 */
- (void)settingData
{
    // 设置数据
    StatementModel * statement = self.statementFrame.statement;
    
    // 用户头像
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:statement.headImgUrl] placeholderImage:[UIImage imageNamed:@"beijingbuxianshi_"]];
    
    // 用户名
    _nameLabel.text = statement.name;
    
    // 时间
    _timeLabel.text = statement.time;
    
    // 留言
    _messageLabel.text = statement.message;
    
    if ([statement.isStar isEqual: @"0"]) {
        // 未点赞
        
    } else {
        // 已点赞
        [_starButton setImage:[UIImage imageNamed:@"community_zan_button_selected_iPhone"] forState:UIControlStateNormal];
    }
    
    // 所有图片设置数据
    _imageArrayView.imageUrlArray = statement.imageUrlArray;
    
    _imageArrayView.thumbImageUrlArray = statement.thumbImageUrlArray;
    // 所有点赞设置数据
    _starArrayView.starArray = statement.starArray;
    
    // 所有评论设置数据
    _commentArrayView.commentArray = statement.commentArray;
}

/**
 *  设置frame
 */
- (void)settingFrame {
    // 头像的Frame
    _headImageView.frame = self.statementFrame.headImageF;
    
    _nameLabel.frame = self.statementFrame.nameF;
    
    _timeLabel.frame = self.statementFrame.timeF;
    
    _messageLabel.frame = self.statementFrame.messageF;
    
    if (self.statementFrame.messageHeight > 100 && (_messageLabel.frame.size.height != self.statementFrame.messageHeight)) {
        
        CGFloat moreBtnX = CGRectGetMaxX(_messageLabel.frame) - 40;
        CGFloat moreBtnY = CGRectGetMaxY(_messageLabel.frame);
        CGFloat moreBtnW = 40;
        CGFloat moreBtnH = 20;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(moreBtnX, moreBtnY, moreBtnW, moreBtnH);
        [button setTitle:@"更多" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:button];
    }
    
    _deleteButton.frame = CGRectMake(self.statementFrame.shareF.origin.x, self.statementFrame.nameF.origin.y, self.statementFrame.shareF.size.width, self.statementFrame.shareF.size.height);
    
    _imageArrayView.frame = self.statementFrame.imageArrayF;
    
    _shareButton.frame = self.statementFrame.shareF;
    
    _leaveMessageButton.frame = CGRectMake(_shareButton.frame.origin.x - 40, self.statementFrame.shareF.origin.y, self.statementFrame.shareF.size.width, self.statementFrame.shareF.size.height);
    
    _starButton.frame = CGRectMake(_leaveMessageButton.frame.origin.x - 40, self.statementFrame.shareF.origin.y, self.statementFrame.shareF.size.width, self.statementFrame.shareF.size.height);
    
    _starArrayView.frame = self.statementFrame.starArrayF;
    
    _commentArrayView.frame = self.statementFrame.commentArrayF;
    
    _imageArrayView.imageFArray = self.statementFrame.allImageF;
    
    _starArrayView.starFArray = self.statementFrame.allStarNickNameF;
    
    _commentArrayView.nickNameFArray = self.statementFrame.allCommentNickNameF;
    
    [_commentArrayView setCommentTextFArray:self.statementFrame.allCommentTextF commentHeadIndentFArray:self.statementFrame.allCommentTextHeadIndentF];
}

- (void)moreBtnAction:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(statementCell:moreButtonAction:statement:)]) {
        [self.delegate statementCell:self moreButtonAction:button statement:self.statementFrame.statement];
    }
}

#pragma mark - ShowImagesViewDelegate

- (void)showImagesView:(ShowImagesView *)showImagesView DidSelectedImageIndex:(NSInteger)imageIndex imageUrlArray:(NSArray *)imageUrlArray {
    
    _selectImgBlock(imageIndex, imageUrlArray);
}

/**
 更多按钮展开后的子按钮被点击

 @param button 点击的子按钮
 */
- (void)moreSubBtnAction:(UIButton *)button {

    if (button.tag - 350 == 0) {
        // 点赞
        if ([self.delegate respondsToSelector:@selector(statementCell:starButtonAction:statement:)]) {
            [self.delegate statementCell:self starButtonAction:button statement:self.statementFrame.statement];
        }
        
    } else if (button.tag - 350 == 1) {
        // 留言
        if ([self.delegate respondsToSelector:@selector(statementCell:commentButtonAction:statement:)]) {
            [self.delegate statementCell:self commentButtonAction:button statement:self.statementFrame.statement];
        }
    } else if (button.tag - 350 == 2) {
        // 分享
        if ([self.delegate respondsToSelector:@selector(statementCell:shareButtonAction:statement:)]) {
            [self.delegate statementCell:self shareButtonAction:button statement:self.statementFrame.statement];
        }
    } else if (button.tag - 350 == 3) {
        // 删除
        if ([self.delegate respondsToSelector:@selector(statementCell:deleteButtonAction:statement:)]) {
            [self.delegate statementCell:self deleteButtonAction:button statement:self.statementFrame.statement];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(statementCell:moreButtonAction:statement:)]) {
            [self.delegate statementCell:self moreButtonAction:button statement:self.statementFrame.statement];
        }
    }
}



@end
