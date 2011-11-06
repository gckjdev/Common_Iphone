//
//  TaobaoSearchController.m
//  groupbuy
//
//  Created by qqn_pipi on 11-9-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TaobaoSearchController.h"
#import "ProductService.h"
#import "TaobaoSearchResultController.h"
#import "UIImageUtil.h"

@implementation TaobaoSearchController

@synthesize text;
@synthesize price;
@synthesize value;
@synthesize keywordBackgroundView;
//@synthesize searchBar;
@synthesize searchTextFieldBackgroundView;
@synthesize searchButton;
@synthesize searchTextField;
@synthesize searchBackgroundView;

+ (TaobaoSearchController*)showController:(UIViewController*)superController 
                                     text:(NSString*)text
                                    price:(double)price
                                    value:(double)value

{
    TaobaoSearchController* vc = [[TaobaoSearchController alloc] init];
    vc.text = text;
    vc.price = price;
    vc.value = value;
//    vc.searchBar.delegate = vc;
    [superController.navigationController pushViewController:vc animated:YES];
    [vc release];
    return vc;
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
    [text release];
    [keywordBackgroundView release];
//    [searchBar release];
    [searchTextField release];
    [searchButton release];
    [searchBackgroundView release];
    [searchTextFieldBackgroundView release];

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)createKeywordView:(NSString*)textForSegment
{
    ProductService* productService = GlobalGetProductService();
    [self showActivityWithText:@"分析商品关键词中..."];
    [productService segmentText:textForSegment delegate:self];            
}

- (void)viewDidLoad
{
    
    [self setBackgroundImageName:@"background.png"];
    
    [self createKeywordView:text];    
    
    self.navigationItem.title = @"比价搜索";
    [self setGroupBuyNavigationTitle:self.navigationItem.title];
    [self setGroupBuyNavigationBackButton];
    
    UIImage* searchTextFieldImage = [UIImage strectchableImageName:@"tu_46-18.png"];
    [self.searchTextFieldBackgroundView setImage:searchTextFieldImage];
    
    // set search button background
    UIImage* buttonBgImage = [UIImage strectchableImageName:@"tu_48.png"];
    [searchButton setBackgroundImage:buttonBgImage forState:UIControlStateNormal];
    
//    [self setNavigationLeftButton:@"返回" action:@selector(clickBack:)];
//    [self setNavigationRightButton:@"搜索" action:@selector(clickSearch:)];
        
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated
{
    int top = searchBackgroundView.frame.size.height + searchBackgroundView.frame.origin.y;
    [self addBlankView:top currentResponder:searchTextField];

    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [self setSearchTextField:nil];
    [self setSearchButton:nil];
    [self setSearchBackgroundView:nil];
    [self setSearchTextFieldBackgroundView:nil];

    [self setKeywordBackgroundView:nil];
//    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#define UNSELECTED_COLOR [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0]
#define SELECTED_COLOR [UIColor colorWithRed:164/255.0 green:174/255.0 blue:67/255.0 alpha:1.0]

- (void)segmentTextFinish:(int)result jsonArray:(NSArray *)jsonArray
{
    const int BUTTON_HEIGHT_INDENT = 5;
    const int BUTTON_WIDTH_INDENT = 5;  
    const int BUTTON_WIDTH_EXTEND = 20;
    const int DEFAULT_BUTTON_HEIGHT = 30;
    
    UIFont* font = [UIFont systemFontOfSize:12];
    
    int buttonHeight =DEFAULT_BUTTON_HEIGHT;
    
    int right = keywordBackgroundView.frame.origin.x + keywordBackgroundView.frame.size.width;
    int bottom = keywordBackgroundView.bounds.origin.y + keywordBackgroundView.bounds.size.height;
    
    [self hideActivity];
    NSLog(@"text number in array : %d", [jsonArray count]);
    int count = [jsonArray count];
    
    UIImage* bgImage = [UIImage strectchableImageName:@"tu_60.png"];
    
    const int START_X = 0;
    const int START_Y = 0;

    int buttonLeft = START_X;
    int buttonTop = START_Y;
    for (int i=0; i<count; i++){
        
        NSString* word = [jsonArray objectAtIndex:i];
        CGSize size = [word sizeWithFont:font];
        int buttonWidth = size.width + BUTTON_WIDTH_EXTEND;    
        
        
        
        if (buttonHeight + buttonTop <= bottom){
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(buttonLeft, buttonTop, buttonWidth, buttonHeight);        
            [button setTitle:word forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:UNSELECTED_COLOR forState:UIControlStateNormal];
            [button setTitleColor:SELECTED_COLOR forState:UIControlStateSelected];
            [button setTitleColor:SELECTED_COLOR forState:UIControlStateHighlighted];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
            [button setBackgroundImage:bgImage forState:UIControlStateNormal];
            [keywordBackgroundView addSubview:button];
        }
        else{
            // reach bottom
            break;
        }
        
        if ( (i+1) < count ){
            NSString* nextWord = [jsonArray objectAtIndex:i+1];
            CGSize size = [nextWord sizeWithFont:font];
            int nextButtonWidth = size.width + BUTTON_WIDTH_EXTEND;
            buttonLeft += buttonWidth + BUTTON_WIDTH_INDENT;
            if (buttonLeft + nextButtonWidth > right){
                buttonTop += buttonHeight + BUTTON_HEIGHT_INDENT;
                buttonLeft = START_X;
            }
        }
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar
{
}

- (void)updateSearchTextField:(NSString*)titleAfterTrim
{
    if (searchTextField.text == nil){
        searchTextField.text = titleAfterTrim;
    }
    else{
        searchTextField.text = [searchTextField.text stringByAppendingString:titleAfterTrim];
    }    
}

- (void)clickButton:(id)sender
{
    UIButton* button = (UIButton*)sender;
    NSString* title = [button titleForState:UIControlStateNormal];
    NSString* titleAfterTrim = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self updateSearchTextField:titleAfterTrim];
}

- (void)clickSearch:(id)sender
{
    if ([searchTextField.text length] == 0){
        [self popupUnhappyMessage:@"还没选择或者输入关键字呢..." title:nil];        
        return;
    }        
    
    [TaobaoSearchResultController showController:self 
                                         keyword:searchTextField.text
                                           price:price
                                           value:value];
}

//-(void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
//{
//    [self.searchBar resignFirstResponder];
//    [self clickSearch:theSearchBar];
//}

- (IBAction)clickSearchButton:(id)sender
{
    [searchTextField resignFirstResponder];
    [self clickSearch:sender];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self clickSearchButton:textField];
    return YES;
}

@end
