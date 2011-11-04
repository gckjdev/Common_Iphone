//
//  UITextTableViewCell.h
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-9.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kUITextTableViewCellReduceLength 12

#define kLeftLabelWidth				5				// The indent between table and text field

#define kUITextTableViewFontSize	14				// font size in TEXT FIELD

#define kViewTagConstant			99999			// view tag

@protocol UITextTableViewCellDelegate;

@interface UITextTableViewCell : UITableViewCell <UITextFieldDelegate> {
	UITextField* textField;	
	NSIndexPath* indexPath;
	
	NSObject<UITextTableViewCellDelegate> *delegate;
}

@property (nonatomic, retain) UITextField* textField;
@property (nonatomic, retain)   NSIndexPath* indexPath;
@property (nonatomic, retain) NSObject<UITextTableViewCellDelegate>* delegate;

- (CGRect)initTextFieldFrame;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)index;

- (void)textFieldChange:(id)sender;
- (void)textFieldEditBegin:(id)sender;

- (NSString *)getText;

- (void)setText:(NSString *)text;

@end

@protocol UITextTableViewCellDelegate

- (void)textChange:(UITextField *)textField atIndex:(NSIndexPath *)indexPath;
- (void)textEditBegin:(UITextField *)textField atIndex:(NSIndexPath *)indexPath;
- (void)textFieldDone:(UITextField *)textField atIndex:(NSIndexPath *)indexPath;

@end

