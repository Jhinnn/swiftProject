//
//  StatementFrameModel.m
//  HePingNet
//
//  Created by 你个LB on 2016/11/29.
//  Copyright © 2016年 NGeLB. All rights reserved.
//


#import "StatementFrameModel.h"

#define IntervalW 70

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
    CGSize messageSize = [self sizeWithText:statement.message font:messageFont maxSize:CGSizeMake(kScreen_width - IntervalW - space, 1000)];
    
    if (self.isSeachResult) {  //如果是搜索界面，如果视图高于60则为60  小于60显示计算高度
        
        if (messageSize.height >= 60) {
            _messageF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_headImageF) + 10, kScreen_width- (CGRectGetMaxX(_headImageF) + 2 *space), 60);
        }else {
            _messageF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_headImageF) + 10, kScreen_width- (CGRectGetMaxX(_headImageF) + 2 *space), messageSize.height);
        }
    }else {
        _messageHeight = messageSize.height;
        if (messageSize.height > 100) {
            // 判断是否展开
            if (_isShowAllMessage) {  //文字高度大于100展开情况下
                _messageF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_headImageF) + space, kScreen_width- (CGRectGetMaxX(_headImageF) + 2 *space), messageSize.height);
                
            } else {   // 文字高度大于100未展开情况下
                _messageF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_headImageF) + 5, kScreen_width- (CGRectGetMaxX(_headImageF) + 2 *space), 100);
            }
        } else { //
            _messageF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_headImageF) + space, kScreen_width- (CGRectGetMaxX(_headImageF) + 2 *space), messageSize.height);
        }
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
       if (imageCount == 1) {
            // 一张图片
            imageX = 0;
            imageY = 0;
            imageW = imageW;
            imageH = imageH;
            if (messageSize.height > 100) {
                _imageArrayF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_messageF) + 17, imageW, imageH);
            } else {
                _imageArrayF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_messageF) + space, imageW, imageH);
            }
           // 将上面计算好的X、Y、W、H设置到frame上
           CGRect imageRect = CGRectMake(imageX, imageY, imageW, imageH);
           // 基本数据类型转换为对象
           NSValue * imageRectValue = [NSValue valueWithCGRect:imageRect];
           [_allImageF addObject:imageRectValue];
           // 保存上次的frame
           lastImageRect = imageRect;
        } else {
            
            if (self.isSeachResult) { //搜索界面
                if (i <= 2) {  //只要前3张图片
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
                        _imageArrayF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_messageF) + space, kScreen_width - 2 * space, imageY + imageH);
                    } else {
                        _imageArrayF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_messageF) + space, kScreen_width - 2 * space, imageY + imageH);
                    }
                    
                    // 将上面计算好的X、Y、W、H设置到frame上
                    CGRect imageRect = CGRectMake(imageX, imageY, imageW, imageH);
                    // 基本数据类型转换为对象
                    NSValue * imageRectValue = [NSValue valueWithCGRect:imageRect];
                    [_allImageF addObject:imageRectValue];
                    // 保存上次的frame
                    lastImageRect = imageRect;
                }
            }else {
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
                    _imageArrayF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_messageF) + space + 10, kScreen_width - 2 * space, imageY + imageH);
                } else {
                    _imageArrayF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_messageF) + space, kScreen_width - 2 * space, imageY + imageH);
                }
                
                // 将上面计算好的X、Y、W、H设置到frame上
                CGRect imageRect = CGRectMake(imageX, imageY, imageW, imageH);
                // 基本数据类型转换为对象
                NSValue * imageRectValue = [NSValue valueWithCGRect:imageRect];
                [_allImageF addObject:imageRectValue];
                // 保存上次的frame
                lastImageRect = imageRect;
                
            }
            
            
        }
        
    }
    
    if (self.isSeachResult) {  //如果图片视图高度大于一个图片高度
        
        if (_imageArrayF.size.height >= imageH)  { //大于一排图片高度
            _imageArrayF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_messageF) + 6, kScreen_width - 2 * space, imageH);
        }else {
            _imageArrayF = CGRectMake(CGRectGetMaxX(_headImageF) + space, CGRectGetMaxY(_messageF) + space, kScreen_width - 2 * space, 0);
        }
        
        _cellHeight = CGRectGetMaxY(_imageArrayF) + 4;
        
    }else {
        //分享按钮
        
        if (imageCount == 0) {
            // 没有图片
            _shareF = CGRectMake(IntervalW, CGRectGetMaxY(_messageF) + 10, 60, 35);
            
        } else {
            // 有图片
            _shareF = CGRectMake(IntervalW, CGRectGetMaxY(_imageArrayF) + 5, 60, 35);
        }
        
        // 点赞
        _allStarNickNameF = [NSMutableArray array];
        CGRect lastStarRect = CGRectZero;
        CGFloat starX = 0.0;
        if (statement.starArray.count == 0) {
            _starArrayF = CGRectZero;
            
            _zanArrayF = CGRectZero;
        }else {
          
            for (int i = 0; i < statement.starArray.count; i++) {
                //取前三个
                CGRect starRect = CGRectMake(16 + i * 20, 8, 24, 24);
                starX = CGRectGetMaxX(lastStarRect) + 24;
                NSValue * starRectValue = [NSValue valueWithCGRect:starRect];
                [_allStarNickNameF addObject:starRectValue];

            }
            
            _starArrayF = CGRectMake(space * 2 + 40, CGRectGetMaxY(_shareF) + 10, kScreen_width - space * 3 - 40, 40);
            
            _zanArrayF = CGRectMake(space * 2 + 40 + 8, CGRectGetMaxY(_shareF) + 16, 15, 15);
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
            
            CGSize nickNameSize = [self sizeWithText:comment.nickName font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(kScreen_width - 2 * space, MAXFLOAT)];
            
            nickNameW = nickNameSize.width;
            nickNameH = nickNameSize.height;
            nickNameX = 0.0 + 4;
            nickNameY = CGRectGetMaxY(lastCommentTextRect) + imageSpace + 1;
            if (nickNameY == imageSpace) {
                nickNameY = 0;
            }
            
            // 将上面计算好的X、Y、W、H设置到frame上（评论昵称）
            CGRect commentNickNameRect = CGRectMake(nickNameX, nickNameY, nickNameW, nickNameH);
            // 基本数据类型转换为对象（评论昵称）
            NSValue * commentNickNameRectValue = [NSValue valueWithCGRect:commentNickNameRect];
            [_allCommentNickNameF addObject:commentNickNameRectValue];
            
            CGSize commentSize = [self sizeWithText:[NSString stringWithFormat:@"%@:%@",comment.nickName, comment.comment] font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(kScreen_width - 2 * space, MAXFLOAT)];
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
        
        CGFloat kH = 4;
        if (statement.commentArray.count == 0) {
            kH = 0;
        }
        
        if (statement.starArray.count == 0) { // 没有人点赞
            _commentArrayF = CGRectMake(space * 2 + 40, CGRectGetMaxY(_shareF) + space, kScreen_width - 3 * space - 40, commentY + commentH + kH);
        } else {
            // 有人点赞
            _commentArrayF = CGRectMake(space * 2 + 40, CGRectGetMaxY(_starArrayF) + 4, kScreen_width - 3 * space - 40, commentY + commentH + kH);
        }
        
        
        
        
        _cellHeight = CGRectGetMaxY(_commentArrayF) + 5;
    }
    
    
    
    
   
}
@end
