//
//  UIToolBarCell.h
//  Cells
//
//  Created by Peng Lingzhe on 6/8/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIToolBarCell : UITableViewCell {

	// set by external
	NSMutableArray*	buttonList;
	NSString*		backgroundName;
	int				cellCollapseHeight;
	int				cellExpandHeight;
	
	UILabel*		newTextLabel;
}

@property (nonatomic, retain) NSMutableArray*	buttonList;
@property (nonatomic, retain) NSString*			backgroundName;
@property (nonatomic, retain) UILabel*			newTextLabel;
@property (nonatomic)		  int				cellCollapseHeight;
@property (nonatomic)		  int				cellExpandHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier backgroundImage:(NSString*)backgroundImage buttons:(NSArray*)buttons;
+ (int)getToolbarHeight;
- (void)updateCellRect:(int)heightOfCellWithoutToolbar;

@end
