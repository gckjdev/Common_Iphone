//
//  TelPickerViewController.m
//  TelPicker
//
//  Created by qqn_pipi on 11-8-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TelPickerViewController.h"
#import "UIUtils.h"
#import "UITableViewCellUtil.h"

@implementation TelPickerViewController

@synthesize telArray;
@synthesize telPickerTable;
@synthesize selectedTelNumber;
@synthesize useForGroupBuy;

- (id)initWithTelArray:(NSArray *)telArr{
    self = [super init];
    if (self) {
        self.telArray = telArr;
    }
    return self;
}

- (void)dealloc
{
    [telArray release];
    [telPickerTable release];
    [selectedTelNumber release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{

    
    [super viewDidLoad];

    self.navigationItem.title = @"商家电话列表";        
    
    if (self.useForGroupBuy){
        [self enableGroupBuySettings];        
        if (!CGRectIsEmpty(self.tableViewFrame)){
            self.telPickerTable.frame = self.tableViewFrame;
        }
    }
    else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onclickBack:)];
    }
    
    self.telPickerTable.delegate = self;
    self.telPickerTable.dataSource = self;
}


- (void)viewDidUnload
{
    [self setTelPickerTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - deal with telephone

- (NSString *)parserTelNumber:(NSString *)telNumber
{
    NSMutableString *number = [[[NSMutableString alloc] init]autorelease];
    for (int i = 0; i < [telNumber length]; ++ i) {
        char ch = [telNumber characterAtIndex:i];
        if ((ch >= '0' && ch <= '9') || ch =='+') {
            [number appendFormat:@"%c",ch];
        }else if(ch == '-' || ch == ' '){
            continue;
        }else{
            number = nil;
            return nil;
        }
    }
    return number;
}

- (void)callTelNumber:(NSString *)number
{
    self.selectedTelNumber = [[NSString alloc] initWithFormat:@"tel://%@",number]; 
    NSString *message = [NSString stringWithFormat:@"拨打电话%@吗？",number];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
}
#pragma mark - AlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [UIUtils makeCall:selectedTelNumber];
    }
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *number = [self.telArray objectAtIndex:indexPath.row];
    NSString *parsedNumber = [self parserTelNumber:number];
    if (parsedNumber) {
        [self callTelNumber:parsedNumber];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.telArray count];
    }
    return [self.telArray count];
}

#define FIRST_CELL_IMAGE    @"tu_56.png"
#define MIDDLE_CELL_IMAGE   @"tu_69.png"
#define LAST_CELL_IMAGE     @"tu_86.png"
#define SINGLE_CELL_IMAGE   @"tu_60.png"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];	
    }    
    cell.textLabel.text = [self.telArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    cell.textLabel.textColor = [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:163/255.0 green:155/255.0 blue:143/255.0 alpha:1.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    int count = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    [cell setCellBackgroundForRow:indexPath.row rowCount:count singleCellImage:SINGLE_CELL_IMAGE firstCellImage:FIRST_CELL_IMAGE  middleCellImage:MIDDLE_CELL_IMAGE lastCellImage:LAST_CELL_IMAGE cellWidth:300];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return 74/2;    // the height of background image
}


- (void)onclickBack:(id)sender
{
    int count = [self.navigationController.viewControllers count];
    if (count >= 2){
        UIViewController* vc = [self.navigationController.viewControllers objectAtIndex:count-2];
        vc.hidesBottomBarWhenPushed = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#define CITY_TABLE_VIEW_FRAME   CGRectMake(8, 8, 304, 480-44-20-8-55-5)

- (void)enableGroupBuySettings
{
    self.useForGroupBuy = YES;
    self.telPickerTable.backgroundColor = [UIColor clearColor];
    [self setBackgroundImageName:@"background.png"];
    [self setTableViewFrame:CITY_TABLE_VIEW_FRAME];
    [self setGroupBuyNavigationTitle:self.navigationItem.title];
    [self setGroupBuyNavigationBackButton];
}

@end
