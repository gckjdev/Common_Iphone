//
//  UITextTableViewCell.m
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-9.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import "UITextTableViewCell.h"

@implementation UITextTableViewCell

@synthesize textField, indexPath, delegate;

- (CGRect)initTextFieldFrame
{
	CGRect rect = self.contentView.frame;
	
	rect.origin.x += kLeftLabelWidth;
	rect.origin.y += kUITextTableViewCellReduceLength;
	rect.size.width -= kUITextTableViewCellReduceLength*3;
	rect.size.height -= kUITextTableViewCellReduceLength;	
	
	return rect;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
		// initialize frame
		CGRect rect = [self initTextFieldFrame];		
		self.textField = [[UITextField alloc] initWithFrame:rect];		

		// other basic information
		self.textField.clearsOnBeginEditing = NO;
		self.textField.returnKeyType		= UIReturnKeyDone;
		self.textField.font					= [UIFont boldSystemFontOfSize:kUITextTableViewFontSize];		
		
		// set actions
		[textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
		[textField addTarget:self action:@selector(textFieldEditBegin:) forControlEvents:UIControlEventEditingDidBegin];		
		 
		//self.textField.delegate = self;
		
		// add to cell view
		[self.contentView addSubview:textField];
				
		// disable selection of cell
		self.selectionStyle = UITableViewCellSelectionStyleNone;		
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)index
{
    if (self = [self initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.indexPath = index;
		NSLog(@"index path is %d, %d", [index section], [index row]);
    }
    return self;
}

- (void)dealloc {
	[textField release];
	[indexPath release];
	[delegate release];
    [super dealloc];
}

#pragma mark -
#pragma mark Text Field Methods

- (void)textFieldChange:(id)sender
{	
	NSLog(@"text field change to %@ at (%d, %d)", self.textField.text, self.indexPath.section, self.indexPath.row);
	
	if (self.delegate != nil && [delegate respondsToSelector:@selector(textChange:atIndex:)] == YES){
		[self.delegate textChange:self.textField atIndex:self.indexPath];
	}
}

- (void)textFieldEditBegin:(id)sender
{
	NSLog(@"text field edit begin (%@) at(%d,%d)", self.textField.text, self.indexPath.section, self.indexPath.row);
	
	if (self.delegate != nil && [delegate respondsToSelector:@selector(textEditBegin:atIndex:)] == YES){
		[self.delegate textEditBegin:self.textField atIndex:self.indexPath];
	}
	
	
}
	
- (NSString *)getText
{
	return self.textField.text;
}

- (void)setText:(NSString *)text
{
	self.textField.text = text;
}

- (BOOL)textFieldDone:(id)sender
{
//	[self.textField resignFirstResponder];
	return YES;
}

@end
