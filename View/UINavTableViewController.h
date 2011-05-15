//
//  UINavTableViewController.h
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-9.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UINavTableViewController : UITableViewController {

	// parent nav controller
	UINavigationController* nav;
}

@property (nonatomic, retain) UINavigationController* nav;

- (void)clickCancel:(id)sender;

@end
