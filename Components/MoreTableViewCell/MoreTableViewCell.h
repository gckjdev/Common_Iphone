//
//  MoreTableViewCell.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MoreTableViewCell : UITableViewCell {
    
    UIActivityIndicatorView *loadingView;
}
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingView;

+ (MoreTableViewCell*)createCell:(UITableView*)tableView;
+ (float)getRowHeight;

@end
