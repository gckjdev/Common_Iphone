//
//  CityPickerViewController.m
//  CityPicker
//
//  Created by qqn_pipi on 11-7-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CityPickerViewController.h"
#import "UINavigationBarExt.h"
#import "UITableViewCellUtil.h"

@implementation CityPickerViewController
@synthesize cityTableView;
@synthesize cityPickerManager;
@synthesize leftButton;
@synthesize rightButton;
@synthesize selectedCity;
@synthesize defaultCity;
@synthesize delegate;
@synthesize useForGroupBuy;

- (void)dealloc
{
    [selectedCity release];
    [defaultCity release];
    [cityTableView release];
    [cityPickerManager release];
    [leftButton release];
    [rightButton release];
    [delegate release];
    [super dealloc];
}

- (id)initWithCityName:(NSString *)cityName hasLeftButton:(BOOL) hasLeftButton{
    self = [super init];
    if (self) {
        self.defaultCity = cityName;
        self.selectedCity = cityName;
        self.navigationItem.title = @"请选择城市";
        self.useForGroupBuy = YES;
        if (hasLeftButton) {
            if (useForGroupBuy){
                [self setGroupBuyNavigationBackButton];
            }
            else{
                leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onclickBack:)];
                self.navigationItem.leftBarButtonItem = self.leftButton;
            }
        }else {
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.hidesBackButton = YES;
        }
        
        if (useForGroupBuy){
            [self setGroupBuyNavigationRightButton:@"确定" action:@selector(onclickConfirm:)];
        }
        else{
            rightButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onclickConfirm:)];
            [self.rightButton setEnabled:NO];
            self.navigationItem.rightBarButtonItem = self.rightButton;
        }
    }
    return self;
}


- (NSIndexPath *)indexPathForCity:(NSString *)cityName
{
    NSString *province = [self.cityPickerManager getProvinceWithCity:cityName];
    if (province) {
        NSInteger section = [self.cityPickerManager indexForProvince:province];
        NSInteger index = [self.cityPickerManager indexInProvince:province ForCity:cityName];
        return [NSIndexPath indexPathForRow:index inSection:section];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedCity = [self.cityPickerManager getCityWithProvinceIndex:indexPath.section cityIndex:indexPath.row];
    [self.rightButton setEnabled:YES];
    
    [tableView reloadData];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.cityPickerManager getProvince:section];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [cityPickerManager getProviceCount]; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [cityPickerManager getCityCountWithProvinceIndex:section];
}

#define FIRST_CELL_IMAGE    @"tu_56.png"
#define MIDDLE_CELL_IMAGE   @"tu_69.png"
#define LAST_CELL_IMAGE     @"tu_86.png"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				

    }    
    NSString * city = [cityPickerManager getCityWithProvinceIndex:indexPath.section cityIndex:indexPath.row];
   
    cell.textLabel.text = city;
    
    if ([city isEqualToString:selectedCity]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;        
    }
    
    cell.textLabel.textColor = [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:163/255.0 green:155/255.0 blue:143/255.0 alpha:1.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    int count = [self tableView:self.cityTableView numberOfRowsInSection:indexPath.section];
    [cell setCellBackgroundForRow:indexPath.row rowCount:count singleCellImage:nil firstCellImage:FIRST_CELL_IMAGE  middleCellImage:MIDDLE_CELL_IMAGE lastCellImage:LAST_CELL_IMAGE cellWidth:300];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return 74/2;    // the height of background image
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [self.cityPickerManager getProvinceArray];
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return [[self.cityPickerManager getProvinceArray] indexOfObject:title];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#define SECTION_HEIGHT 40

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{    
    UIView* view = [[[UIView alloc] init] autorelease];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, SECTION_HEIGHT)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:190/255.0 green:184/255.0 blue:175/255.0 alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    [view addSubview:label];
    [label release];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return SECTION_HEIGHT;
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    if (!CGRectIsEmpty(self.tableViewFrame)){
        self.cityTableView.frame = self.tableViewFrame;
    }
    
    [super viewDidLoad];
    
    if (!self.useForGroupBuy){
        self.view.backgroundColor = [UIColor clearColor];
    }
    
    self.cityPickerManager = GlobalCityPickerManager();

    self.cityTableView.delegate = self;
    self.cityTableView.dataSource = self;
    
    NSIndexPath *ip=[self indexPathForCity:self.defaultCity];
    
//    [self.cityTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    [self.cityTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)viewDidUnload
{
    [self setCityTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{    
    [super viewDidAppear:animated];
    if (!self.useForGroupBuy){
        self.view.backgroundColor = [UIColor clearColor];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (void)onclickConfirm:(id)sender
{    
    [self onclickBack:nil];

    if ([self.delegate respondsToSelector:@selector(dealWithPickedCity:)]){
		[delegate dealWithPickedCity:selectedCity];
    }
	else{
		NSLog(@"[ERROR] Cannot find cityPicker delegate in CityPickerController");
		return;
	}
}

#define CITY_TABLE_VIEW_FRAME   CGRectMake(8, 8, 304, 480-44-20-8-55-5)

- (void)enableGroupBuySettings
{
    self.cityTableView.backgroundColor = [UIColor clearColor];
    [self setBackgroundImageName:@"background.png"];
    [self setTableViewFrame:CITY_TABLE_VIEW_FRAME];
}

@end
