//
//  ImageController.m
//  Dipan
//
//  Created by qqn_pipi on 11-7-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ImageController.h"
#import "PPApplication.h"
#import "UIImageUtil.h"
@implementation ImageController

@synthesize imageView;
@synthesize imageURL;
@synthesize loadImageActivity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    //[loadImageActivity setCenter:[self.view center]];
    return self;
}

- (void)dealloc
{
    [imageView release];
    [loadImageActivity release];
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
    [self setNavigationLeftButton:NSLS(@"Back") action:@selector(clickBack:)];
    [self setNavigationRightButton:NSLS(@"Save") action:@selector(clickSave:)];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [loadImageActivity setHidden:NO];
    [loadImageActivity startAnimating];
    self.imageView.url = [NSURL URLWithString:self.imageURL];
    self.imageView.callbackOnSetImage = self;
    [GlobalGetImageCache() manage:self.imageView]; 
    [self pinchImage:imageView];
    [self moveImage:imageView];
}

- (void)viewDidUnload
{
    [loadImageActivity release];
    loadImageActivity = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

+ (ImageController*)showImageController:(UIViewController*)superController
                               imageURL:(NSString*)imageURL

{
    ImageController* controller = [[ImageController alloc] init];
    controller.imageURL = imageURL;
    NSLog(@"image url = %@",imageURL);
    [superController.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    return controller;
}

-(void) managedImageSet:(HJManagedImageV*)mi
{
    //[self hideActivity];
    
    CGRect origRect = self.imageView.frame;    
    self.imageView.frame = [UIImage shrinkFromOrigRect:origRect imageSize:mi.image.size];    
    [self.imageView setCenter:[self.view center]];
    [loadImageActivity stopAnimating];
    [loadImageActivity setHidden:YES];
}

-(void)pinchImage:(UIView *)view
{
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    [pinchGesture setDelegate:self];
    [imageView addGestureRecognizer:pinchGesture];
    [imageView setTag:IMAGEVIEW_TAG];
    hasGetSize = NO;
    scale = IMAGEVIEW_MIN_SCALE;
    [pinchGesture release];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView *aview = [self.view viewWithTag:IMAGEVIEW_TAG];
    if (touch.view != aview) {
        return NO; 
    }
    return YES;
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer
{
 
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {

        CGFloat tempScale = scale * [gestureRecognizer scale];

        if(tempScale >= IMAGEVIEW_MIN_SCALE && tempScale <= IMAGEVIEW_MAX_SCALE){
           [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
            [gestureRecognizer view].transform = CGAffineTransformScale(gestureRecognizer.view.transform, [gestureRecognizer scale], [gestureRecognizer scale]);
            scale = tempScale;
            
        }
        [gestureRecognizer setScale:1];
        
    }
}


- (void)moveImage:(UIView *)view{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePiece:)];
    [imageView addGestureRecognizer:panRecognizer];
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.delegate = self;
    [imageView setTag:IMAGEVIEW_TAG];
    [panRecognizer release];
}

- (void)movePiece:(UIPinchGestureRecognizer *)gestureRecognizer{
    if (scale <= 1.0) {
        return;
    }

    if ([gestureRecognizer state] != UIGestureRecognizerStateEnded) {
        UIView *aview= gestureRecognizer.view;
        if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
            beginLocation = [gestureRecognizer locationInView:self.view];
        }else if([gestureRecognizer state] == UIGestureRecognizerStateChanged){
            
            CGPoint location = [gestureRecognizer locationInView:self.view];
            CGFloat x = aview.center.x + (location.x - beginLocation.x);
            CGFloat y = aview.center.y + (location.y - beginLocation.y);
            x = MAX(x, self.view.bounds.origin.x);
            x = MIN(x, self.view.bounds.size.width);
            y = MAX(y, self.view.bounds.origin.y); 
            y = MIN(y, self.view.bounds.size.height);
            [aview setCenter:CGPointMake(x, y)];
            beginLocation = location;
        }

    }
}

-(void) managedImageCancelled:(HJManagedImageV*)mi{
    
}
@end
