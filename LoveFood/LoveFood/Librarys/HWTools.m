//
//  HWTools.m
//  LoveFood
//
//  Created by SCJY on 16/1/22.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "HWTools.h"

@implementation HWTools
#pragma mark---计算高度

+ (CGFloat)getTextHeightWithText:(NSString *)text bigestSize:(CGSize)bigSize font:(CGFloat)font{
    CGRect textRect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil];
    return textRect.size.height;
}

@end
