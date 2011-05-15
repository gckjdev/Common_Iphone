//
//  ActionSelector.m
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-9.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import "ActionSelector.h"


@implementation ActionSelector

@synthesize target;
@synthesize type;
@synthesize selector;

+ (id)actionWithMethod:(int)aType target:(NSObject *)aTarget selector:(SEL)aSelector
{
	self = [[[ActionSelector alloc] initWithMethod:aType target:aTarget selector:aSelector] autorelease];
	return self;
}

- (id)initWithMethodName:(int)aType target:(NSObject *)t method:(NSString *)method
{
	if (self = [super init]){	
		[self setActionSelector:method];
		self.target = t;
		type = aType;
	}
	return self;
}

- (id)initWithMethod:(int)aType target:(NSObject *)t selector:(SEL)aSelector
{
	if (self = [super init]){	
		selector = aSelector;
		self.target = t;
		type = aType;
	}
	return self;
}

- (void)setActionSelector:(NSString *)method
{
	selector = NSSelectorFromString(method);
	if (selector == NULL){
		NSLog(@"[ERROR] set action selector but cannot find the method name!");
	}
}

- (void)perform:(id)sender
{
	[target performSelector:selector withObject:sender];	
}

@end
