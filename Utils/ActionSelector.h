//
//  ActionSelector.h
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-9.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	kActionCreate = 1,
	kActionUpdate,
	kActionCreateAndGotoOverview,
	kActionDelete,
	kActionDone
	
} ActionType;				// some default actions for usage

@interface ActionSelector : NSObject {

	int			type;
	SEL			selector;	
	NSObject*	target;
}

@property (nonatomic, retain) NSObject* target;
@property (nonatomic) SEL selector;
@property (nonatomic) int type;

+ (id)actionWithMethod:(int)type target:(NSObject *)target selector:(SEL)aSelector;

- (id)initWithMethodName:(int)type target:(NSObject *)target method:(NSString *)method;
- (id)initWithMethod:(int)type target:(NSObject *)target selector:(SEL)aSelector;

- (void)setActionSelector:(NSString *)method;
- (void)perform:(id)sender;

@end
