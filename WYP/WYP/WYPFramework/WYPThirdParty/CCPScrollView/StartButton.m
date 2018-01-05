//
//  StartButton.m
//  WYP
//
//  Created by Arthur on 2018/1/4.
//  Copyright © 2018年 NGeLB. All rights reserved.
//

#import "StartButton.h"



@implementation StartButton


- (CGRect)imageRectForContentRect:(CGRect)contentRect{

    return CGRectMake(0, 10, contentRect.size.width / 3 - 5, contentRect.size.width / 3 - 5);
}
#pragma mark - 调整内部UIlable的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(contentRect.size.width / 3, 6, contentRect.size.width / 3 * 2, contentRect.size.height - 10);
}





@end
