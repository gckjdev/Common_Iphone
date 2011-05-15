//
//  UISwitchCell.h
//  three20test
//
//  Created by qqn_pipi on 10-1-2.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSwitchCellIndent				5
#define kSwitchCellWithTextIndent		150

#define kUISwitchCellFontSize			14

@protocol UISwitchCellDelegate;

@interface UISwitchCell : UITableViewCell {
	
	UISwitch *_switch;

	NSIndexPath* indexPath;
	
	NSObject<UISwitchCellDelegate> *delegate;	
}

@property (nonatomic, retain) UISwitch *_switch;
@property (nonatomic, retain) NSIndexPath* indexPath;
@property (nonatomic, retain) NSObject<UISwitchCellDelegate> *delegate;	


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setText:(NSString *)text;

- (void)switchValueChange:(id)sender;

@end

@protocol UISwitchCellDelegate

- (void)valueChange:(UISwitch *)theSwith atIndex:(NSIndexPath *)indexPath;

@end
