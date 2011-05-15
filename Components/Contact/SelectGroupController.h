//
//  SelectGroupController.h
//  FreeSMS
//
//  Created by qqn_pipi on 11-2-13.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"

@protocol SelectGroupControllerDelegate <NSObject>

- (void)groupSelect:(int)groupId;

@end


@interface SelectGroupController : PPTableViewController {
	id<SelectGroupControllerDelegate> delegate;
}

- (id)initWithDelegate:(id<SelectGroupControllerDelegate>)delegateValue;

@end
