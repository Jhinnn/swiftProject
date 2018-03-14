//
//  StatementCell.m
//  HePingNet
//
//  Created by 你个LB on 2016/11/29.
//  Copyright © 2016年 NGeLB. All rights reserved.
//
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
        _headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
        [_headImageView addGestureRecognizer:tap];
        [self.contentView addSubview:_headImageView];
        // 姓名
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        _nameLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1];
        _nameLabel.font = nameFont;
        
        [self.contentView addSubview:_nameLabel];
        // 时间
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor whiteColor];
        _timeLabel.textColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_timeLabel];
        // 消息
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.backgroundColor = [UIColor whiteColor];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
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
        
        _deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_deleteButton addTarget:self action:@selector(moreSubBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteButton];
        
        // 分享按钮
        _shareButton = [[StartButton alloc] init];
        [_shareButton setImage:[UIImage imageNamed:@"sq_icon_fx_normal"] forState: UIControlStateNormal];
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_shareButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
        _shareButton.tag = 300 + 52;
        [_shareButton addTarget:self action:@selector(moreSubBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_shareButton];
    
        // 评论按钮
        _leaveMessageButton = [[StartButton alloc] init];
        [_leaveMessageButton setImage:[UIImage imageNamed:@"sq_icon_edit_normal"] forState:UIControlStateNormal];
        [_leaveMessageButton setTitle:@"评论" forState:UIControlStateNormal];
        _leaveMessageButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_leaveMessageButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
        _leaveMessageButton.tag = 300 + 51;
        [_leaveMessageButton addTarget:self action:@selector(moreSubBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_leaveMessageButton];
        
        // 点赞按钮
        _starButton = [[StartButton alloc] init];
        [_starButton setImage:[UIImage imageNamed:@"sq_icon_dz_normal"] forState:UIControlStateNormal];
        [_starButton setTitle:@"点赞" forState:UIControlStateNormal];
        _starButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_starButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
        _starButton.tag = 300 + 50;
        [_starButton addTarget:self action:@selector(moreSubBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_starButton];
        
      
        
        // 所有点赞视图
        _starArrayView = [[ShowStarView alloc] init];
        _starArrayView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        _starArrayView.layer.masksToBounds = YES;
        _starArrayView.layer.cornerRadius = 6;
        [self.contentView addSubview:_starArrayView];
        
        //点赞视图图标
        _zanImageView = [[UIImageView alloc] init];
        _zanImageView.image = [UIImage imageNamed:@"sq_icon_dzt_select"];
        [self.contentView addSubview:_zanImageView];
        
        
        // 所有评论视图
        _commentArrayView = [[ShowCommentView alloc] init];
        _commentArrayView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        _commentArrayView.layer.masksToBounds = YES;
        _commentArrayView.layer.cornerRadius = 6;
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
        [_starButton setImage:[UIImage imageNamed:@"sq_icon_dz_select"] forState:UIControlStateNormal];
    }
    
    
    [_starButton setTitle:[NSString stringWithFormat:@"%@",statement.fabulous_count] forState:UIControlStateNormal];
    [_leaveMessageButton setTitle:[NSString stringWithFormat:@"%@",statement.comment_count] forState:UIControlStateNormal];
    [_shareButton setTitle:[NSString stringWithFormat:@"%@",statement.share] forState:UIControlStateNormal];
    
    
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
        
        CGFloat moreBtnX = CGRectGetMinX(_messageLabel.frame);
        CGFloat moreBtnY = CGRectGetMaxY(_messageLabel.frame);
        CGFloat moreBtnW = 40;
        CGFloat moreBtnH = 20;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(moreBtnX, moreBtnY, moreBtnW, moreBtnH);
        [button setTitle:@"全文" forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithHue:134/255.0 saturation:176/255.0 brightness:143/255.0 alpha:1] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:button];
    }
    
    _deleteButton.frame = CGRectMake(kScreen_width - self.statementFrame.shareF.size.width - space - 5, self.statementFrame.nameF.origin.y, self.statementFrame.shareF.size.width, self.statementFrame.shareF.size.height);
    
    
    _imageArrayView.frame = self.statementFrame.imageArrayF;
    
    
    CGFloat Dis = (kScreen_width - 180 - 70 - space ) / 2 + 60;
    
    //点赞
    _starButton.frame = self.statementFrame.shareF;
    
    //评论
    _leaveMessageButton.frame = CGRectMake(self.statementFrame.shareF.origin.x + Dis, self.statementFrame.shareF.origin.y, self.statementFrame.shareF.size.width,  self.statementFrame.shareF.size.height);
    
    //分享
    _shareButton.frame = CGRectMake(_leaveMessageButton.frame.origin.x + Dis, self.statementFrame.shareF.origin.y, self.statementFrame.shareF.size.width, self.statementFrame.shareF.size.height);
    
    
    _starArrayView.frame = self.statementFrame.starArrayF;
    
    _zanImageView.frame = self.statementFrame.zanArrayF;
    
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

- (void)imageClick {
    if ([self.delegate respondsToSelector:@selector(statementCell:statement:)]) {
        [self.delegate statementCell:self statement:self.statementFrame.statement];
    }
}



@end
