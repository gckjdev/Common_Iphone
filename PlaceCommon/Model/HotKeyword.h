//
//  HotKeyword.h
//  groupbuy
//
//  Created by LouisLee on 11-8-7.
//  Copyright 2011 ET. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface HotKeyword :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * keyword;
@property (nonatomic, retain) NSNumber * priority;

-(id)initWithKeyword: (NSString *)keyword AndPriority:priority;


@end



