//
//  StatementFrameModel.m
//  HePingNet
//
//  Created by 你个LB on 2016/11/29.
//  Copyright © 2016年 NGeLB. All rights reserved.
//

// 控件之间的间距
#define space 15
// 姓名字体大小
#define nameFont [UIFont systemFontOfSize:15]
// 消息字体大小
#define messageFont [UIFont systemFontOfSize:14]
#import "StatementFrameModel.h"

#define kScreen_width UIScreen.mainScreen.bounds.size.width
#define kScreen_height UIScreen.mainScreen.bounds.size.height

@implementation StatementFrameModel

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

- (void)setStatement:(StatementModel *)statement {
    _statement = statement;
    
    // 头像
    _headImageF = CGRectMake(space, space, 40, 40);
    
    // 昵称
    CGSize nameSize = [self sizeWithText:statement.name font:nameFont maxSize:CGSizeMake(200, 20)];
    _nameF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMinY(_headImageF) + 4, nameSize.width, nameSize.height);
    
    // 时间
    _timeF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_headImageF) - 10, 80, 10);
    
    // 消息
    CGSize messageSize = [self sizeWithText:statement.message font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(kScreen_width - 2 * space - 40, 1000)];
    _messageHeight = messageSize.height;
    if (messageSize.height > 100) {
        // 判断是否展开
        if (_isShowAllMessage) {
            _messageF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_headImageF) + space, kScreen_width- (CGRectGetMaxX(_headImageF) + 2 *space), messageSize.height);
        } else {
            _messageF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_headImageF) + space, kScreen_width- (CGRectGetMaxX(_headImageF) + 2 *space), 100);
        }
    } else {
        _messageF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_headImageF) + space, kScreen_width- (CGRectGetMaxX(_headImageF) + 2 *space), messageSize.height);
    }
    
    
    
    
    // 所有图片
    NSInteger imageCount = statement.imageUrlArray.count;
    _allImageF = [NSMutableArray array];
    CGRect lastImageRect = CGRectZero;
    NSInteger imageRow = 0;
    CGFloat imageSpace = 5;
    CGFloat imageX = 0.0;
    CGFloat imageY = 0.0;
    CGFloat imageW = (kScreen_width - 2 * space - 2 * imageSpace - CGRectGetMaxX(_headImageF)) / 3;
    CGFloat imageH = imageW;
    
    for (NSInteger i = 0; i < imageCount; i ++) {
        if (imageCount == 0) {
            // 没有图片
            imageX = 0;
            imageY = 0;
            imageW = 0;
            imageH = 0;
            if (messageSize.height > 100) {
                _imageArrayF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_messageF) + space + 30, imageW, imageH);
            } else {
                _imageArrayF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_messageF) + space, imageW, imageH);
            }
        } else if (imageCount == 1) {
            // 一张图片
            imageX = 0;
            imageY = 0;
            imageW = imageW;
            imageH = imageH;
            if (messageSize.height > 100) {
                _imageArrayF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_messageF) + space + 30, imageW, imageH);
            } else {
                _imageArrayF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_messageF) + space, imageW, imageH);
            }
