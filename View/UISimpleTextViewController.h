//
//  UISimpleTextViewController.h
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-10.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSelector.h"

#define kDefaultSimpleTextViewTag			8888
#define kSimpleTextTableViewFontSize		14

@interface UISimpleTextViewController : UITableViewController <UITextViewDelegate> {

	UIKeyboardType keyboardType;
	
	NSString* placeHolder;
	
	NSString* inputText;
	
//	ActionSelector* action;
}

@property (nonatomic, retain) NSString* inputText;
@property (nonatomic, retain) NSString* placeHolder;
//@property (nonatomic, retain) ActionSelector* action;

- (id)initWithStyle:(NSString *)aPlaceHolder defaultText:(NSString *)defaultText aKeyboardType:(UIKeyboardType)aKeyboardType frame:(CGRect)frame;

- (void)textInputDone:(UITextView *)textView;

- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
- (void)textViewDidEndEditing:(UITextView *)textView;

@end
