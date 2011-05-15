//
//  UITableViewUtil.h
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-10.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UITableView ( UITableViewUtil ) 

- (UITableViewCell *)getCellByRow:(int)row;
- (UITableViewCell *)getCellBySection:(int)section row:(int)row;

@end
