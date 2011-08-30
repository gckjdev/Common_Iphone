//
//  ProductWriteCommentController.m
//  groupbuy
//
//  Created by penglzh on 11-8-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ProductWriteCommentController.h"


@implementation ProductWriteCommentController

@synthesize productId;
@synthesize nickNameTextField;
@synthesize contentTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self setNavigationLeftButton:@"取消" action:@selector(cancel)];
    [self setNavigationRightButton:@"提交" action:@selector(submit)];
    [self setNavigationLeftButton:@"取消" action:@selector(clickBack:)];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submit
{
    NSString *nickName = self.nickNameTextField.text;
    NSString *content = self.contentTextView.text;
    
    [GlobalGetProductService() writeCommentWithContent:content nickName:nickName productId:self.productId viewController:self];
    
}

- (void)writeCommentFinish:(int)result
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
