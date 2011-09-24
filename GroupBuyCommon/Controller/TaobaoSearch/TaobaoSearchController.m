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

@implementation TaobaoSearchController

@synthesize text;
@synthesize price;
@synthesize value;
@synthesize keywordBackgroundView;
@synthesize searchBar;

+ (TaobaoSearchController*)showController:(UIViewController*)superController 
                                     text:(NSString*)text
                                    price:(double)price
                                    value:(double)value

{
    TaobaoSearchController* vc = [[[TaobaoSearchController alloc] init] autorelease];
    vc.text = text;
    vc.price = price;
    vc.value = value;
    [superController.navigationController pushViewController:vc animated:YES];
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
    [searchBar release];
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
    [self setNavigationLeftButton:@"返回" action:@selector(clickBack:)];
    [self setNavigationRightButton:@"搜索" action:@selector(clickSearch:)];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    CGFloat top = searchBar.frame.origin.y + searchBar.frame.size.height;
    [self addBlankView:top currentResponder:searchBar];

    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [self setKeywordBackgroundView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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
    
    const int START_X = 0;
    const int START_Y = 0;

    int buttonLeft = START_X;
    int buttonTop = START_Y;
    for (int i=0; i<count; i++){
        
        NSString* word = [jsonArray objectAtIndex:i];
        CGSize size = [word sizeWithFont:font];
        int buttonWidth = size.width + BUTTON_WIDTH_EXTEND;    
        
        if (buttonHeight + buttonTop <= bottom){
            UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(buttonLeft, buttonTop, buttonWidth, buttonHeight);        
            [button setTitle:word forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)clickButton:(id)sender
{
    UIButton* button = (UIButton*)sender;
    NSString* title = [button titleForState:UIControlStateNormal];
    NSString* titleAfterTrim = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (searchBar.text == nil){
        searchBar.text = titleAfterTrim;
    }
    else{
        searchBar.text = [searchBar.text stringByAppendingString:titleAfterTrim];
    }
}

- (void)clickSearch:(id)sender
{
    if ([searchBar.text length] == 0){
        [self popupUnhappyMessage:@"还没选择或者输入关键字呢..." title:nil];        
        return;
    }        
    
    [TaobaoSearchResultController showController:self 
                                         keyword:searchBar.text
                                           price:price
                                           value:value];
}

@end
