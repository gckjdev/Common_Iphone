//
//  PPSegmentControl.m
//  groupbuy
//
//  Created by qqn_pipi on 11-10-30.
//  Copyright 1011年 __MyCompanyName__. All rights reserved.
//

#import "PPSegmentControl.h"

#define DEFAULT_SEG_WIDTH 320.0
#define DEFAULT_SEG_HEIGHT 30.0


@implementation PPSegmentControl

@synthesize selectedIndex;
@synthesize buttonWidth;
@synthesize buttonHeight;
@synthesize buttonItems;
@synthesize selectedImageView;
@synthesize segmentBgImageView;
@synthesize selectedSegmentFont;
@synthesize selectedSegmentColor;
@synthesize unSelectedSegmentFont;
@synthesize unSelectedSegmentColor;
@synthesize delegate;


- (void)setDefaultSetting
{
    self.buttonItems = [[NSMutableArray alloc] init];
    self.segmentBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    [self addSubview:self.segmentBgImageView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDefaultSetting];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


- (UIButton *)newAButtonWithTitle:(NSString *)title offset:(CGFloat)offset
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    button.frame = CGRectMake(offset, 0, self.buttonWidth, self.buttonHeight);
    return button;
}

- (NSInteger)selectedSegmentIndex
{
    return self.selectedIndex;
}
- (UIButton *)buttonAtIndex:(NSInteger)index
{
    if (index < 0 || index >= [buttonItems count]) {
        return nil;
    }
    return [buttonItems objectAtIndex:index];
}

- (id)initWithItems:(NSArray*)titleArray 
 defaultSelectIndex:(int)defaultSelectIndex 
            bgImage:(UIImage *)bgImage 
      selectedImage:(UIImage *)selectedImage
{
    self = [super  initWithFrame:CGRectMake(0, 0, DEFAULT_SEG_WIDTH, DEFAULT_SEG_HEIGHT)];    
    if (self) {
        
        [self setDefaultSetting];
        
        self.buttonWidth = 0;
        
        self.buttonHeight = DEFAULT_SEG_HEIGHT;
        if (titleArray && [titleArray count] > 0) {
            self.buttonWidth = DEFAULT_SEG_WIDTH / [titleArray count];
        }
        
        // set background image
        [self.segmentBgImageView setImage:bgImage];
        
        //set selected segment background image
        
        self.selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.buttonWidth, self.buttonHeight)];
        
        [self.selectedImageView setImage:selectedImage];
        
        [self addSubview:self.selectedImageView];
        
        //set segment with buttons.
        int i = 0;
        for (NSString * title in titleArray){
            CGFloat offset = buttonWidth * (i++);
            //create button with title, and set the button action;
            UIButton *button = [self newAButtonWithTitle:title offset:offset];
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonItems addObject:button];
            [self addSubview:button];
        }
        
        //deal with the selected segment
        self.selectedIndex = (defaultSelectIndex < 0 || defaultSelectIndex >= [titleArray count]) ? -1 :defaultSelectIndex;
        UIButton *selectedButton = [self buttonAtIndex:self.selectedIndex];
        if (!selectedButton) {
            [self.selectedImageView setHidden:NO];
        }else{
            [self.selectedImageView setHidden:NO];
            [self.selectedImageView setCenter:selectedButton.center];
        }
    }
    return self;
}



- (UIButton *)getSelectedButton
{
    if (self.selectedIndex < 0 || self.selectedIndex >= [buttonItems count]) {
        return nil;
    }
    return [self.buttonItems objectAtIndex:self.selectedIndex];
}

- (void)setXOffset:(NSInteger)x YOffset:(NSInteger)y
{
    //set background view offset
    [self.segmentBgImageView setFrame:CGRectMake(x, y, segmentBgImageView.frame.size.width, segmentBgImageView.frame.size.height)];
    //set all button offset;
    int offset = x;
    int i = 0;
    for (UIButton *button in buttonItems) {
        [button setFrame:CGRectMake(offset + (i++) * buttonWidth, y, buttonWidth, buttonHeight)];
    }
    
    //set foreground offset;
    [self.selectedImageView setCenter:[self getSelectedButton].center];
}

