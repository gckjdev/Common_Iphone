//
//  TextEditorViewController.h
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-5.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"

@protocol TextEditorViewControllerDelegate

- (void)textChanged:(NSString*)newText;

@optional
- (void)clickSend:(NSString*)text;

@end

@interface TextEditorViewController : PPViewController {

	NSString*					inputText;
	NSString*					inputPlaceHolder;
	id							delegate;
	BOOL						isSingleLine;
	BOOL						isNumber;
    BOOL                        hasSendButton;
	
	IBOutlet UITextView*		textView;
}

@property (nonatomic, retain) IBOutlet UITextView*		textView;
@property (nonatomic, retain) NSString*	inputText;
@property (nonatomic, retain) NSString*	inputPlaceHolder;
@property (nonatomic, assign) id		delegate;
@property (nonatomic, assign) BOOL		isSingleLine;
@property (nonatomic, assign) BOOL		isNumber;
@property (nonatomic, assign) BOOL      hasSendButton;

@end
