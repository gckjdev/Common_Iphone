//
//  ProductDetailController.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ProductDetailController.h"
#import "Product.h"
#import "PPWebViewController.h"
#import "TimeUtils.h"
#import "HJObjManager.h"
#import "PPApplication.h"
#import "JSON.h"
#import "GroupBuyReport.h"
#import "TelPickerViewController.h"
#import "ShowAddressViewController.h"
#import "ProductService.h"
#import "ProductManager.h"
#import "ProductCommentsController.h"
#import "TaobaoSearchController.h"
#import "ProductDetailCell.h"
#import "UINavigationBarExt.h"
#import "ActionHandler.h"

enum {
    SECTION_IMAGE,
    SECTION_TITLE,
    SECTION_DATE,
    SECTION_SHOP_ADDRESS,
    SECTION_TEL,    
    SECTION_MORE,
    SECTION_NUM,    
    
    SECTION_PRICE, //not used
    SECTION_DESC,   // not used
};

#define INFO_FONT       ([UIFont systemFontOfSize:12])
#define INFO_WIDTH      305
#define INFO_MAX_SIZE   (CGSizeMake(INFO_WIDTH, 3000))
#define EXTRA_HEIGHT    30

@implementation ProductDetailController

@synthesize product;
@synthesize priceLabel;
@synthesize rebateLabel;
@synthesize saveLabel;
@synthesize boughtLabel;
@synthesize buyButton;
@synthesize savaButton;
@synthesize forwardButton;
@synthesize commetButton;
@synthesize imageView;
@synthesize actionHandler;

+ (void)showProductDetail:(Product*)product navigationController:(UINavigationController*)navigationController isCreateHistory:(BOOL)isCreateHistory
{
    // write to browse history      
    if (isCreateHistory == YES){
        [ProductManager createProductHistory:product];
    }
    
    // report click action
    [GlobalGetProductService() actionOnProduct:product.productId actionName:PRODUCT_ACTION_CLICK actionValue:1];
    
    ProductDetailController* vc = [[ProductDetailController alloc] init];
    vc.product = product;
//    vc.hidesBottomBarWhenPushed = YES;
    [navigationController pushViewController:vc animated:YES];
    [vc release];
}

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
    [product release];
    [priceLabel release];
    [rebateLabel release];
    [saveLabel release];
    [boughtLabel release];
    [imageView release];
    [buyButton release];
    [savaButton release];
    [forwardButton release];
    [commetButton release];
    [actionHandler release];
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
    [GroupBuyReport reportEnterProductDetail:product];

    [self setGroupBuyNavigationTitle:@"商品详情"];
    [self setGroupBuyNavigationBackButton];
    [self setGroupBuyNavigationRightButton:@"淘宝比价" action:@selector(clickTaobaoSearch:)];
        
    self.boughtLabel.text = [product.bought description];
    self.rebateLabel.text = [product.rebate description];
    self.priceLabel.text = [product.price description];

    
    int saveValue = [product.value doubleValue] - [product.price doubleValue];
    if (saveValue < 0.0f)
        saveValue = 0.0f;
    
    self.saveLabel.text = [[NSNumber numberWithDouble:saveValue] description];
    
    [self setBackgroundImageName:@"background.png"];

//    int buttonImageWidth = 31;
//    int buttonTitleWidth = 24;
//    CGSize size = buyButton.titleLabel.frame.size;
//    //    int buttonWidth = 31 + 24; // align with cell xib
//    
//    [self.buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0, buttonImageWidth, 0, 0)];
//    [self.buyButton setImageEdgeInsets:UIEdgeInsetsMake(0, size.width, 0, size.width)];
//    [self.buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.buyButton 
    
    ActionHandler *handler = [[ActionHandler alloc]initWithProduct:product callingViewController:self];
    self.actionHandler = handler;
    [handler release];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setPriceLabel:nil];
    [self setRebateLabel:nil];
    [self setSaveLabel:nil];
    [self setBoughtLabel:nil];
    [self setBuyButton:nil];
    [self setSavaButton:nil];
    [self setForwardButton:nil];
    [self setCommetButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString*)getDesc
{
    NSString* str = @"";
    BOOL needSeperator = NO;
    
    if (product.desc){
        str = [str stringByAppendingString:product.desc];
        needSeperator = YES;
    }
    
    if (product.detail){
        if (needSeperator)
            str = [str stringByAppendingString:@"\n"];
        
        str = [str stringByAppendingString:product.detail];
    }
    
    if ([str length] == 0){
        str = @"介绍信息：请点击更多商品详情";
    }
    
    return str;
}

