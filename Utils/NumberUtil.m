//
//  NumberUtil.m
//  groupbuy
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NumberUtil.h"

BOOL isInteger(CGFloat number)
{
    NSInteger integer = number;
    if (number - integer == 0.0) {
        return YES;
    }
    return NO;
}


NSInteger getDecimal(CGFloat number)
{
    NSString *str = [NSString stringWithFormat:@"%0.2f",number];
    NSRange range = [str rangeOfString:@"."];
    NSInteger start = range.location + 1;
    int i = [str length] - 1;
    for (; i >= start; --i) {
        if ([str characterAtIndex:i] != '0') {
            break;
        }
    }
    int sum = 0;
    for (int j = start; j <= i; j++) {
        sum *= 10;
        sum += [str characterAtIndex:j] - '0';
    }
    return sum;
}
