//
//  TextEditorViewController.m
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-5.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "TextEditorViewController.h"
#import "TextViewExt.h"
#import "StringUtil.h"

@implementation TextEditorViewController

@synthesize inputText;
@synthesize inputPlaceHolder;
@synthesize delegate;
@synthesize isSingleLine;
@synthesize isNumber;
@synthesize textView;
@synthesize hasSendButton;
@synthesize allowNull;
@synthesize noRoundRect;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	if (isSingleLine){
		CGRect rect = textView.frame;
		rect.size.height = 150;
		textView.frame = rect;
	}
    
	if (isNumber){
		textView.keyboardType = UIKeyboardTypeNumberPad;
	}
    
    if (noRoundRect == NO){
        [textView setRoundRectStyle];	
    }
    else{
        textView.backgroundColor = [UIColor clearColor];
    }
	
    [super viewDidLoad];
	
    if (self.navigationItem.leftBarButtonItem == nil){
        [self setNavigationLeftButton:NSLS(@"Back") action:@selector(clickBack:)];
    }
    
    if (hasSendButton){
        [self setNavigationRightButton:NSLS(@"Send") action:@selector(clickSend:)];
    }
    
	textView.text = inputText;
	[textView becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
	// notify text change when view is dismissed or disappear (for performance purpose)
	if (delegate && [delegate respondsToSelector:@selector(textChanged:)]){
		NSString* text = textView.text;
		if ([text length] > 0 && isNumber){
			int intValue = [textView.text intValue];
			text = [NSString stringWithInt:intValue];
		}
		[delegate textChanged:text];
	}
	
	[super viewDidDisappear:animated];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[inputText release];
	[inputPlaceHolder release];
	[textView release];
    [super dealloc];
}

- (void)clickSend:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(clickSend:)]){
        [delegate clickSend:textView.text];
    }
}

@end