#define MAX_ITEM    5

- (NSString*)getAddress
{
    NSArray* array = [product addressArray];
    
    if ([array count] == 0){
        return @"商家地址：暂无";
    }   

    NSString* str = @"商家地址：\n";
    int i=0;
    for (NSString* addr in array){
        str = [str stringByAppendingString:addr];
        
        i++;
        if (i >= MAX_ITEM){
            str = [str stringByAppendingString:@"\n......"];
            break;
        }
        
        if ([array lastObject] != addr){
            str = [str stringByAppendingString:@"\n"];
        }
    }
    
    return str;
}

- (NSString*)getTel
{
    NSArray* array = [product telArray];
    
    if ([array count] == 0){
        return @"商家电话：暂无";
    }
    
    NSString* str = @"商家电话：\n";
    int i=0;
    for (NSString* tel in array){
        str = [str stringByAppendingString:tel];
        
        i++;
        if (i >= MAX_ITEM){
            str = [str stringByAppendingString:@"\n......"];
            break;
        }

        if ([array lastObject] != tel){
            str = [str stringByAppendingString:@"\n"];
        }
    }
    
    return str;
}


#pragma mark Table View Delegate

- (NSString*)getTitle:(Product*)productValue
{
    return [NSString stringWithFormat:@"%@\n\n来自: %@", productValue.title, productValue.siteName];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = [groupData titleForSection:section];	    
	return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case SECTION_TITLE:
        {
            NSString* text = [self getTitle:product];     
            CGSize size = [text sizeWithFont:INFO_FONT constrainedToSize:INFO_MAX_SIZE lineBreakMode:UILineBreakModeCharacterWrap];
                           
            return size.height + EXTRA_HEIGHT;
        }
            
        case SECTION_PRICE:
            return 60;
            
        case SECTION_IMAGE:
            return [ProductDetailCell getCellHeight];
            
        case SECTION_DESC:
        {
            NSString* desc = [self getDesc];
            if ([desc length] == 0)
                return 0;
            else{
                CGSize size = [desc sizeWithFont:INFO_FONT constrainedToSize:INFO_MAX_SIZE lineBreakMode:UILineBreakModeCharacterWrap];
                
                return size.height + EXTRA_HEIGHT;
            }
        }
            
        case SECTION_DATE:
            return 60;
            
        case SECTION_SHOP_ADDRESS:
        {
            NSString* addr = [self getAddress];
            if ([addr length] == 0)
                return 0;
            else{
                CGSize size = [addr sizeWithFont:INFO_FONT constrainedToSize:INFO_MAX_SIZE lineBreakMode:UILineBreakModeCharacterWrap];
                
                return size.height + EXTRA_HEIGHT;
            }
        }
            
        case SECTION_TEL:
        {
            NSString* tel = [self getTel];
            if ([tel length] == 0)
                return 0;
            else{
                CGSize size = [tel sizeWithFont:INFO_FONT constrainedToSize:INFO_MAX_SIZE lineBreakMode:UILineBreakModeCharacterWrap];
                
                return size.height + EXTRA_HEIGHT;
            }            
        }
            
        case SECTION_MORE:
            return 44;
                    
            
        default:
            return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SECTION_NUM;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	//return [self getFooterView:tableView section:section];
    UIImage *image = [UIImage imageNamed:@"tu_179.png"];
    UIImageView *footerImageView = [[UIImageView alloc] initWithImage:image];
    [footerImageView setFrame:CGRectMake(7, 0, 320-14, 2)];
    UIView *view = [[[UIView alloc]init]autorelease];
    [view addSubview:footerImageView];
    [footerImageView release];
    return view;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    const int IMAGE_VIEW_TAG = 1299;
    
    UITableViewCell *cell = nil;
    if (indexPath.section == SECTION_IMAGE){
        
         NSString *CellIdentifier = [ProductDetailCell getCellIdentifier];
         ProductDetailCell* productCell = (ProductDetailCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (productCell == nil) {
            productCell = [ProductDetailCell createCell:self];
        }

        [productCell setCellInfo:product];
        productCell.productDetailCellDelegate = self;
        cell = productCell;


    }
    else{
        static NSString *CellIdentifier = @"NormalCell";
        cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				
            cell.selectionStyle = UITableViewCellSelectionStyleNone;	
        }
        [cell.textLabel setTextColor:[UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    }

    cell.textLabel.numberOfLines = 100;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
	switch (indexPath.section) {
        case SECTION_TITLE:
        {            
            cell.textLabel.text = [self getTitle:product];

        }
            break;

            
        case SECTION_DATE:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"从 %@ 至 %@", 
                                   dateToStringByFormat(product.startDate, @"YYYY-MM-dd HH:mm:ss"), dateToStringByFormat(product.endDate, @"YYYY-MM-dd HH:mm:ss")];
        }
            break;
            
        case SECTION_SHOP_ADDRESS:
        {
            cell.textLabel.text = [self getAddress];           
            if ([[self.product addressArray] count] > 0)
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case SECTION_MORE:
        {
            cell.textLabel.text = @"更多商品详情信息";
            cell.textLabel.numberOfLines = 1;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
            break;
            
        case SECTION_TEL:
        {
            cell.textLabel.text = [self getTel]; 
            if ([[self.product telArray] count] > 0)
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            
        default:
            break;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
	
}

- (void)gotoBuy
{    
    NSString* url = nil;
    if ([product.wapURL length] > 0)
        url = product.wapURL;
    else
        url = product.loc;

    [PPWebViewController showForGroupBuy:self url:url];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == SECTION_MORE) {
        [GroupBuyReport reportClickShowProductMore:product];
        [self gotoBuy];
    }else if(indexPath.section == SECTION_TEL){
        NSArray *telArr = [product telArray];
        if(telArr && [telArr count] > 0)
        {
            TelPickerViewController *tvc = [[TelPickerViewController alloc] initWithTelArray:telArr];
            [tvc enableGroupBuySettings];
            [self.navigationController pushViewController:tvc animated:YES];
            [tvc release];
        }
    }else if(indexPath.section == SECTION_SHOP_ADDRESS)
    {
        NSArray *locationArray = [product gpsArray];
        NSArray *addressArray = [product addressArray];
        if (addressArray && [addressArray count] > 0) {
            ShowAddressViewController *savc = [[ShowAddressViewController alloc]initWithLocationArray:locationArray addressList:addressArray];
            [savc enableGroupBuySettings];
            [self.navigationController pushViewController:savc animated:YES];
            [savc release];            
        }
    }
	
//    if (indexPath.section == SECTION_MORE || 
//        indexPath.section == SECTION_TITLE || 
//        indexPath.section == SECTION_IMAGE){
//        [GroupBuyReport reportClickShowProductMore:product];
//        [self gotoBuy];
//    }else if(indexPath.section == SECTION_TEL){
//        NSArray *telArr = [product telArray];
//        if(telArr == nil || [telArr count] == 0)
//        {
//            [GroupBuyReport reportClickShowProductMore:product];
//            [self gotoBuy];
//        }else{
//            TelPickerViewController *tvc = [[TelPickerViewController alloc] initWithTelArray:telArr];
//            [self.navigationController pushViewController:tvc animated:YES];
//            [tvc release];
//        }
//    }else if(indexPath.section == SECTION_SHOP_ADDRESS)
//    {
//        NSArray *locationArray = [product gpsArray];
//        NSArray *addressArray = [product addressArray];
//        if (addressArray && [addressArray count] > 0) {
//            ShowAddressViewController *savc = [[ShowAddressViewController alloc]initWithLocationArray:locationArray addressList:addressArray];
//            [self.navigationController pushViewController:savc animated:YES];
//            [savc release];
//        }
//
//    }
    
}



- (IBAction)clickBuy:(id)sender
{
    [self.actionHandler actionOnBuy];
}

- (IBAction)clickSave:(id)sender
{
    [self.actionHandler actionOnSave];
}
 
- (IBAction)clickForward:(id)sender
{
    [actionHandler actionOnForward];
}

- (IBAction)clickComment:(id)sender
{
    [actionHandler actionOnComment];
}

- (void)clickUp:(id)sender
{
    [GlobalGetProductService() actionOnProduct:product.productId actionName:PRODUCT_ACTION_UP actionValue:1 viewController:self];
}

- (void)clickDown:(id)sender
{
    [GlobalGetProductService() actionOnProduct:product.productId actionName:PRODUCT_ACTION_DOWN actionValue:1 viewController:self];
}


- (void)actionOnProductFinish:(int)result actionName:(NSString *)actionName count:(long)count
{

    
    if ([PRODUCT_ACTION_UP isEqualToString:actionName] || [PRODUCT_ACTION_DOWN isEqualToString:actionName]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:SECTION_IMAGE];
        ProductDetailCell *cell = (ProductDetailCell *)[self.dataTableView cellForRowAtIndexPath:indexPath];
        if ([PRODUCT_ACTION_UP isEqualToString:actionName] ) {
            cell.upLabel.text = [NSString stringWithFormat:@"%i", count];
            self.product.up = [NSNumber numberWithLong:count];
        }else{
            cell.downLabel.text = [NSString stringWithFormat:@"%i", count];
            self.product.down = [NSNumber numberWithLong:count];
        }
    }
}

-(void) managedImageSet:(HJManagedImageV*)mi
{
    NSLog(@"image load done");
}

-(void) managedImageCancelled:(HJManagedImageV*)mi
{
    NSLog(@"image load failure");    
}

//- (void)handleForwardProduct:(NSInteger)buttonIndex
//{    
//    int index = 0;
//    if ([product.title length] > 30){
//        index = 30;
//    }
//    else{
//        index = [product.title length];
//    }
//    
//    NSString* shortDesc = [product.title substringToIndex:index];    
//    NSString* subject = [NSString stringWithFormat:@"［甘橙团购推荐］转发团购产品:%@", shortDesc];    
//    
//    NSString* smsBody = [NSString stringWithFormat:@"%@ %@ - %@", product.loc, 
//                      product.siteName, product.title];
//
//    NSString* htmlBody = [NSString stringWithFormat:@"%@ - %@\n\n%@\n\n来自［甘橙团购]", 
//                         product.siteName, product.title, product.loc];
//    
//    enum{
//        BUTTON_SEND_BY_SMS,
//        BUTTON_SEND_BY_EMAIL,
//        BUTTON_CANCEL
//    };
//    
//    switch (buttonIndex) {
//        case BUTTON_SEND_BY_SMS:
//        {
//            GlobalSetNavBarBackground(nil);
//            [self sendSms:@"" body:smsBody];
//        }
//            break;
//            
//        case BUTTON_SEND_BY_EMAIL:
//        {
//            GlobalSetNavBarBackground(nil);
//            [self sendEmailTo:nil ccRecipients:nil bccRecipients:nil subject:subject body:htmlBody isHTML:NO delegate:self];
//        }
//            break;
//            
//        default:
//            break;
//    }
//}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    [self handleForwardProduct:buttonIndex];
//}

- (void)clickTaobaoSearch:(id)sender
{
    [TaobaoSearchController showController:self text:product.title price:[product.price doubleValue] value:[product.value doubleValue]];    
}

//- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
//{		
//	NSLog(@"<sendSms> result=%d", result);	
//    GlobalSetNavBarBackground(@"navigationbar.png");
//	[self dismissModalViewControllerAnimated:YES];
//    
//}
//
//- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
//{	
//	NSString* text = nil;
//	
//	// Notifies users about errors associated with the interface
//	switch (result)
//	{
//		case MFMailComposeResultCancelled:
//			text = @"<MFMailComposeViewController.didFinishWithResult> Result: canceled";
//			break;
//		case MFMailComposeResultSaved:
//			text = @"<MFMailComposeViewController.didFinishWithResult> Result: saved";
//			break;
//		case MFMailComposeResultSent:
//			text = @"<MFMailComposeViewController.didFinishWithResult> Result: sent";
//			break;
//		case MFMailComposeResultFailed:
//			text = @"<MFMailComposeViewController.didFinishWithResult> Result: failed";
//			break;
//		default:
//			text = @"<MFMailComposeViewController.didFinishWithResult> Result: not sent";
//			break;
//	}
//	
//	NSLog(@"%@", text);
//    GlobalSetNavBarBackground(@"navigationbar.png");    
//	[self dismissModalViewControllerAnimated:YES];
//    
//}


@end
