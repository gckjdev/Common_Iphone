//
//  UIIconSelectViewController.m
//  three20test
//
//  Created by qqn_pipi on 10-2-22.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UIIconSelectViewController.h"
#import "FileUtil.h"
#import "UIUtils.h"
#import "StringUtil.h"
#import "UIImageExt.h"
#import "UIImageUtil.h"

@implementation UIIconSelectViewController

@synthesize iconView, delegate, backgroundImageView, backgroundImage, iconArray, indicatorView, tempDir, nav;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (void)createBackgroundImageViewWithName:(NSString *)name
{
	// set background color to clear
	self.view.backgroundColor = [UIColor clearColor];	
	
	// create a image view
	self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	[backgroundImageView setImage:[UIImage imageNamed:name]];	
	
	// add the image view to current view
	[self.view addSubview:backgroundImageView];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	[super loadView];

	// create background view
	[self createBackgroundImageViewWithName:backgroundImage];	
	
	// create icon view
	if (iconView == nil){
		
		iconView = [[UIIconSelectView alloc] initWithFrame:self.view.bounds];
		
		iconView.delegate = self.delegate;		
		
		[iconView setIconList:self.iconArray];
		
		iconView.backgroundColor = self.view.backgroundColor;
		
		[self.view addSubview:iconView];
	}
		
	// set title
	self.navigationItem.title = kTitleSelectIcon;
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kInfoFromPhoto  style: UIBarButtonItemStylePlain
																						   target:self action:@selector(clickFromPhoto:)];			
//	self.navigationItem.rightBarButtonItem.title = kInfoFromPhoto;
}

#pragma mark Image Picker View

- (void)createIndicatorView
{
	self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];			
	[self.indicatorView setCenter:CGPointMake(160, 208)];
	self.indicatorView.hidesWhenStopped = YES;
	
	[self.view addSubview:self.indicatorView];
}

- (void)startLoading
{
	if (self.indicatorView == nil){				
		[self createIndicatorView];
	}
	
	[self.view bringSubviewToFront:self.indicatorView];					
	[self.indicatorView startAnimating];	
}

- (void)stopLoading
{
	[self.indicatorView stopAnimating];
}

- (void)gotoImagePickerView:(id)sender
{		
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];  
	
	picker.delegate = self;  	
	picker.allowsEditing = YES;  	
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;  
	
	[self presentModalViewController:picker animated:YES];  	
	[picker release]; 	
	
	[self stopLoading];	
}

- (void)clickFromPhoto:(id)sender
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])   
	{  
		// loading...
		[self startLoading];
		
		// show image picker view
		[self performSelector:@selector(gotoImagePickerView:) withObject:@"LoadImageView" afterDelay:0.0f];
	}  
	else {  		
		[UIUtils alert:kMsgFailAccessAlbum];
	}	
}

- (void)imagePickerController:(UIImagePickerController *)picker   
		didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo   
{  
	// generate a file name
	NSString* fileName = [NSString stringWithFormat:@"%@.png", [NSString GetUUID]];	
			
	// save image to local file with temp directory
	NSString* saveImageFileName = [FileUtil getFileFullPath:
								   [NSString stringWithFormat:@"%@%@",								   
								   self.tempDir, fileName]];	
	
	// scale the image to specific size
	UIImage* targetedImage = [image imageByScalingAndCroppingForSize:CGSizeMake(kIconWidth, kIconHeight)];
	
	[targetedImage saveImageToFile:saveImageFileName];
	
	[self.nav dismissModalViewControllerAnimated:NO];  
	
	// invoke delegate function
	if (delegate != nil && [delegate respondsToSelector:@selector(iconSelectView:didSelectImage:imageName:)]) {
        [delegate iconSelectView:nil didSelectImage:targetedImage imageName:fileName];
	}	
}  

#pragma mark Icon Methods

- (void)setIconList:(NSArray *)iconNameArray
{
	[self.iconView setIconList:iconNameArray];
}

- (void)resetSelectedImage
{
	[self.iconView resetSelectedImage];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[backgroundImage release];
	[iconView release];
	[backgroundImageView release];
	[iconArray release];
	[indicatorView release];
	[tempDir release];
	[nav release];
	
    [super dealloc];
}


@end
