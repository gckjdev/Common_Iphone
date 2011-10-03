//
//  CityPickerViewController.m
//  CityPicker
//
//  Created by qqn_pipi on 11-7-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CityPickerViewController.h"

@implementation CityPickerViewController
@synthesize cityTableView;
@synthesize cityPickerManager;
@synthesize leftButton;
@synthesize rightButton;
@synthesize selectedCity;
@synthesize defaultCity;
@synthesize delegate;

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
        if (hasLeftButton) {
            leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onclickBack:)];
            self.navigationItem.leftBarButtonItem = self.leftButton;
        }else {
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.hidesBackButton = YES;
        }
        
        rightButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onclickConfirm:)];
        [self.rightButton setEnabled:NO];
        self.navigationItem.rightBarButtonItem = self.rightButton;
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
    
    return cell;
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

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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



@end
