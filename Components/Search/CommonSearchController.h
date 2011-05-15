//
//  CommonSearchController.h
//  FreeSMS
//
//  Created by qqn_pipi on 11-2-12.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"

@interface CommonSearchController : PPViewController {

	id<UISearchBarDelegate>	delegate;
}

- (id)initWithSearchDelegate:(id<UISearchBarDelegate>)delegate;

@end