- (NSString*)titleForSegmentAtIndex:(NSInteger )index
{
    if (index >= 0 && index < [self.buttonItems count]) {
        UIButton *button = [self.buttonItems objectAtIndex:index];
        return button.titleLabel.text;
    }
    return nil;
}

- (void)setUnselectedTextFont:(UIFont *)font color:(UIColor *)color;
{
    self.unSelectedSegmentFont =font;
    self.unSelectedSegmentColor = color;
    
    UIButton *selectedButton = [self getSelectedButton];
    for (UIButton *button in self.buttonItems) {
        if (button && button != selectedButton) {
            [button.titleLabel setFont:font];
            [button setTitleColor:color forState:UIControlStateNormal];
        }
    }
}

- (void)setSelectedTextFont:(UIFont *)font color:(UIColor *)color
{
    self.selectedSegmentColor = color;
    self.selectedSegmentFont = font;
    
    UIButton *button = [self getSelectedButton];
    if (button) {
        [button.titleLabel setFont:font];
        [button setTitleColor:color forState:UIControlStateNormal];
    }
}

- (void)setSelectedBackgroundImage:(NSString*)imageName
{
    [self.selectedImageView setImage:[UIImage imageNamed:imageName]];
}

- (void)setSelectedSegmentIndex:(NSInteger)index
{
    if (index < 0 || index >= [buttonItems count]) {
        self.selectedIndex = -1;
        [self.selectedImageView setHidden:YES];
    }else{
        [self clickButton:[buttonItems objectAtIndex:index]];
    }
}

- (void)setBackgroundImage:(NSString*)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    [self.segmentBgImageView setImage:image];
}

- (void)setSelectedSegmentFrame:(CGRect)frame image:(UIImage *)image
{
    self.selectedImageView.frame = frame;
    [self.selectedImageView setImage:image];
    UIButton *button = [self getSelectedButton];
    [self.selectedImageView setCenter:button.center];
    
}

- (void)clickButton:(id)sender
{    
    UIButton *button = (UIButton *)sender;
    
    UIButton *oldButton = [self getSelectedButton];

    if (button == oldButton) {
        return;
    }
    
    
    self.selectedIndex = [self.buttonItems indexOfObject:button];
    
    //move animation
    if ([self.selectedImageView isHidden]) {
        [self.selectedImageView setCenter:button.center];
        [self.selectedImageView setHidden:NO];
    }
    else
    {
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:0.5];
        [UIImageView setAnimationBeginsFromCurrentState:YES];
        [self.selectedImageView setCenter:button.center];
        [UIImageView commitAnimations];
    }
    
    [button.titleLabel setFont:selectedSegmentFont];
    [button setTitleColor:selectedSegmentColor forState:UIControlStateNormal];
    //set Font
    if (oldButton) {
        [oldButton.titleLabel setFont:unSelectedSegmentFont];
        [oldButton setTitleColor:unSelectedSegmentColor forState:UIControlStateNormal];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSegmentValueChange:)]) {
        [self.delegate didSegmentValueChange:self];
    }
}

- (void)setSegmentFrame:(CGRect)frame
{
    self.frame = frame;
    [self.segmentBgImageView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.buttonHeight = frame.size.height;
    
    if (self.buttonItems && [self.buttonItems count] > 0) {
        self.buttonWidth = frame.size.width / [self.buttonItems count];
        int i = 0;
        for (UIButton *button in self.buttonItems) {
            [button setFrame:CGRectMake(self.buttonWidth * (i ++), 0, buttonWidth, buttonHeight)];
        }
        [self.selectedImageView setCenter:[self getSelectedButton].center];
    }else{
        self.buttonWidth = 0;
    }
    
}

- (void)dealloc
{
    [selectedImageView release];
    [buttonItems release];
    [segmentBgImageView release];
    [selectedSegmentFont release];
    [selectedSegmentColor release];
    [unSelectedSegmentFont release];
    [unSelectedSegmentColor release];
    [super dealloc];
}

@end
