// 
//  HotKeyword.m
//  groupbuy
//
//  Created by LouisLee on 11-8-7.
//  Copyright 2011 ET. All rights reserved.
//

#import "HotKeyword.h"


@implementation HotKeyword 

@dynamic keyword;
@dynamic priority;

-(id)initWithKeyword: (NSString *)keywordVal AndPriority:(NSNumber*)priorityVal
{
	self = [super init];
    if(self) {
		self.keyword = keywordVal;
		self.priority = priorityVal;
    }
    return self;
}
@end
