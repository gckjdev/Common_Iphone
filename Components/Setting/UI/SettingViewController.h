//
//  SettingViewController.h
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-3.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingDefinition.h"
#import "PPTableViewController.h"

@interface SettingViewController : PPTableViewController {

	NSArray*	allGroups;		
	SettingDefinition* currentSettingDefinition;
}

@property (nonatomic, retain) NSArray*	allGroups;
@property (nonatomic, retain) SettingDefinition* currentSettingDefinition;
@end
