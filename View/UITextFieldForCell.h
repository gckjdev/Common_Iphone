//
//  UITextFieldForCell.h
//  Redial
//
//  Created by Peng Lingzhe on 8/3/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextFieldForCell : UITextField {

	NSIndexPath*	indexPath;
	
}

@property (nonatomic, copy) NSIndexPath*	indexPath;

@end
