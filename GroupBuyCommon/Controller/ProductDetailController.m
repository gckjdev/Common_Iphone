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

enum {
    SECTION_TITLE,
    SECTION_IMAGE,
    SECTION_PRICE,

    SECTION_DATE,
    SECTION_SHOP_ADDRESS,
    SECTION_TEL,    
    SECTION_MORE,
    SECTION_NUM,    

    SECTION_DESC,   // not used
};

#define INFO_FONT       ([UIFont systemFontOfSize:14])
#define INFO_WIDTH      305
#define INFO_MAX_SIZE   (CGSizeMake(INFO_WIDTH, 3000))
#define EXTRA_HEIGHT    40

@implementation ProductDetailController

@synthesize product;
@synthesize priceLabel;
@synthesize rebateLabel;
@synthesize saveLabel;
@synthesize boughtLabel;
@synthesize imageView;

@synthesize upLabel;
@synthesize downLabel;

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
    vc.hidesBottomBarWhenPushed = YES;
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
    
    self.navigationItem.title = @"商品详情";
    [self setNavigationLeftButton:@"返回" action:@selector(clickBack:)];
    [self setNavigationRightButton:@"淘宝比价" action:@selector(clickTaobaoSearch:)];
    
    self.boughtLabel.text = [product.bought description];
    self.rebateLabel.text = [product.rebate description];
    self.priceLabel.text = [product.price description];
    self.upLabel.text = [product.up description];
    self.downLabel.text = [product.down description];
    
    int saveValue = [product.value doubleValue] - [product.price doubleValue];
    if (saveValue < 0.0f)
        saveValue = 0.0f;
    
    self.saveLabel.text = [[NSNumber numberWithDouble:saveValue] description];
    
    [self setBackgroundImageName:@"background.png"];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setPriceLabel:nil];
    [self setRebateLabel:nil];
    [self setSaveLabel:nil];
    [self setBoughtLabel:nil];
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
        return @"商家联系电话：暂无";
    }
    
    NSString* str = @"商家联系电话：\n";
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

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView 
//{
//	NSMutableArray* array = [NSMutableArray arrayWithArray:[ArrayOfCharacters getArray]];
//	[array addObject:kSectionNull];
//	return array;
//	
////		NSMutableArray *indices = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
////		return nil;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//	return [groupData sectionForLetter:title];
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = [groupData titleForSection:section];	
	
    //	switch (section) {
    //		case <#constant#>:
    //			<#statements#>
    //			break;
    //		default:
    //			break;
    //	}
	
	return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case SECTION_TITLE:
        {
            NSString* text = product.title;     
            CGSize size = [text sizeWithFont:INFO_FONT constrainedToSize:INFO_MAX_SIZE lineBreakMode:UILineBreakModeCharacterWrap];
                           
            return size.height + EXTRA_HEIGHT;
        }
            
        case SECTION_PRICE:
            return 60;
            
        case SECTION_IMAGE:
            return 160;
            
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



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    const int IMAGE_VIEW_TAG = 1299;
    
    UITableViewCell *cell = nil;
    if (indexPath.section == SECTION_IMAGE){
        static NSString *CellIdentifier = @"ImageCell";
        cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				
            cell.selectionStyle = UITableViewCellSelectionStyleNone;	
            
        }

        self.imageView = [[[HJManagedImageV alloc] init] autorelease];
//        CGRect frame = CGRectMake(10, 10, cell.contentView.frame.size.width - 10, cell.contentView.frame.size.height-10);
        CGRect frame = CGRectMake(5, 5, cell.contentView.frame.size.width - 10, cell.contentView.frame.size.height - 10);
        imageView.frame = frame;
        imageView.tag = IMAGE_VIEW_TAG;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.callbackOnSetImage = self;
        [cell.contentView addSubview:imageView];
        cell.contentView.backgroundColor = [UIColor clearColor];

        [imageView clear];
        imageView.url = [NSURL URLWithString:product.image];
        [GlobalGetImageCache() manage:imageView];

    }
    else{
        static NSString *CellIdentifier = @"NormalCell";
        cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				
            cell.selectionStyle = UITableViewCellSelectionStyleNone;	
            
        }
    }

    cell.textLabel.font = INFO_FONT;
    cell.textLabel.numberOfLines = 100;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
	switch (indexPath.section) {
        case SECTION_TITLE:
        {            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", product.siteName, product.title];
        }
            break;
            
        case SECTION_IMAGE:
        {
            
        }
            break;
            
        case SECTION_PRICE:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"价格 %@  折扣 %@  原价 %@  销量 %@", 
                                   [product.price description], [product.rebate description],
                                   [product.value description], [product.bought description]];
        }
            break;
            
        case SECTION_DESC:
        {
            cell.textLabel.text = [self getDesc];
        }
            break;
            
        case SECTION_DATE:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"开始时间 : %@\n结束时间 : %@", 
                                   dateToStringByFormat(product.startDate, @"YYYY-MM-dd HH:mm:ss"), dateToStringByFormat(product.endDate, @"YYYY-MM-dd HH:mm:ss")];
        }
            break;
            
        case SECTION_SHOP_ADDRESS:
        {
            cell.textLabel.text = [self getAddress];           
            if ([cell.textLabel.text length] > 0)
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
            if ([cell.textLabel.text length] > 0)
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            
        default:
            break;
    }
    
    
    return cell;
	
}

