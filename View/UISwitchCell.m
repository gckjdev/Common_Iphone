//
//  UISwitchCell.m
//  three20test
//
//  Created by qqn_pipi on 10-1-2.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UISwitchCell.h"


@implementation UISwitchCell

@synthesize _switch, delegate, indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
		// Initialization code
		
		CGRect rect = self.contentView.frame;
		/*
		if (style == UITableViewCellStyleDefault){
			rect.origin.x += kSwitchCellIndent;
			rect.origin.y += kSwitchCellIndent;
			rect.size.width -= kSwitchCellIndent;
			rect.size.height -= kSwitchCellIndent;
		}
		else {*/
			rect.origin.x = kSwitchCellWithTextIndent;
			rect.origin.y += kSwitchCellIndent;
			rect.size.width -= kSwitchCellIndent;
			rect.size.height -= kSwitchCellIndent;			
		//}
		
		_switch = [[UISwitch alloc] initWithFrame:rect];
				
		[self.contentView addSubview:_switch];		
		
		self.textLabel.font = [UIFont boldSystemFontOfSize:kUISwitchCellFontSize];	
		self.textLabel.backgroundColor = [UIColor clearColor];
		
		// disable selection of cell
		self.selectionStyle = UITableViewCellSelectionStyleNone;		
		
		[_switch addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
		
    }
    return self;
}

- (void)setText:(NSString *)text
{
	self.textLabel.text = text;
}

- (void)switchValueChange:(id)sender
{
	NSLog(@"switchValueChange (%d)", self._switch.on);

	if (self.delegate != nil && [delegate respondsToSelector:@selector(valueChange:atIndex:)] == YES){
		[self.delegate valueChange:self._switch atIndex:self.indexPath];
	} 
}


- (void)dealloc {
	
	[_switch release];
	[delegate release];
	[indexPath release];
	
    [super dealloc];
}


@end