//        } else if (imageCount < 5) {
//            // 大于一张，小于5张
//            imageX = CGRectGetMaxX(lastImageRect) + imageSpace;
//            // 判断是否是第一张图片
//            if (imageX == imageSpace) {
//                imageX = 0;
//            }
//            // 判断是否换行
//            if ((imageW + imageX) > (kScreen_width - imageW - 2 * space)) {
//                imageX = 0;
//                imageRow = imageRow + 1;
//            }
//            imageY = imageRow * (imageH + imageSpace);
//            _imageArrayF = CGRectMake(space, CGRectGetMaxY(_messageF) + space, 2 * imageW + imageSpace, imageY + imageH);
        } else {
            // 大于四张
            imageX = CGRectGetMaxX(lastImageRect) + imageSpace;
            // 判断是否是第一张图片
            if (imageX == imageSpace) {
                imageX = 0;
            }
            // 判断是否换行
            if ((imageW + imageX) > (kScreen_width - space)) {
                imageX = 0;
                imageRow = imageRow + 1;
            }
            imageY = imageRow * (imageH + imageSpace);

            if (messageSize.height > 100) {
            _imageArrayF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_messageF) + space + 30, kScreen_width - 2 * space, imageY + imageH);
            } else {
            _imageArrayF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_messageF) + space, kScreen_width - 2 * space, imageY + imageH);
            }
        }
        // 将上面计算好的X、Y、W、H设置到frame上
        CGRect imageRect = CGRectMake(imageX, imageY, imageW, imageH);
        // 基本数据类型转换为对象
        NSValue * imageRectValue = [NSValue valueWithCGRect:imageRect];
        [_allImageF addObject:imageRectValue];
        // 保存上次的frame
        lastImageRect = imageRect;
    }
    
    //分享按钮
    if (imageCount == 0) {
        // 没有图片
        _shareF = CGRectMake(space * 2 + 40, CGRectGetMaxY(_messageF) + space, 60, 35);
    } else {
        // 有图片
        _shareF = CGRectMake(space * 2 + 40, CGRectGetMaxY(_imageArrayF) + space, 60, 35);
    }
    
    // 点赞
    _allStarNickNameF = [NSMutableArray array];
    CGRect lastStarRect = CGRectZero;
    NSInteger starRow = 0;
    CGFloat starX = 0.0;
    CGFloat starY = 0.0;
    CGFloat starH = 0.0;
    CGFloat starW = 0.0;
    
    if (statement.starArray.count == 0) {
        _starArrayF = CGRectZero;
        
        _zanArrayF = CGRectZero;
    }else {
        NSInteger i = 0;
        for (StarAndCommentModel * star in statement.starArray) {
            // 计算昵称尺寸
            CGSize starSize = [self sizeWithText:[NSString stringWithFormat:@"%@、", star.nickName] font:nameFont maxSize:CGSizeMake(kScreen_width - 3 * space - 100, 30)];
            starW = starSize.width;
            starH = starSize.height;
            // 获取上一个点赞昵称的位置
            if (i == 0) {
                starX = CGRectGetMaxX(lastStarRect) + 40;
            }else {
                starX = CGRectGetMaxX(lastStarRect);
            }
            i++;
            
            // 如果当前行放不下当前的昵称，换到下一行
            if ((starW + starX) > (kScreen_width - 2 * space)) {
                starX = 40;
                starRow = starRow + 1;

            }
            starY = starRow * starH + 4;
            // 将上面计算好的X、Y、W、H设置到frame上
            CGRect starRect = CGRectMake(starX, starY, starW, starH);
            // 基本数据类型转换为对象
            NSValue * starRectValue = [NSValue valueWithCGRect:starRect];
            [_allStarNickNameF addObject:starRectValue];
            // 保存上次的frame
            lastStarRect = starRect;
        }
        
        
        _starArrayF = CGRectMake(space * 2 + 40, CGRectGetMaxY(_shareF) + space, kScreen_width - 2 * space - 60, starY + starH + 4);
        
        _zanArrayF = CGRectMake(space * 2 + 40 + 8, CGRectGetMaxY(_shareF) + space + 4, 15, 15);
    }
    
    
    
    // 留言
    _allCommentNickNameF = [NSMutableArray array];
    _allCommentTextF = [NSMutableArray array];
    _allCommentTextHeadIndentF = [NSMutableArray array];
    CGRect lastCommentTextRect = CGRectZero;
    CGFloat commentX = 0.0;
    CGFloat commentY = 0.0;
    CGFloat commentW = 0.0;
    CGFloat commentH = 0.0;
    CGFloat nickNameX = 0.0;
    CGFloat nickNameY = 0.0;
    CGFloat nickNameW = 0.0;
    CGFloat nickNameH = 0.0;

    for (StarAndCommentModel * comment in statement.commentArray) {
        CGSize nickNameSize = [self sizeWithText:comment.nickName font:nameFont maxSize:CGSizeMake(kScreen_width - 2 * space, MAXFLOAT)];

        nickNameW = nickNameSize.width;
        nickNameH = nickNameSize.height;
        nickNameX = 0.0 + 6;
        nickNameY = CGRectGetMaxY(lastCommentTextRect) + imageSpace + 1;
        if (nickNameY == imageSpace) {
            nickNameY = 0;
        }
        
        // 将上面计算好的X、Y、W、H设置到frame上（评论昵称）
        CGRect commentNickNameRect = CGRectMake(nickNameX, nickNameY, nickNameW, nickNameH);
        // 基本数据类型转换为对象（评论昵称）
        NSValue * commentNickNameRectValue = [NSValue valueWithCGRect:commentNickNameRect];
        [_allCommentNickNameF addObject:commentNickNameRectValue];

        CGSize commentSize = [self sizeWithText:[NSString stringWithFormat:@"%@:%@",comment.nickName, comment.comment] font:nameFont maxSize:CGSizeMake(kScreen_width - 2 * space, MAXFLOAT)];
        commentW = kScreen_width - 2 * space - 40 - 20;
        commentH = commentSize.height;
        commentX = nickNameX;
        commentY = nickNameY;
        // 将上面计算好的X、Y、W、H设置到frame上（评论内容）
        CGRect commentTextRect = CGRectMake(commentX, commentY, commentW, commentH);
        // 基本数据类型转换为对象（评论内容）
        NSValue * commentTextRectValue = [NSValue valueWithCGRect:commentTextRect];
        [_allCommentTextF addObject:commentTextRectValue];
        // 首行缩进距离（评论内容）
        NSNumber * headIndent = [NSNumber numberWithFloat:nickNameW];
        [_allCommentTextHeadIndentF addObject:headIndent];
        // 保存上次的frame（评论内容）
        lastCommentTextRect = commentTextRect;
    }
    if (statement.starArray.count == 0) { // 没有人点赞
    
        _commentArrayF = CGRectMake(space * 2 + 40, CGRectGetMaxY(_shareF) + space, kScreen_width - 2 * space - 60, commentY + commentH);
    } else {
        // 有人点赞
        _commentArrayF = CGRectMake(space * 2 + 40, CGRectGetMaxY(_starArrayF) + 4, kScreen_width - 2 * space - 60, commentY + commentH);
    }
    
    _cellHeight = CGRectGetMaxY(_commentArrayF) + space;
}
@end