- (void)gotoBuy
{
    PPWebViewController *webController = GlobalGetPPWebViewController();
    [self.navigationController pushViewController:webController animated:YES];
    
    if ([product.wapURL length] > 0)
        [webController openURL:product.wapURL];
    else
        [webController openURL:product.loc];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (indexPath.section == SECTION_MORE){
        [GroupBuyReport reportClickShowProductMore:product];
        [self gotoBuy];
    }else if(indexPath.section == SECTION_TEL){
        NSArray *telArr = [product telArray];
        if(telArr == nil || [telArr count] == 0)
        {
            [GroupBuyReport reportClickShowProductMore:product];
            [self gotoBuy];
        }else{
            TelPickerViewController *tvc = [[TelPickerViewController alloc] initWithTelArray:telArr];
            [self.navigationController pushViewController:tvc animated:YES];
            [tvc release];
        }
    }else if(indexPath.section == SECTION_SHOP_ADDRESS)
    {
        NSArray *locationArray = [product gpsArray];
        NSArray *addressArray = [product addressArray];
        ShowAddressViewController *savc = [[ShowAddressViewController alloc]initWithLocationArray:locationArray addressList:addressArray];
        [self.navigationController pushViewController:savc animated:YES];
        [savc release];
////        AddressListViewController *avc = [[AddressListViewController alloc]initWithLocationArray:locationArray aAddressList:addressArray];
//        [self.navigationController pushViewController:avc animated:YES];
//        [avc release];
    }
    
}



- (IBAction)clickBuy:(id)sender
{
//    TTWebController* webController = GlobalGetWebController();
//    [self.navigationController pushViewController:webController animated:YES];
//    [webController openURL:[NSURL URLWithString:product.loc]];
    
    [GlobalGetProductService() actionOnProduct:product.productId actionName:PRODUCT_ACTION_BUY actionValue:1];
    [GroupBuyReport reportClickBuyProduct:product];
    [self gotoBuy];
}

- (IBAction)clickSave:(id)sender
{
    [GlobalGetProductService() actionOnProduct:product.productId actionName:PRODUCT_ACTION_ADD_FAVORITE actionValue:1];
    [GroupBuyReport reportClickSaveProduct:product];
    if ([ProductManager createProductForFavorite:product]){
        [self popupHappyMessage:@"团购商品收藏成功" title:@"收藏结果"];
    }
}
 
- (IBAction)clickForward:(id)sender
{
    [GlobalGetProductService() actionOnProduct:product.productId actionName:PRODUCT_ACTION_FORWARD actionValue:1];
//    [GroupBuyReport reportClickForwardProduct:product];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLS(@"取消") destructiveButtonTitle:nil otherButtonTitles:NSLS(@"短信转发"), NSLS(@"邮件转发"), nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];

    
}

- (IBAction)clickUp:(id)sender
{
    [GlobalGetProductService() actionOnProduct:product.productId actionName:PRODUCT_ACTION_UP actionValue:1 viewController:self];
}

- (IBAction)clickDown:(id)sender
{
    [GlobalGetProductService() actionOnProduct:product.productId actionName:PRODUCT_ACTION_DOWN actionValue:1 viewController:self];
}

- (IBAction)clickComment:(id)sender
{
    ProductCommentsController *controller = [[ProductCommentsController alloc] init];
    controller.productId = self.product.productId;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)actionOnProductFinish:(int)result actionName:(NSString *)actionName count:(long)count
{
    if ([PRODUCT_ACTION_UP isEqualToString:actionName]) {
        self.upLabel.text = [NSString stringWithFormat:@"%i", count];
        self.product.up = [NSNumber numberWithLong:count];
    } else if ([PRODUCT_ACTION_DOWN isEqualToString:actionName]) {
        self.downLabel.text = [NSString stringWithFormat:@"%i", count];
        self.product.down = [NSNumber numberWithLong:count];
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

- (void)handleForwardProduct:(NSInteger)buttonIndex
{    
    int index = 0;
    if ([product.title length] > 30){
        index = 30;
    }
    else{
        index = [product.title length];
    }
    
    NSString* shortDesc = [product.title substringToIndex:index];    
    NSString* subject = [NSString stringWithFormat:@"［咕噜Buy］转发团购产品:%@", shortDesc];    
    
    NSString* smsBody = [NSString stringWithFormat:@"%@ %@ - %@", product.loc, 
                      product.siteName, product.title];

    NSString* htmlBody = [NSString stringWithFormat:@"%@ - %@\n\n%@\n\n来自［咕噜Buy]", 
                         product.siteName, product.title, product.loc];
    
    enum{
        BUTTON_SEND_BY_SMS,
        BUTTON_SEND_BY_EMAIL,
        BUTTON_CANCEL
    };
    
    switch (buttonIndex) {
        case BUTTON_SEND_BY_SMS:
            [self sendSms:@"" body:smsBody];
            break;
            
        case BUTTON_SEND_BY_EMAIL:
            [self sendEmailTo:nil ccRecipients:nil bccRecipients:nil subject:subject body:htmlBody isHTML:NO delegate:self];
            break;
            
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self handleForwardProduct:buttonIndex];
}

- (void)clickTaobaoSearch:(id)sender
{
    [TaobaoSearchController showController:self text:product.title];    
}

@end
