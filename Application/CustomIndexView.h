//
//  CustomIndexView.h
//  FreeSMS
//
//  Created by qqn_pipi on 11-3-3.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomIndexView : UIView {

	NSArray*		indexArray;
	UITableView*	tableView;	
	UIImage*		backgroundImage;
	
}

@property (nonatomic, retain) NSArray*		indexArray;
@property (nonatomic, retain) UITableView*	tableView;	
@property (nonatomic, retain) UIImage*		backgroundImage;

- (id)initWithFrame:(CGRect)frame indexArray:(NSArray*)indexArray tableView:(UITableView*)tableView backgroundImage:(NSString*)backgroundImageName;

@end
